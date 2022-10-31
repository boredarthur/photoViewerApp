import UIKit

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

    func openCollection(with title: String) {
        viewModel.sendIntent(.openCollection(title: title))
    }

    func refreshCollections() {
        viewModel.sendIntent(.initialize)
    }

    func removeCollection(with title: String) {
        viewModel.sendIntent(.removeCollection(title: title))
    }
}
