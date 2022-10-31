import UIKit

class AlbumCollectionViewController: BaseViewController<AlbumCollectionView, AlbumCollectionViewIntent,
                                     AlbumCollectionViewState, AlbumCollectionViewModel> {

    var configuration: AlbumCollectionViewConfiguration!
    private let transitionDelegate = ZoomTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        viewModel.sendIntent(.initialize)
        viewModel.sendIntent(.fetchAssets(collectionTitle: configuration.collectionTitle  ))
        getView().delegate = self
    }

    private func setupNavigationItem() {
        navigationItem.title = configuration.collectionTitle
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = transitionDelegate
    }
}

extension AlbumCollectionViewController: AlbumCollectionViewDelegate {

    func openDetailPage(for photo: UIImage, _ title: String) {
        viewModel.sendIntent(.openDetailedPage(photo: photo, title: title))
    }

    func removeAsset(with localIdentifier: String) {
        viewModel.sendIntent(.removeAsset(localIdentifier: localIdentifier))
    }

    func refreshAssets() {
        viewModel.sendIntent(.fetchAssets(collectionTitle: configuration.collectionTitle))
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
