import UIKit

class MainRouter: BaseRouter {

    public static let shared = MainRouter()
    private override init() {}

    func openOnboarding(onCompletion completion: ((Bool) -> Void)? = nil) {
        guard let window = UIApplication.shared.rootWindow else {
            return
        }

        let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
        let initialRootViewController = keyWindow?.rootViewController
        keyWindow?.rootViewController = OnboardingViewController()

        initialRootViewController?.dismiss(animated: false) {
            initialRootViewController?.view.removeFromSuperview()
        }

        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: nil
        ) { _ in
            completion?(true)
        }
    }

    func routeToMainScreen(onCompletion completion: ((Bool) -> Void)? = nil) {
        guard let window = UIApplication.shared.rootWindow else {
            return
        }

        let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
        let initialRootViewController = keyWindow?.rootViewController
        keyWindow?.rootViewController = BaseNavigationController(rootViewController: UserAlbumsViewController())

        initialRootViewController?.dismiss(animated: false) {
            initialRootViewController?.view.removeFromSuperview()
        }

        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: nil
        ) { _ in
            completion?(true)
        }
    }

    func openCollection(with title: String) {
        let controller = AlbumCollectionViewController()
        controller.configuration = AlbumCollectionViewConfiguration(collectionTitle: title)
        show(controller)
    }

    func openDetailedPhoto(with image: UIImage, _ title: String) {
        let controller = DetailPhotoViewController()
        controller.configuration = DetailPhotoViewConfiguration(image: image, title: title)
        show(controller)
    }
}
