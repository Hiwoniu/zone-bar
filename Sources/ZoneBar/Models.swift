import Foundation

// MARK: - Shared contract (do not change signatures without updating all users)

/// A time zone the user can pick, with Chinese-friendly display metadata.
struct ZoneInfo: Identifiable, Hashable, Codable {
    /// IANA identifier, e.g. "Asia/Shanghai".
    var id: String
    /// Chinese city name, e.g. "北京".
    var cityZh: String
    /// English city name, e.g. "Beijing".
    var cityEn: String
    /// Short one/two-character Chinese abbreviation, e.g. "京".
    var shortZh: String
    /// Flag emoji, e.g. "🇨🇳".
    var flag: String
    /// Country / region in Chinese, e.g. "中国".
    var countryZh: String
    /// Extra search keywords (pinyin, aliases, abbreviations like "pst", "est").
    var keywords: [String] = []

    var timeZone: TimeZone { TimeZone(identifier: id) ?? .current }
}

enum DisplayMode: String, CaseIterable, Codable, Identifiable {
    case dateOnly, timeOnly, dateTime, custom
    var id: String { rawValue }
    var label: String {
        switch self {
        case .dateOnly: return "只显示日期"
        case .timeOnly: return "只显示时间"
        case .dateTime: return "日期 + 时间"
        case .custom: return "自定义格式"
        }
    }
}

enum PrefixStyle: String, CaseIterable, Codable, Identifiable {
    case flag, shortName, none
    var id: String { rawValue }
    var label: String {
        switch self {
        case .flag: return "国旗"
        case .shortName: return "城市简称"
        case .none: return "不显示"
        }
    }
}

/// All user-facing formatting options in one value type.
struct FormatOptions: Equatable {
    var mode: DisplayMode = .dateTime
    var use24Hour: Bool = true
    var showWeekday: Bool = false
    var showSeconds: Bool = false
    var prefix: PrefixStyle = .flag
    /// Used only when mode == .custom. DateFormatter pattern, e.g. "MM-dd HH:mm".
    var customPattern: String = "MM-dd HH:mm"
}

enum DayPhase {
    case dawn, day, dusk, night
    var label: String {
        switch self {
        case .dawn: return "清晨"
        case .day: return "白天"
        case .dusk: return "傍晚"
        case .night: return "夜里"
        }
    }
    var symbol: String {
        switch self {
        case .dawn: return "sunrise.fill"
        case .day: return "sun.max.fill"
        case .dusk: return "sunset.fill"
        case .night: return "moon.stars.fill"
        }
    }
}
