import UIKit
import Photos

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

    func openCollection(_ collection: PHAssetCollection?) {
        let controller = AlbumCollectionViewController()
        controller.configuration = AlbumCollectionViewConfiguration(collection: collection)
        show(controller)
    }

    func openDetailedPhoto(with asset: PHAsset) {
        let controller = DetailPhotoViewController()
        controller.configuration = DetailPhotoViewConfiguration(asset: asset)
        show(controller)
    }
}
