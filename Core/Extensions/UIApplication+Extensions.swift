import UIKit

extension UIApplication {

    public var rootWindow: UIWindow? {
        return
            (UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate)?.window ?? nil
    }
}
