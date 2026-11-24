import SwiftUI
import AppKit

enum Clipboard {
    static func copy(_ text: String) {
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(text, forType: .string)
    }
}

struct MenuContentView: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.openWindow) private var openWindow

    @State private var showPicker = false
    @State private var copiedMain = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            Divider()
            extrasSection
            addSection
            Divider()
            footer
        }
        .padding(12)
        .frame(width: 320)
        .onAppear { AppDelegate.shared?.ticker?.forceSeconds = true }
        .onDisappear {
            AppDelegate.shared?.ticker?.forceSeconds = false
            showPicker = false
        }
    }

    // MARK: Header

    private var header: some View {
        let zone = state.primaryZone
        let now = state.now
        let phase = ZoneFormatter.dayPhase(zone: zone, date: now)
        let full = ZoneFormatter.fullDateTime(zone: zone, date: now, use24Hour: state.options.use24Hour)

        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(zone.flag).font(.title3)
                Text(zone.cityZh).font(.headline)
                Text(zone.countryZh).font(.subheadline).foregroundStyle(.secondary)
                Spacer()
                if ZoneFormatter.isDST(zone: zone, date: now) {
                    Text("夏令时")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.orange.opacity(0.2)))
                        .foregroundStyle(.orange)
                }
            }

            Button {
                Clipboard.copy("\(zone.cityZh) \(full)")
                withAnimation { copiedMain = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation { copiedMain = false }
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    Text(full)
                        .font(.system(size: 17, weight: .medium, design: .monospaced))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Spacer(minLength: 0)
                    if copiedMain {
                        Label("已复制", systemImage: "checkmark")
                            .font(.caption)
                            .foregroundStyle(.green)
                            .transition(.opacity)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("点击复制时间")

            HStack(spacing: 10) {
                Label(phase.label, systemImage: phase.symbol)
                    .symbolRenderingMode(.multicolor)
                Text(ZoneFormatter.gmtLabel(zone: zone, date: now))
                Text("本地 \(ZoneFormatter.offsetDescription(zone: zone, date: now))")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if let note = ZoneFormatter.upcomingDSTNote(zone: zone, date: now) {
                Label(note, systemImage: "clock.arrow.2.circlepath")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

            if state.showLunar {
                Label("\(ZoneFormatter.lunarYearGanzhi(zone: zone, date: now)) \(ZoneFormatter.lunarString(zone: zone, date: now))",
                      systemImage: "moon.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.primary.opacity(0.05)))
    }

    // MARK: Extras

    @ViewBuilder
    private var extrasSection: some View {
        let zones = state.extraZones
        VStack(alignment: .leading, spacing: 2) {
            Text("其他时区")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 6)
            if zones.isEmpty {
                Text("还没有添加其他时区")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
            } else {
                ForEach(zones) { zone in
                    ExtraZoneRow(zone: zone, date: state.now, use24Hour: state.options.use24Hour,
                                 onSelect: { state.makePrimary(zone.id) },
                                 onRemove: { state.removeExtra(zone.id) })
                }
            }
        }
    }

    // MARK: Add

    private var addSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HoverButton {
                withAnimation(.easeInOut(duration: 0.15)) { showPicker.toggle() }
            } label: {
                Label(showPicker ? "收起" : "添加时区…",
                      systemImage: showPicker ? "chevron.up" : "plus.circle")
            }
            if showPicker {
                ZonePickerView(onPick: { zone in
                    state.addExtra(zone.id)
                    withAnimation(.easeInOut(duration: 0.15)) { showPicker = false }
                })
            }
        }
    }

    // MARK: Footer

    private var footer: some View {
        HStack {
            HoverButton {
                openWindow(id: "settings")
                NSApp.activate(ignoringOtherApps: true)
            } label: {
                Label("设置…", systemImage: "gearshape")
            }
            Spacer()
            HoverButton {
                NSApp.terminate(nil)
            } label: {
                Label("退出", systemImage: "power")
            }
        }
    }
}

// MARK: - Row

private struct ExtraZoneRow: View {
    let zone: ZoneInfo
    let date: Date
    let use24Hour: Bool
    let onSelect: () -> Void
    let onRemove: () -> Void

    @State private var hovering = false
    @State private var copied = false

    private var timeText: String { ZoneFormatter.shortTime(zone: zone, date: date, use24Hour: use24Hour) }

    var body: some View {
        let phase = ZoneFormatter.dayPhase(zone: zone, date: date)
        let day = ZoneFormatter.relativeDay(zone: zone, date: date)

        HStack(spacing: 8) {
            Text(zone.flag)
            VStack(alignment: .leading, spacing: 0) {
                Text(zone.cityZh)
                Text(ZoneFormatter.offsetDescription(zone: zone, date: date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 4)
            Image(systemName: phase.symbol)
                .font(.caption)
                .symbolRenderingMode(.multicolor)
                .help(phase.label)
            VStack(alignment: .trailing, spacing: 0) {
                Text(timeText)
                    .monospacedDigit()
                if day != "今天" {
                    Text(day)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Button(action: copy) {
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                    .font(.caption)
                    .foregroundStyle(copied ? Color.green : Color.secondary)
                    .frame(width: 16)
            }
            .buttonStyle(.plain)
            .help("复制时间")
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 5)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(hovering ? Color.primary.opacity(0.08) : Color.clear)
        )
        .onHover { hovering = $0 }
        .onTapGesture(perform: onSelect)
        .help("点击设为状态栏显示")
        .contextMenu {
            Button("设为状态栏显示", action: onSelect)
            Button("复制时间", action: copy)
            Divider()
            Button("移除", role: .destructive, action: onRemove)
        }
    }

    private func copy() {
        Clipboard.copy("\(zone.cityZh) \(timeText)")
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { copied = false }
    }
}

// MARK: - Hover button

struct HoverButton<L: View>: View {
    let action: () -> Void
    @ViewBuilder let label: () -> L
    @State private var hovering = false

    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> L) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: action) {
            label()
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(hovering ? Color.primary.opacity(0.08) : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
    }
}
