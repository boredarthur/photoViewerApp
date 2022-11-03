import Foundation
import Photos
import Combine
import UIKit

class PhotoLibraryManager: NSObject {

    // MARK: - Singleton

    public static let shared = PhotoLibraryManager()

    private override init() {
        super.init()
    }

    // MARK: - Properties

    private var allPhotosAssets: PHFetchResult<PHAsset> = {
        var fetchedAssets = PHFetchResult<PHAsset>()
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)

        return PHAsset.fetchAssets(with: options)
    }()

    private var userCollections: PHFetchResult<PHAssetCollection> = {
        return PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    }()

    private var imageManager = PHCachingImageManager()

    // MARK: - Public

    func getAllPhotosAssets() -> PHFetchResult<PHAsset> { allPhotosAssets }

    func getUserCollections() -> PHFetchResult<PHAssetCollection> { userCollections }

    func updateUserCollections() {
        userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    }

    func getAssetsFetchResult(from collection: PHAssetCollection?) -> PHFetchResult<PHAsset> {
        if let collection = collection {
            return PHAsset.fetchAssets(in: collection, options: nil)
        } else {
            return allPhotosAssets
        }
    }

    func getThumbnailImageForAsset(
        _ asset: PHAsset,
        with representedAssetIdentifier: String,
        onCompletion: @escaping ((UIImage) -> Void)
    ) {
        var thumbnailImage: UIImage!

        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .fast
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = false

        imageManager.requestImage(
            for: asset,
            targetSize: CGSize(width: 200, height: 200),
            contentMode: .aspectFit,
            options: requestOptions) { image, _ in
                if representedAssetIdentifier == asset.localIdentifier {
                    thumbnailImage = image
                }
                onCompletion(thumbnailImage)
            }
    }

    func startCachingImages(for assets: [PHAsset]) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .fast
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isSynchronous = true

        imageManager.startCachingImages(
            for: assets,
            targetSize: CGSize(width: 200, height: 200),
            contentMode: .aspectFit,
            options: requestOptions)
    }

    func stopCachingImages(for assets: [PHAsset]) {
        imageManager.stopCachingImages(
            for: assets,
            targetSize: CGSize(width: 200, height: 200),
            contentMode: .aspectFit,
            options: nil)
    }

    func getImage(for asset: PHAsset) -> UIImage {
        var detailImage: UIImage!
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .fast
        requestOptions.isSynchronous = true

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 1000, height: 1000),
            contentMode: .aspectFit,
            options: requestOptions) { image, _ in
                detailImage = image
            }
        return detailImage
    }

    func createNewCollection(with title: String) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
        }
    }

    func removeCollection(_ collection: PHAssetCollection, completion: ((Bool) -> Void)? = nil) throws {
        PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.deleteAssetCollections([collection as Any] as NSArray)
            completion?(true)
        }
    }

    func removeAsset(_ asset: PHAsset, completion: ((Bool) -> Void)? = nil) throws {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets([asset as Any] as NSArray)
            completion?(true)
        }
    }

    // MARK: - Private

    private func fetchAssets(from collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let photosOptions = PHFetchOptions()
        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photosOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        return PHAsset.fetchAssets(in: collection, options: photosOptions)
    }
}
