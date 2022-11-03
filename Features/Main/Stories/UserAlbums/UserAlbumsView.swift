import UIKit
import Photos

class UserAlbumsView: BaseView<UserAlbumsViewState> {

    weak var delegate: UserAlbumsViewDelegate?

    private let tableView = UITableView()
    private let loadingView = LoadingView()

    var items = [UserAlbumsTableItemModel]() {
        didSet {
            reloadTableView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        applyStyles()
        PHPhotoLibrary.shared().register(self)
    }

    private func applyStyles() {
        viewStyle(self)
        tableViewStyle(tableView)
    }

    private func configureSubviews() {
        addSubview(tableView)
        addSubview(loadingView)

        loadingView.fillIgnoreSafeArea(container: self)
        loadingView.isHidden = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func reloadTableView() {
        let transition = CATransition()
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.fillMode = .forwards
        transition.duration = 1.2
        tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        tableView.reloadData()
    }

    override func render(state: UserAlbumsViewState) {
        super.render(state: state)
        self.items = state.items
        if let loadingStatus = state.loadingStatus {
            switch loadingStatus {
            case .idle:
                stopLoading()
            case .loading:
                startLoading()
            default:
                break
            }
        }
    }

    private func startLoading() {
        loadingView.isHidden = false
        tableView.isHidden = true
        loadingView.configureView()
        loadingView.animate()
    }

    private func stopLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
        tableView.isHidden = false
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension UserAlbumsView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: UserAlbumsTableViewCell.identifier
        ) as? UserAlbumsTableViewCell {
            cell.configure(with: items[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.openCollection(items[indexPath.row].collection)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let remove = UIContextualAction(
            style: .destructive,
            title: "Delete") { [weak self] _, _, completion in
                guard let self = self else { return }
                self.delegate?.removeCollection(self.items[indexPath.row].collection!)
                completion(true)
            }
        remove.backgroundColor = UIColor(named: "contentAccentColor")

        let configuration = UISwipeActionsConfiguration(actions: [remove])
        return configuration
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let remove = UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash.fill")!
        ) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.removeCollection(self.items[indexPath.row].collection!)
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "Actions", children: [remove])
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension UserAlbumsView: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            if let _ = changeInstance.changeDetails(for: PhotoLibraryManager.shared.getUserCollections()) {
                delegate?.reloadData()
            }
        }
    }
}

// MARK: Styles

extension UserAlbumsView {

    private func viewStyle(_ view: UIView) {
        view.backgroundColor = .black
    }

    private func tableViewStyle(_ view: UITableView) {
        view.tableHeaderView = UIView(frame: .zero)
        view.tableFooterView = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.rowHeight = 60.0
        view.delegate = self
        view.dataSource = self
        view.register(UserAlbumsTableViewCell.self, forCellReuseIdentifier: UserAlbumsTableViewCell.identifier)
    }
}
