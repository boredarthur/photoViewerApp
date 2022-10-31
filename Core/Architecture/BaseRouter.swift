import UIKit

class BaseRouter {

    func show(_ controller: UIViewController) {
        DispatchQueue.main.async {
            UIViewController.topmostRoot().show(controller, sender: nil)
        }
    }

    func popCurrentViewController(animated: Bool = true) {
        DispatchQueue.main.async {
            if let navigationController = UIViewController.topmostRoot() as? UINavigationController {
                navigationController.popViewController(animated: animated)
            } else {
                UINavigationController.topmostRoot().dismiss(animated: true)
            }
        }
    }
}
