import UIKit
import Photos

class AlbumCollectionViewController: BaseViewController<AlbumCollectionView, AlbumCollectionViewIntent,
                                     AlbumCollectionViewState, AlbumCollectionViewModel> {

    var configuration: AlbumCollectionViewConfiguration!
    private let transitionDelegate = ZoomTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        viewModel.collection = configuration.collection
        viewModel.sendIntent(.initialize)
        getView().delegate = self
    }

    private func setupNavigationItem() {
        if let title = configuration.collection?.localizedTitle {
            navigationItem.title = title
        } else {
            navigationItem.title = "All Photos"
        }
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = transitionDelegate
    }
}

extension AlbumCollectionViewController: AlbumCollectionViewDelegate {

    func openDetailPage(with asset: PHAsset) {
        viewModel.sendIntent(.openDetailedPage(asset: asset))
    }

    func removeAsset(_ asset: PHAsset) {
        viewModel.sendIntent(.removeAsset(asset: asset))
    }

    func dismiss() {
        MainRouter.shared.popCurrentViewController(animated: true)
    }
}

extension AlbumCollectionViewController: ZoomingViewController {

    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        return getView().getCellImageView()
    }

    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView? {
        return nil
    }
}
