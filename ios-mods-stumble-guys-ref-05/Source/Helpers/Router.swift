import Foundation
import UIKit

class Router {

    static let shared = Router()

    private init() {}

    private var currentController: UIViewController = UIViewController()

    func setCurrentViewController(_ controller: UIViewController) -> Void {
        self.currentController = controller
    }

    func getCurrentViewController() -> UIViewController {
        return currentController
    }

    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = currentController.navigationController?.viewControllers.last(where: { $0.isKind(of: ofClass)}) {
            currentController.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    func pop(animated: Bool? = true) -> Void {
        if let tabBarController = currentController.tabBarController {
            tabBarController.navigationController?.popViewController(animated: animated ?? true)
        }
        else if let navigationController = currentController.navigationController {
            navigationController.popViewController(animated: animated ?? true)
        }
        else {
            currentController.navigationController?.popViewController(animated: animated ?? true)
        }
    }

    func show(_ viewController: UIViewController, completion: (() -> ())? = nil) -> Void {
        if let tabBarController = currentController.tabBarController {
            tabBarController.present(viewController, animated: true, completion: completion)
        } else {
            currentController.present(viewController, animated: true, completion: completion)
        }
    }
    
    func dismiss(completion: (() -> ())? = nil) {
        if let tabBarController = currentController.tabBarController {
            tabBarController.dismiss(animated: true, completion: completion)
        } else if let navigationController = currentController.navigationController {
            navigationController.dismiss(animated: true, completion: completion)
        } else {
            currentController.dismiss(animated: true, completion: completion)
        }
    }
    func share(text: String) {
        
        let items = ["Кім ақылды екенін тексерейік? \n\nБонус алу промо-коды:\(text)\n\nAqyl Battle ойынын төмендегі сілтемеге өтіп, жүктеп алыңыз... \nhttps://onelink.to/nbqxhv"]
        self.show(UIActivityViewController(activityItems: items, applicationActivities: nil))
    }
    
    func shareWSFeedback(){
        let urlStringEncoded = "".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        guard let appURL = URL(string: "https://wa.me/\("+77079467141")?text=\(urlStringEncoded)") else { print("WRONG whatsapp URL"); return; }
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }
    }
}
