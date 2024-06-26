//
//  SceneDelegate.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 20.11.2023.
//

import UIKit
import DeviceKit
import DataCache

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static var shared: SceneDelegate!
    
    var window: UIWindow?
    var viewModel = EditorViewModel_e0Q04()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        Self.shared = self
        
        NetworkStatusMonitor_e0Q04.shared.checkInternetConnectivity()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
        
        let notificationName = Notification.Name("MyNotification")
        func fetchEditor() {
            DispatchQueue.main.async {
                self.viewModel = EditorViewModel_e0Q04()
                
                self.viewModel.fetchData_e0Q04 { editorData in
                    self.viewModel.boyCategories = editorData.editor.boy
                    self.viewModel.girlCategories = editorData.editor.girl
                    self.viewModel.preloadAllImages {
                        print("All images and previews preloaded and cached.")
                        if self.viewModel.dataLoaded == false {
                            self.viewModel.dataLoaded = true
                            // Отправка уведомления о завершении загрузки
                            NotificationCenter.default.post(name: notificationName, object: nil)
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            fetchEditor()
            let homeVC = ModsViewController_e0Q04()
            let navigationController = UINavigationController(rootViewController: homeVC)
            UIApplication.shared.setRootVC(navigationController)
            UIApplication.shared.notificationFeedbackGenerator(type: .success)
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            ThirdPartyServicesManager.shared.makeATT_REFACTOR()
        }
    }
    
}
