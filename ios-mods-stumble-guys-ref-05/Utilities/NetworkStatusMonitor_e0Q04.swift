//  Created by Melnykov Valerii on 14.07.2023
//

import Foundation
import SystemConfiguration
import UIKit

protocol NetworkStatusMonitorDelegate : AnyObject {
    func showMess()
}

class NetworkStatusMonitor_e0Q04 {
    static let shared = NetworkStatusMonitor_e0Q04()
    
    weak var delegate : NetworkStatusMonitorDelegate?
    
    private var didShowAlert = false
    private var isDropboxInitialized = false
    private var configs = Configs_e0Q04.shared
    private var dateChecker = FileDateChecker_e0Q04.shared

    public private(set) var isNetworkAvailable: Bool = true {
        didSet {
            if !isNetworkAvailable {
                DispatchQueue.main.async {
                    print("No internet connection.")
                    if !self.didShowAlert {
                        ConnectivityScreenHelper_e0Q04.shared.show()
                        self.didShowAlert = true
//                        self.delegate?.showMess()
                    }
                }
            } else {
                self.didShowAlert = false
//                print("Internet connection is active.")
                
                FileDateChecker_e0Q04.shared.checkForFileDateChanges(
                    filePath: DropboxAuthManagerConstants.modsFilePath, userDefaultsDateKey: "modsLastModifiedDate", userDefaultsFlagKey: "modsFileHasChanged"
                )
                FileDateChecker_e0Q04.shared.checkForFileDateChanges(
                    filePath: DropboxAuthManagerConstants.hacksFilePath, userDefaultsDateKey: "hacksLastModifiedDate", userDefaultsFlagKey: "hacksFileHasChanged"
                )
                FileDateChecker_e0Q04.shared.checkForFileDateChanges(
                    filePath: DropboxAuthManagerConstants.tipsFilePath, userDefaultsDateKey: "skinsLastModifiedDate", userDefaultsFlagKey: "skinsFileChanged"
                )
                FileDateChecker_e0Q04.shared.checkForFileDateChanges(
                    filePath: DropboxAuthManagerConstants.editorFilePath, userDefaultsDateKey: "editorLastModifiedDate", userDefaultsFlagKey: "editorFileChanged"
                )
                FileDateChecker_e0Q04.shared.checkForFileDateChanges(
                    filePath: DropboxAuthManagerConstants.charactersFilePath, userDefaultsDateKey: "charactersLastModifiedDate", userDefaultsFlagKey: "charactersFileHasChanged"
                )
                FileDateChecker_e0Q04.shared.checkForFileDateChanges(
                    filePath: DropboxAuthManagerConstants.locationsFilePath, userDefaultsDateKey: "locationsLastModifiedDate", userDefaultsFlagKey: "locationsFileHasChanged"
                )
            }
        }
    }

    private init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            self.isNetworkAvailable = self.checkInternetConnectivity()
        })
    }

    @discardableResult
    func checkInternetConnectivity() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        if isReachable && !needsConnection {
            // Connected to the internet
            // Do your network-related tasks here
            
            if !isDropboxInitialized {
                DropboxAuthManager_e0Q04.shared.initDropBox()
                isDropboxInitialized = true
                print("Dropbox initialized")
            }
            
            return true
        } else {
            // Not connected to the internet
            return false
        }
    }
    
}
