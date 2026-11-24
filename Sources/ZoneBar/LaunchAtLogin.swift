import Foundation
import ServiceManagement

/// Thin wrapper over SMAppService (macOS 13+).
enum LaunchAtLogin {
    static var isEnabled: Bool { SMAppService.mainApp.status == .enabled }

    static func set(_ enabled: Bool) throws {
        let service = SMAppService.mainApp
        if enabled {
            guard service.status != .enabled else { return }
            try service.register()
        } else {
            guard service.status == .enabled || service.status == .requiresApproval else { return }
            try service.unregister()
        }
    }

    static var statusDescription: String {
        switch SMAppService.mainApp.status {
        case .enabled: return "已开启"
        case .notRegistered: return "未开启"
        case .requiresApproval: return "需要在 系统设置 > 通用 > 登录项 中允许"
        case .notFound: return "未找到应用（请将应用放到“应用程序”文件夹后再试）"
        @unknown default: return "状态未知"
        }
    }
}
