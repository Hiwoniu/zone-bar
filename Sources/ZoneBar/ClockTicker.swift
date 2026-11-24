import AppKit
import Combine
import Foundation

/// Drives `AppState.now`, firing exactly on whole minutes (or seconds when needed).
@MainActor
final class ClockTicker {
    private let state: AppState
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var observerTokens: [(NotificationCenter, NSObjectProtocol)] = []

    /// When true (dropdown open), tick every second regardless of options.
    var forceSeconds: Bool = false {
        didSet { if forceSeconds != oldValue { restart() } }
    }

    init(state: AppState) {
        self.state = state

        let ws = NSWorkspace.shared.notificationCenter
        let nc = NotificationCenter.default
        let pairs: [(NotificationCenter, Notification.Name)] = [
            (ws, NSWorkspace.didWakeNotification),
            (nc, .NSSystemTimeZoneDidChange),
            (nc, .NSSystemClockDidChange),
        ]
        for (center, name) in pairs {
            let token = center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
                MainActor.assumeIsolated { self?.restart() }
            }
            observerTokens.append((center, token))
        }

        state.$options
            .map { ClockTicker.needsSeconds($0) }
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] _ in
                // @Published emits in willSet; defer so state.options holds the new value.
                DispatchQueue.main.async { self?.restart() }
            }
            .store(in: &cancellables)
    }

    deinit {
        timer?.invalidate()
        for (center, token) in observerTokens { center.removeObserver(token) }
    }

    private static func needsSeconds(_ o: FormatOptions) -> Bool {
        if o.showSeconds { return true }
        if o.mode == .custom {
            // Literal text in quotes doesn't count; good-enough check for an "s" field.
            let unquoted = o.customPattern.split(separator: "'", omittingEmptySubsequences: false)
                .enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }.joined()
            return unquoted.contains("s")
        }
        return false
    }

    private var perSecond: Bool { forceSeconds || ClockTicker.needsSeconds(state.options) }

    func start() {
        timer?.invalidate()
        let now = Date()
        state.now = now
        schedule(after: now)
    }

    func restart() {
        timer?.invalidate()
        timer = nil
        start()
    }

    private func schedule(after now: Date) {
        let interval: TimeInterval = perSecond ? 1 : 60
        let t = now.timeIntervalSince1970
        let next = (floor(t / interval) + 1) * interval
        let fire = Date(timeIntervalSince1970: next)
        let timer = Timer(fire: fire, interval: 0, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated { self?.tick() }
        }
        timer.tolerance = perSecond ? 0.1 : 1.0
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func tick() {
        let now = Date()
        state.now = now
        schedule(after: now)
    }
}
