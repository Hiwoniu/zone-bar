import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var state: AppState

    @State private var showPrimaryPicker = false
    @State private var showExtraPicker = false
    @State private var launchAtLogin = LaunchAtLogin.isEnabled
    @State private var launchError: String?

    private var previewTitle: String {
        ZoneFormatter.menuBarTitle(zone: state.primaryZone, date: state.now, options: state.options)
    }

    var body: some View {
        Form {
            primarySection
            formatSection
            prefixSection
            previewSection
            otherSection
            extrasSection
            Section {
                Text("ZoneBar 1.1 · 小而专的两地时钟")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .formStyle(.grouped)
        .frame(width: 460)
        .frame(minHeight: 520)
        .onAppear { launchAtLogin = LaunchAtLogin.isEnabled }
    }

    // MARK: Sections

    private var primarySection: some View {
        Section("状态栏时区") {
            HStack {
                let z = state.primaryZone
                Text(z.flag)
                Text(z.cityZh)
                Text("\(z.countryZh) · \(ZoneFormatter.gmtLabel(zone: z, date: state.now))")
                    .foregroundStyle(.secondary)
                Spacer()
                Button(showPrimaryPicker ? "收起" : "更改…") {
                    withAnimation { showPrimaryPicker.toggle() }
                }
            }
            if showPrimaryPicker {
                ZonePickerView(onPick: { zone in
                    state.makePrimary(zone.id)
                    withAnimation { showPrimaryPicker = false }
                }, selectedID: state.primaryZoneID)
            }
        }
    }

    private var formatSection: some View {
        Section("显示格式") {
            Picker("显示内容", selection: $state.options.mode) {
                ForEach(DisplayMode.allCases) { Text($0.label).tag($0) }
            }
            .pickerStyle(.menu)
            Toggle("24 小时制", isOn: $state.options.use24Hour)
            Toggle("显示星期", isOn: $state.options.showWeekday)
            Toggle("显示秒", isOn: $state.options.showSeconds)
            if state.options.mode == .custom {
                VStack(alignment: .leading, spacing: 4) {
                    TextField("自定义格式", text: $state.options.customPattern, prompt: Text("MM-dd HH:mm"))
                        .font(.body.monospaced())
                    Text("可用记号：yyyy 年 · MM 月 · dd 日 · HH 时(24) · hh 时(12) · mm 分 · ss 秒 · a 上午/下午 · EEE 星期")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("预览：\(previewTitle)")
                        .font(.caption.monospacedDigit())
                }
            }
        }
    }

    private var prefixSection: some View {
        Section("前缀标识") {
            Picker("前缀", selection: $state.options.prefix) {
                ForEach(PrefixStyle.allCases) { Text($0.label).tag($0) }
            }
            .pickerStyle(.segmented)
        }
    }

    private var previewSection: some View {
        Section("预览") {
            HStack {
                Text("状态栏显示")
                Spacer()
                Text(previewTitle)
                    .monospacedDigit()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.primary.opacity(0.08)))
            }
        }
    }

    private var otherSection: some View {
        Section("其他") {
            Toggle("显示农历", isOn: $state.showLunar)
            Toggle("开机自启动", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { newValue in
                    guard newValue != LaunchAtLogin.isEnabled else { launchError = nil; return }
                    do {
                        try LaunchAtLogin.set(newValue)
                        launchError = nil
                    } catch {
                        launchError = "设置失败：\(error.localizedDescription)"
                    }
                    let actual = LaunchAtLogin.isEnabled
                    if actual != launchAtLogin { launchAtLogin = actual }
                }
            if let launchError {
                Text(launchError)
                    .font(.caption)
                    .foregroundStyle(.red)
            } else {
                Text(LaunchAtLogin.statusDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var extrasSection: some View {
        Section("下拉菜单时区") {
            let zones = state.extraZones
            if zones.isEmpty {
                Text("暂无其他时区").foregroundStyle(.secondary)
            }
            ForEach(zones) { zone in
                HStack {
                    Text(zone.flag)
                    Text(zone.cityZh)
                    Text(ZoneFormatter.gmtLabel(zone: zone, date: state.now))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(ZoneFormatter.shortTime(zone: zone, date: state.now, use24Hour: state.options.use24Hour))
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                    Button {
                        state.removeExtra(zone.id)
                    } label: {
                        Image(systemName: "minus.circle.fill").foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                    .help("移除")
                }
            }
            Button {
                withAnimation { showExtraPicker.toggle() }
            } label: {
                Label(showExtraPicker ? "收起" : "添加时区…", systemImage: showExtraPicker ? "chevron.up" : "plus")
            }
            if showExtraPicker {
                ZonePickerView(onPick: { zone in
                    state.addExtra(zone.id)
                    withAnimation { showExtraPicker = false }
                })
            }
        }
    }
}
