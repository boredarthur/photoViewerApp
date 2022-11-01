import Foundation
import Photos
import Combine
import UIKit

class PhotoLibraryManager {

    public static let shared = PhotoLibraryManager()
    private init() {}

    private var allPhotosAssets: PHFetchResult<PHAsset> = {
        var fetchedAssets = PHFetchResult<PHAsset>()
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)

        return PHAsset.fetchAssets(with: options)
    }()

    func fetchAssetsCountForCollections() async -> [String: Int] {
        return await withCheckedContinuation { continuation in
            var result = [String: Int]()

            PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
                .enumerateObjects { [weak self] collection, _, _ in
                guard let self = self else { return }
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                requestOptions.deliveryMode = .highQualityFormat

                let photosInAlbum = self.fetchAssets(from: collection)
                if let title = collection.localizedTitle {
                    if photosInAlbum.count > 0 {
                        result[title] = photosInAlbum.count
                    }
                }
            }
            continuation.resume(returning: result)
        }
    }

    func fetchUserCollections() -> (PHFetchResult<PHAssetCollection>, [String: UIImage]) {
        let userCollectionsThumbnails = self.fetchUserCollectionsThumbnails()
        return (PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil),
                userCollectionsThumbnails)
    }

    func fetchAllPhotosAssetsWithThumbnail() async -> (PHFetchResult<PHAsset>, UIImage?) {
        let thumbnail = await fetchAllPhotosThumbnail()
        return (allPhotosAssets, thumbnail)
    }

    func createNewCollection(with title: String) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
        }
    }

    func removeCollection(with title: String, completion: ((Bool) -> Void)? = nil) throws {
        guard let asset = fetchCollection(with: title) else {
            throw FetchError.invalidName
        }
        PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.deleteAssetCollections([asset as Any] as NSArray)
            completion?(true)
        }
    }

    func removeAsset(with localIdentified: String, completion: ((Bool) -> Void)? = nil) throws {
        var fetchedAsset: PHAsset?
        allPhotosAssets.enumerateObjects { asset, _, _ in
            if asset.localIdentifier == localIdentified {
                fetchedAsset = asset
            }
        }
        guard fetchedAsset != nil else {
            throw FetchError.assetDeletion
        }

        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets([fetchedAsset as Any] as NSArray)
            completion?(true)
        }
    }

    func fetchCollection(with title: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "localizedTitle = %@", title)
        let assetCollection = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: fetchOptions
        )
        return assetCollection.firstObject
    }

    private func fetchAssets(from collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let photosOptions = PHFetchOptions()
        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photosOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        return PHAsset.fetchAssets(in: collection, options: photosOptions)
    }

    private func fetchAllPhotosThumbnail() async -> UIImage? {
        return await allPhotosAssets.getPhoto(allPhotosAssets.object(at: 0))
    }

    func fetchAllPhotosAssets(from assetTitle: String) -> [PHAsset] {
        var assets = [PHAsset]()
        var assetResult = PHFetchResult<PHAsset>()

        if assetTitle != "All Photos" {
            let assetCollection = fetchCollection(with: assetTitle)!
            assetResult = fetchAssets(from: assetCollection)
        } else {
            assetResult = allPhotosAssets
        }

        if assetResult.count > 0 {
            assetResult.enumerateObjects { asset, _, _ in
                assets.append(asset)
            }
        }

        return assets
    }

    private func fetchUserCollectionsThumbnails() -> [String: UIImage] {
        var thumbnailsResult = [String: UIImage]()

        PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            .enumerateObjects { [weak self] collection, _, _ in
            guard let assetsResult = self?.fetchAssets(from: collection) else { return }
            if assetsResult.count > 0 {
                let asset = assetsResult.object(at: 0)

                PHCachingImageManager.default().requestImage(
                    for: asset,
                    targetSize: CGSize(width: 1000, height: 1000),
                    contentMode: .aspectFill,
                    options: nil) { image, _ in
                        if let image = image, let title = collection.localizedTitle {
                            thumbnailsResult[title] = image
                        }
                    }
            }
        }
        return thumbnailsResult
    }
}
