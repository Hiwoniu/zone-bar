import SwiftUI

struct ZonePickerView: View {
    var onPick: (ZoneInfo) -> Void
    var selectedID: String? = nil

    @EnvironmentObject private var state: AppState
    @State private var query: String = ""

    private var trimmedQuery: String { query.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("搜索城市、国家或时区，如 北京 / tokyo / PST", text: $query)
                    .textFieldStyle(.plain)
                if !query.isEmpty {
                    Button {
                        query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("清除")
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.primary.opacity(0.06)))

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    if trimmedQuery.isEmpty {
                        sectionHeader("常用")
                        ForEach(TimeZoneCatalog.common) { row($0) }
                        sectionHeader("全部")
                        ForEach(TimeZoneCatalog.all) { row($0) }
                    } else {
                        let results = TimeZoneCatalog.search(trimmedQuery)
                        if results.isEmpty {
                            Text("没有找到匹配的时区")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 20)
                        } else {
                            ForEach(results) { row($0) }
                        }
                    }
                }
            }
            .frame(maxHeight: 280)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 6)
            .padding(.top, 8)
            .padding(.bottom, 2)
    }

    private func row(_ zone: ZoneInfo) -> some View {
        ZonePickerRow(
            zone: zone,
            date: state.now,
            use24Hour: state.options.use24Hour,
            isSelected: zone.id == selectedID
        ) {
            onPick(zone)
        }
    }
}

private struct ZonePickerRow: View {
    let zone: ZoneInfo
    let date: Date
    let use24Hour: Bool
    let isSelected: Bool
    let action: () -> Void

    @State private var hovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(zone.flag)
                VStack(alignment: .leading, spacing: 0) {
                    Text(zone.cityZh)
                    Text(zone.cityEn)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 4)
                VStack(alignment: .trailing, spacing: 0) {
                    Text(ZoneFormatter.shortTime(zone: zone, date: date, use24Hour: use24Hour))
                        .monospacedDigit()
                    Text(ZoneFormatter.gmtLabel(zone: zone, date: date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Image(systemName: "checkmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.accentColor)
                    .opacity(isSelected ? 1 : 0)
                    .frame(width: 14)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
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
