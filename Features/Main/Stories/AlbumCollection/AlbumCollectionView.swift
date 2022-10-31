import UIKit
import Photos

class AlbumCollectionView: BaseView<AlbumCollectionViewState> {

    weak var delegate: AlbumCollectionViewDelegate?

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let loadingView = LoadingView()

    private var selectedIndexPath: IndexPath!

    private var items = [AlbumCollectionItemModel]() {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        applyStyles()
        PHPhotoLibrary.shared().register(self)
    }

    private func configureSubviews() {
        addSubview(collectionView)
        addSubview(loadingView)

        loadingView.fillIgnoreSafeArea(container: self)
        loadingView.isHidden = true
        collectionView.fill(container: self, padding: 10)
    }

    private func applyStyles() {
        viewStyle(self)
        collectionViewStyle(collectionView)
    }

    override func render(state: AlbumCollectionViewState) {
        super.render(state: state)
        self.items = state.items
        if let loadingStatus = state.loadingStatus {
            switch loadingStatus {
            case .idle:
                stopLoading()
            case .loading:
                startLoading()
            }
        }
    }

    private func startLoading() {
        loadingView.isHidden = false
        collectionView.isHidden = true
        loadingView.configureView()
        loadingView.animate()
    }

    private func stopLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
        collectionView.isHidden = false
    }

    func getCellImageView() -> UIImageView? {
        if let indexPath = selectedIndexPath {
            let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell
            return cell?.imageView
        }
        return nil
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension AlbumCollectionView: UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumCollectionViewCell {
            cell.configure(with: items[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.row == items.count - 4 {
            delegate?.refreshAssets()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedIndexPath = indexPath
        delegate?.openDetailPage(for: items[indexPath.row].image, items[indexPath.row].title)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        let availableWidth = width - (5 * 4)
        let itemDimension = floor(availableWidth / 3)
        return CGSize(width: itemDimension, height: itemDimension)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let remove = UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash.fill")!
        ) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.removeAsset(with: self.items[indexPaths.first!.row].localIdentifier)
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "Actions", children: [remove])
        }
    }
}

extension AlbumCollectionView: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.refreshAssets()
    }
}

extension AlbumCollectionView {

    @objc private func dismiss() {
        delegate?.dismiss()
    }
}

// MARK: Styles

extension AlbumCollectionView {

    private func viewStyle(_ view: UIView) {
        view.backgroundColor = .black

        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismiss))
        rightSwipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(rightSwipeGestureRecognizer)
    }

    private func collectionViewStyle(_ view: UICollectionView) {
        view.backgroundColor = .black
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = false
        view.delegate = self
        view.dataSource = self
        view.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        view.collectionViewLayout = flowLayout
    }
}
