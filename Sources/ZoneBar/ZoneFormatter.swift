import Foundation

/// Pure formatting helpers. Thread-safe (formatter cache is lock-guarded).
enum ZoneFormatter {

    // MARK: - Formatter cache

    private final class FormatterCache: @unchecked Sendable {
        private var storage: [String: DateFormatter] = [:]
        private let lock = NSLock()
        private let locale = Locale(identifier: "zh_CN")

        func formatter(pattern: String, timeZone: TimeZone, calendar: Calendar.Identifier = .gregorian) -> DateFormatter {
            let key = "\(pattern)|\(timeZone.identifier)|\(calendar)"
            lock.lock(); defer { lock.unlock() }
            if let f = storage[key] { return f }
            let f = DateFormatter()
            f.locale = locale
            var cal = Calendar(identifier: calendar)
            cal.timeZone = timeZone
            cal.locale = locale
            f.calendar = cal
            f.timeZone = timeZone
            f.dateFormat = pattern
            if storage.count > 200 { storage.removeAll() }
            storage[key] = f
            return f
        }
    }

    private static let cache = FormatterCache()

    private static func format(_ date: Date, _ pattern: String, _ zone: ZoneInfo) -> String {
        cache.formatter(pattern: pattern, timeZone: zone.timeZone).string(from: date)
    }

    private static func timePattern(use24Hour: Bool, seconds: Bool) -> String {
        if use24Hour { return seconds ? "HH:mm:ss" : "HH:mm" }
        return seconds ? "ah:mm:ss" : "ah:mm"   // zh_CN → "下午6:50"
    }

    // MARK: - Menu bar

    static func menuBarTitle(zone: ZoneInfo, date: Date, options: FormatOptions) -> String {
        var parts: [String] = []
        switch options.prefix {
        case .flag: if !zone.flag.isEmpty { parts.append(zone.flag) }
        case .shortName: if !zone.shortZh.isEmpty { parts.append(zone.shortZh) }
        case .none: break
        }

        let time = timePattern(use24Hour: options.use24Hour, seconds: options.showSeconds)
        let weekday = options.showWeekday ? "EEE" : nil   // "周二"

        switch options.mode {
        case .dateOnly:
            parts.append(format(date, "M/d", zone))
            if let w = weekday { parts.append(format(date, w, zone)) }
        case .timeOnly:
            if let w = weekday { parts.append(format(date, w, zone)) }
            parts.append(format(date, time, zone))
        case .dateTime:
            parts.append(format(date, "M/d", zone))
            if let w = weekday { parts.append(format(date, w, zone)) }
            parts.append(format(date, time, zone))
        case .custom:
            let p = options.customPattern.trimmingCharacters(in: .whitespaces)
            parts.append(format(date, p.isEmpty ? "MM-dd HH:mm" : p, zone))
        }
        return parts.joined(separator: " ")
    }

    // MARK: - Dropdown

    /// "2026年11月24日 星期二 18:50:07" / "2026年11月24日 星期二 下午6:50:07"
    static func fullDateTime(zone: ZoneInfo, date: Date, use24Hour: Bool) -> String {
        format(date, "y年M月d日 EEEE " + timePattern(use24Hour: use24Hour, seconds: true), zone)
    }

    /// "18:50" / "下午6:50"
    static func shortTime(zone: ZoneInfo, date: Date, use24Hour: Bool) -> String {
        format(date, timePattern(use24Hour: use24Hour, seconds: false), zone)
    }

    /// "+13 小时", "-5.5 小时", "+2 小时 45 分", "与本地相同"
    static func offsetDescription(zone: ZoneInfo, date: Date) -> String {
        let diff = zone.timeZone.secondsFromGMT(for: date) - TimeZone.current.secondsFromGMT(for: date)
        if diff == 0 { return "与本地相同" }
        let sign = diff > 0 ? "+" : "-"
        let totalMin = abs(diff) / 60
        let h = totalMin / 60, m = totalMin % 60
        switch m {
        case 0: return "\(sign)\(h) 小时"
        case 30: return "\(sign)\(h).5 小时"
        default: return h == 0 ? "\(sign)\(m) 分" : "\(sign)\(h) 小时 \(m) 分"
        }
    }

    /// "今天" / "明天" / "昨天" — zone's calendar date vs local calendar date.
    static func relativeDay(zone: ZoneInfo, date: Date) -> String {
        func dayNumber(_ tz: TimeZone) -> Int {
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = tz
            let c = cal.dateComponents([.year, .month, .day], from: date)
            var utc = Calendar(identifier: .gregorian)
            utc.timeZone = TimeZone(identifier: "UTC")!
            let d = utc.date(from: c) ?? date
            return Int((d.timeIntervalSince1970 / 86400).rounded(.down))
        }
        switch dayNumber(zone.timeZone) - dayNumber(.current) {
        case 0: return "今天"
        case 1: return "明天"
        case -1: return "昨天"
        case let n where n > 0: return "\(n) 天后"
        case let n: return "\(-n) 天前"
        }
    }

