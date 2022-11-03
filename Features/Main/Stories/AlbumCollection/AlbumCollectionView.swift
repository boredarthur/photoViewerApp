import UIKit
import Photos

class AlbumCollectionView: BaseView<AlbumCollectionViewState> {

    weak var delegate: AlbumCollectionViewDelegate?

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    // Empty state
    private let stackView = UIStackView()
    private let questionMarkImageView = UIImageView()
    private let emptyTitleLabel = UILabel()

    private var selectedIndexPath: IndexPath!
    private var previousPreheatRect = CGRect.zero

    var fetchResult: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>() {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        applyStyles()

        previousPreheatRect = .zero
        PHPhotoLibrary.shared().register(self)
    }

    private func configureSubviews() {
        addSubview(collectionView)
        addSubview(stackView)

        collectionView.fill(container: self, padding: 10)

        stackView.placeInCenter(of: self)
        stackView.height(180)
        stackView.isHidden = true
    }

    private func applyStyles() {
        viewStyle(self)
        collectionViewStyle(collectionView)
        stackViewStyle(stackView)
        questionMarkImageView(questionMarkImageView)
        emptyTitleLabelStyle(emptyTitleLabel)
    }

    override func render(state: AlbumCollectionViewState) {
        super.render(state: state)
        self.fetchResult = state.fetchResult

        if state.loadingStatus == .empty {
            showEmptyState()
        }
    }

    func getCellImageView() -> UIImageView? {
        if let indexPath = selectedIndexPath {
            let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell
            return cell?.imageView
        }
        return nil
    }

    private func showEmptyState() {
        stackView.isHidden = false
    }

    private func updateAssets() {
        let visibleRectangle = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRectangle = visibleRectangle.insetBy(dx: 0, dy: -0.5 * visibleRectangle.height)

        let delta = abs(preheatRectangle.midY - previousPreheatRect.midY)
        guard delta > bounds.height / 3 else { return }

        let (addedRectangles, removedRectangles) = differencesBetweenRects(previousPreheatRect, preheatRectangle)
        let addedAssets = addedRectangles
            .flatMap { rect in
                collectionView.indexPathsForElements(in: rect)
            }
            .map { indexPath in
                fetchResult.object(at: indexPath.item)
            }
        let removedAssets = removedRectangles
            .flatMap { rect in
                collectionView.indexPathsForElements(in: rect)
            }
            .map { indexPath in
                fetchResult.object(at: indexPath.item)
            }
        PhotoLibraryManager.shared.startCachingImages(for: addedAssets)
        PhotoLibraryManager.shared.stopCachingImages(for: removedAssets)

        previousPreheatRect = preheatRectangle
    }

    private func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(
                    x: new.origin.x,
                    y: old.maxY,
                    width: new.width,
                    height: new.maxY - old.maxY
                )]
            }
            if old.minY > new.minY {
                added += [CGRect(
                    x: new.origin.x,
                    y: new.minY,
                    width: new.width,
                    height: old.minY - new.minY
                )]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(
                    x: new.origin.x,
                    y: new.maxY,
                    width: new.width,
                    height: old.maxY - new.maxY
                )]
            }
            if old.minY < new.minY {
                removed += [CGRect(
                    x: new.origin.x,
                    y: old.minY,
                    width: new.width,
                    height: new.minY - old.minY
                )]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}

extension AlbumCollectionView: UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }

        let asset = fetchResult.object(at: indexPath.item)

        PhotoLibraryManager.shared.getThumbnailImageForAsset(asset, with: asset.localIdentifier) { image in
            cell.configure(with: AlbumCollectionItemModel(
                image: image,
                isEdited: asset.isEdited(),
                isRaw: asset.isRAW()
            ))
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedIndexPath = indexPath
        delegate?.openDetailPage(with: fetchResult.object(at: indexPath.item))
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
            self.delegate?.removeAsset(self.fetchResult.object(at: indexPaths.first!.item))
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "Actions", children: [remove])
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateAssets()
    }
}

extension AlbumCollectionView: PHPhotoLibraryChangeObserver {

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else { return }

        DispatchQueue.main.sync {
            fetchResult = changes.fetchResultAfterChanges

            if changes.hasIncrementalChanges {
                collectionView.performBatchUpdates {
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map {
                            IndexPath(item: $0, section: 0)
                        })
                    }

                    changes.enumerateMoves { [weak self] fromidx, toidx in
                        self?.collectionView.moveItem(
                            at: IndexPath(item: fromidx, section: 0),
                            to: IndexPath(item: toidx, section: 0)
                        )
                    }
                }

                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadItems(at: changed.map {
                        IndexPath(item: $0, section: 0)
                    })
                }
            } else {
                collectionView.reloadData()
            }
        }
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

    private func stackViewStyle(_ view: UIStackView) {
        view.addArrangedSubview(questionMarkImageView)
        view.addArrangedSubview(emptyTitleLabel)

        view.distribution = .fillEqually
        view.alignment = .center
        view.axis = .vertical
    }

    private func questionMarkImageView(_ view: UIImageView) {
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(named: "contentAccentColor")!
        let config = UIImage.SymbolConfiguration(font: UIFont.bold(of: 62))
        view.image = UIImage(systemName: "questionmark", withConfiguration: config)
    }

    private func emptyTitleLabelStyle(_ view: UILabel) {
        view.text = "There is nothing in here yet"
        view.font = UIFont.medium(of: 22)
        view.numberOfLines = 0
        view.textColor = UIColor(named: "smoke45")
    }
}
