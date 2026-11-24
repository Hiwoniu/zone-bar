import SwiftUI
import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var shared: AppDelegate?
    private(set) var ticker: ClockTicker?

    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.shared = self
        NSApp.setActivationPolicy(.accessory)
        let t = ClockTicker(state: AppState.shared)
        t.start()
        ticker = t
    }
}

@main
struct ZoneBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var state = AppState.shared

    init() {
        // First launch: place the status item as far right as macOS allows (next to the clock).
        // register(defaults:) never overrides a position the user later sets by ⌘-dragging.
        UserDefaults.standard.register(defaults: ["NSStatusItem Preferred Position Item-0": 1.0])
    }

    var body: some Scene {
        MenuBarExtra {
            MenuContentView()
                .environmentObject(state)
        } label: {
            MenuBarLabel(state: state)
        }
        .menuBarExtraStyle(.window)

        Window("ZoneBar 设置", id: "settings") {
            SettingsView()
                .environmentObject(state)
        }
        .windowResizability(.contentSize)
    }
}

/// Separate view so the label re-renders whenever `state.now` / options change.
struct MenuBarLabel: View {
    @ObservedObject var state: AppState

    var body: some View {
        Text(ZoneFormatter.menuBarTitle(zone: state.primaryZone, date: state.now, options: state.options))
            .monospacedDigit()
    }
}
