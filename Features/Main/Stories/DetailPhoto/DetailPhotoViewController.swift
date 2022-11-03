import UIKit

class DetailPhotoViewController: BaseViewController<DetailPhotoView, DetailPhotoViewIntent,
                                 DetailPhotoViewState, DetailPhotoViewModel> {

    var configuration: DetailPhotoViewConfiguration!
    private let transitionDelegate = ZoomTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        viewModel.sendIntent(.initialize(asset: configuration.asset))
        getView().delegate = self
    }

    private func setupNavigation() {
        navigationController?.delegate = transitionDelegate
        navigationItem.title = configuration.asset.title
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

extension DetailPhotoViewController: DetailPhotoViewDelegate {

    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailPhotoViewController: ZoomingViewController {

    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        return getView().imageView
    }

    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView? {
        nil
    }
}
