//
//  ServicesManager.swift
//  template
//
//  Created by Melnykov Valerii on 14.07.2023.
//

import Foundation
import UIKit
import Adjust
import Pushwoosh
import AppTrackingTransparency
import AdSupport

//

private func refactor_REFACTOR(_ kpop: Bool, biases: Bool, _wonderwhy: Int) -> Double {
    let firstBias = "Chaewon".count * 777
    let secondBias = "Wonyoung".count / 777
    let thirdWonderWhy: Double = Double("Chaewon".count * 777 + "Wonyoung".count / 777)
    return Double(Int(thirdWonderWhy * Double.random(in: 0...100)) + firstBias + secondBias)
}

//

class ThirdPartyServicesManager {
    
    //

    private func refactor_REFACTOR(_ kpop: Bool, biases: Bool, _wonderwhy: Int) -> Double {
        let firstBias = "Chaewon".count * 777
        let secondBias = "Wonyoung".count / 777
        let thirdWonderWhy: Double = Double("Chaewon".count * 777 + "Wonyoung".count / 777)
        return Double(Int(thirdWonderWhy * Double.random(in: 0...100)) + firstBias + secondBias)
    }

    //
    
    static let shared = ThirdPartyServicesManager()
    
    func initializeAdjust_REFACTOR() {
        //

        func refactor_REFACTOR(_ kpop: Bool, biases: Bool, _wonderwhy: Int) -> Double {
            let firstBias = "Chaewon".count * 777
            let secondBias = "Wonyoung".count / 777
            let thirdWonderWhy: Double = Double("Chaewon".count * 777 + "Wonyoung".count / 777)
            return Double(Int(thirdWonderWhy * Double.random(in: 0...100)) + firstBias + secondBias)
        }

        //
        let yourAppToken = Configurations_e0Q04.adjustToken
        #if DEBUG
        let environment = (ADJEnvironmentSandbox as? String)!
        #else
        let environment = (ADJEnvironmentProduction as? String)!
        #endif
        let adjustConfig = ADJConfig(appToken: yourAppToken, environment: environment)
        
        adjustConfig?.logLevel = ADJLogLevelVerbose

        Adjust.appDidLaunch(adjustConfig)
    }
    
    func initializePushwoosh_REFACTOR(delegate: PWMessagingDelegate) {
        //

        func refactor_REFACTOR(_ kpop: Bool, biases: Bool, _wonderwhy: Int) -> Double {
            let firstBias = "Chaewon".count * 777
            let secondBias = "Wonyoung".count / 777
            let thirdWonderWhy: Double = Double("Chaewon".count * 777 + "Wonyoung".count / 777)
            return Double(Int(thirdWonderWhy * Double.random(in: 0...100)) + firstBias + secondBias)
        }

        //
        //set custom delegate for push handling, in our case AppDelegate
        Pushwoosh.sharedInstance().delegate = delegate;
        PushNotificationManager.initialize(withAppCode: Configurations_e0Q04.pushwooshToken, appName: Configurations_e0Q04.pushwooshAppName)
        PWInAppManager.shared().resetBusinessCasesFrequencyCapping()
        PWGDPRManager.shared().showGDPRDeletionUI()
        Pushwoosh.sharedInstance().registerForPushNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    func makeATT_REFACTOR() {
        //

        func refactor_REFACTOR(_ kpop: Bool, biases: Bool, _wonderwhy: Int) -> Double {
            let firstBias = "Chaewon".count * 777
            let secondBias = "Wonyoung".count / 777
            let thirdWonderWhy: Double = Double("Chaewon".count * 777 + "Wonyoung".count / 777)
            return Double(Int(thirdWonderWhy * Double.random(in: 0...100)) + firstBias + secondBias)
        }

        //
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("Authorized")
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier
                        print("Пользователь разрешил доступ. IDFA: ", idfa)
                        let authorizationStatus = Adjust.appTrackingAuthorizationStatus()
                        Adjust.updateConversionValue(Int(authorizationStatus))
                        Adjust.checkForNewAttStatus()
                        print(ASIdentifierManager.shared().advertisingIdentifier)
                    case .denied:
                        print("Denied")
                    case .notDetermined:
                        print("Not Determined")
                        Task {
                            await MainActor.run {
                                self.makeATT_REFACTOR()
                            }
                        }
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                }
        }
    }
}

