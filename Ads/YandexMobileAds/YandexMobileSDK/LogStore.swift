import Foundation
import UIKit

extension String {
    mutating func appendWithSeparator(contentsOf newElements: String) {
        self.append(contentsOf: newElements)
        self.append(contentsOf: "\n")
    }
}
//MARK: - LoggerData
final class LogData {
    var data: String = ""
}

struct LogStore {
    static let shared = LogStore()
    private init() {}
    
    enum `Type` {
        case banner
        case intersitial
        case rewarded
    }
    
    enum LogStoreError: String, Error {
        case `default` = "Default error"
    }

    func data(_ viewController: UIViewController) throws -> LogData {
        _data[try defineTypeByViewController(viewController)] ?? LogData()
    }
    
    private func defineTypeByViewController(_ viewController: UIViewController) throws -> `Type` {
        if viewController is BannerViewController { return .banner }
        if viewController is InterstitialViewController { return .intersitial }
        if viewController is RewardedViewController { return .rewarded }
        
        throw LogStoreError.default
    }
    
    private let _data: [`Type`: LogData] = [
        .banner: LogData(),
        .intersitial: LogData(),
        .rewarded: LogData()
    ]
    

}