    /// "GMT+8", "GMT-3:30", "GMT"
    static func gmtLabel(zone: ZoneInfo, date: Date) -> String {
        let s = zone.timeZone.secondsFromGMT(for: date)
        if s == 0 { return "GMT" }
        let sign = s > 0 ? "+" : "-"
        let totalMin = abs(s) / 60
        let h = totalMin / 60, m = totalMin % 60
        return m == 0 ? "GMT\(sign)\(h)" : String(format: "GMT%@%d:%02d", sign, h, m)
    }

    static func isDST(zone: ZoneInfo, date: Date) -> Bool {
        zone.timeZone.isDaylightSavingTime(for: date)
    }

    /// "11月2日 夏令时结束（-1 小时）" if a transition is within 30 days, else nil.
    static func upcomingDSTNote(zone: ZoneInfo, date: Date) -> String? {
        let tz = zone.timeZone
        guard let t = tz.nextDaylightSavingTimeTransition(after: date),
              t.timeIntervalSince(date) <= 30 * 86400 else { return nil }
        let before = tz.secondsFromGMT(for: t.addingTimeInterval(-1))
        let after = tz.secondsFromGMT(for: t.addingTimeInterval(1))
        let delta = after - before
        guard delta != 0 else { return nil }
        let starting = tz.isDaylightSavingTime(for: t.addingTimeInterval(1))
        let mins = abs(delta) / 60
        let amount: String
        if mins % 60 == 0 { amount = "\(mins / 60) 小时" }
        else if mins < 60 { amount = "\(mins) 分" }
        else { amount = "\(mins / 60) 小时 \(mins % 60) 分" }
        let sign = delta > 0 ? "+" : "-"
        let day = format(t.addingTimeInterval(1), "M月d日", zone)
        return "\(day) \(starting ? "夏令时开始" : "夏令时结束")（\(sign)\(amount)）"
    }

    /// 5-7 dawn, 7-17 day, 17-19 dusk, else night (zone-local hour).
    static func dayPhase(zone: ZoneInfo, date: Date) -> DayPhase {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = zone.timeZone
        switch cal.component(.hour, from: date) {
        case 5..<7: return .dawn
        case 7..<17: return .day
        case 17..<19: return .dusk
        default: return .night
        }
    }

    // MARK: - Lunar

    private static let lunarMonths = ["正月", "二月", "三月", "四月", "五月", "六月",
                                      "七月", "八月", "九月", "十月", "冬月", "腊月"]
    private static let digits = ["", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
    private static let stems = Array("甲乙丙丁戊己庚辛壬癸").map(String.init)
    private static let branches = Array("子丑寅卯辰巳午未申酉戌亥").map(String.init)
    private static let animals = Array("鼠牛虎兔龙蛇马羊猴鸡狗猪").map(String.init)

    private static func lunarDayName(_ d: Int) -> String {
        switch d {
        case 1...10: return "初" + digits[d]
        case 11...19: return "十" + digits[d - 10]
        case 20: return "二十"
        case 21...29: return "廿" + digits[d - 20]
        case 30: return "三十"
        default: return "\(d)"
        }
    }

    private static func chineseComponents(zone: ZoneInfo, date: Date) -> DateComponents {
        var cal = Calendar(identifier: .chinese)
        cal.timeZone = zone.timeZone
        return cal.dateComponents([.era, .year, .month, .day], from: date)
    }

    /// "农历十月廿四", "农历闰六月初一"
    static func lunarString(zone: ZoneInfo, date: Date) -> String {
        let c = chineseComponents(zone: zone, date: date)
        guard let m = c.month, let d = c.day, (1...12).contains(m) else { return "" }
        let leap = (c.isLeapMonth ?? false) ? "闰" : ""
        return "农历" + leap + lunarMonths[m - 1] + lunarDayName(d)
    }

    /// "丙午马年"
    static func lunarYearGanzhi(zone: ZoneInfo, date: Date) -> String {
        let c = chineseComponents(zone: zone, date: date)
        guard let y = c.year else { return "" }
        let i = ((y - 1) % 60 + 60) % 60   // year 1 of a cycle = 甲子
        return stems[i % 10] + branches[i % 12] + animals[i % 12] + "年"
    }
}
