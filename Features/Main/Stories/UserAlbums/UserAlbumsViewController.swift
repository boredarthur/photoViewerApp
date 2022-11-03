import UIKit
import Photos

class UserAlbumsViewController: BaseViewController<UserAlbumsView, UserAlbumsViewIntent,
                                UserAlbumsViewState, UserAlbumsViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        viewModel.sendIntent(.initialize)
        getView().delegate = self
    }

    private func setupNavigationItem() {
        navigationItem.title = "My Albums"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createCollection)
        )
    }
}

extension UserAlbumsViewController {

    @objc fileprivate func createCollection() {
        viewModel.sendIntent(.createCollection)
    }
}

extension UserAlbumsViewController: UserAlbumsViewDelegate {

    func reloadData() {
        viewModel.sendIntent(.initialize)
    }

    func openCollection(_ collection: PHAssetCollection?) {
        viewModel.sendIntent(.openCollection(collection: collection))
    }

    func removeCollection(_ collection: PHAssetCollection) {
        viewModel.sendIntent(.removeCollection(collection: collection))
    }
}
