import UIKit

extension UIViewController {

    class func topmostRoot() -> UIViewController {
        var topController = rootViewController()
        while let controller = topController.presentedViewController {
            topController = controller
        }
        return topController
    }

    class func rootViewController() -> UIViewController {
        guard let rootViewController = UIApplication.shared.rootWindow?.rootViewController else {
            return UIViewController()
        }
        return rootViewController
    }
}
