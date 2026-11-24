import Foundation
import SwiftUI

/// Single source of truth. Persists to UserDefaults. Lives on the main actor.
@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()

    private let defaults = UserDefaults.standard

    /// The zone shown in the menu bar.
    @Published var primaryZoneID: String { didSet { save() } }
    /// Extra zones listed in the dropdown (v1.1). Always contains primaryZoneID-free list; order kept.
    @Published var extraZoneIDs: [String] { didSet { save() } }
    @Published var options: FormatOptions { didSet { save() } }
    @Published var showLunar: Bool { didSet { save() } }

    /// Updated by ClockTicker; views observe this to re-render.
    @Published var now: Date = Date()

    private init() {
        let d = UserDefaults.standard
        primaryZoneID = d.string(forKey: "primaryZoneID") ?? "Asia/Shanghai"
        extraZoneIDs = d.stringArray(forKey: "extraZoneIDs") ?? ["America/New_York", "Europe/London", "Asia/Tokyo"]
        var o = FormatOptions()
        if let m = d.string(forKey: "mode"), let v = DisplayMode(rawValue: m) { o.mode = v }
        if d.object(forKey: "use24Hour") != nil { o.use24Hour = d.bool(forKey: "use24Hour") }
        o.showWeekday = d.bool(forKey: "showWeekday")
        o.showSeconds = d.bool(forKey: "showSeconds")
        if let p = d.string(forKey: "prefix"), let v = PrefixStyle(rawValue: p) { o.prefix = v }
        if let c = d.string(forKey: "customPattern"), !c.isEmpty { o.customPattern = c }
        options = o
        showLunar = d.object(forKey: "showLunar") == nil ? true : d.bool(forKey: "showLunar")
    }

    private func save() {
        defaults.set(primaryZoneID, forKey: "primaryZoneID")
        defaults.set(extraZoneIDs, forKey: "extraZoneIDs")
        defaults.set(options.mode.rawValue, forKey: "mode")
        defaults.set(options.use24Hour, forKey: "use24Hour")
        defaults.set(options.showWeekday, forKey: "showWeekday")
        defaults.set(options.showSeconds, forKey: "showSeconds")
        defaults.set(options.prefix.rawValue, forKey: "prefix")
        defaults.set(options.customPattern, forKey: "customPattern")
        defaults.set(showLunar, forKey: "showLunar")
    }

    var primaryZone: ZoneInfo { TimeZoneCatalog.info(for: primaryZoneID) }
    var extraZones: [ZoneInfo] { extraZoneIDs.filter { $0 != primaryZoneID }.map(TimeZoneCatalog.info(for:)) }

    /// Make `id` the menu-bar zone; the previous primary moves into the extra list.
    func makePrimary(_ id: String) {
        guard id != primaryZoneID else { return }
        let old = primaryZoneID
        var extras = extraZoneIDs.filter { $0 != id }
        if !extras.contains(old) { extras.insert(old, at: 0) }
        extraZoneIDs = extras
        primaryZoneID = id
    }

    func addExtra(_ id: String) {
        guard id != primaryZoneID, !extraZoneIDs.contains(id) else { return }
        extraZoneIDs.append(id)
    }

    func removeExtra(_ id: String) { extraZoneIDs.removeAll { $0 == id } }
}
