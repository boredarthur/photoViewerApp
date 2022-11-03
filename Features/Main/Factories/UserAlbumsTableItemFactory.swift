import Foundation
import UIKit
import Combine
import Photos

class UserAlbumsTableItemFactory {

    // MARK: - Singleton

    public static let shared = UserAlbumsTableItemFactory()
    private init() {}

    // MARK: - Public

    func getItems(
        _ allPhotos: PHFetchResult<PHAsset>,
        _ userCollections: PHFetchResult<PHAssetCollection>
    ) -> AnyPublisher<[UserAlbumsTableItemModel], Never> {
        var items = [UserAlbumsTableItemModel]()
        var previewPhoto: UIImage?

        // Get first photo for preview
        PHCachingImageManager().requestImage(
            for: allPhotos.object(at: 0),
            targetSize: CGSize(width: 50, height: 50),
            contentMode: .aspectFill,
            options: nil) { image, _ in
                previewPhoto = image
            }

        items.append(UserAlbumsTableItemModel(
            allPhotos: allPhotos,
            previewPhoto: previewPhoto ?? UserAlbumsTableItemModel.noImage,
            photosCount: allPhotos.countOfAssets(with: .image)
        ))

        userCollections.enumerateObjects { assetCollection, _, _ in
            // Get first photo for preview

            var previewPhoto: UIImage?
            if let asset = assetCollection.firstAsset {
                PHCachingImageManager().requestImage(
                    for: asset,
                    targetSize: CGSize(width: 50, height: 50),
                    contentMode: .aspectFill,
                    options: nil) { image, _ in
                        previewPhoto = image
                    }
            }

            items.append(UserAlbumsTableItemModel(
                collection: assetCollection,
                previewPhoto: previewPhoto ?? UserAlbumsTableItemModel.noImage,
                photosCount: assetCollection.estimatedAssetCount
            ))
        }
        return Just(items).eraseToAnyPublisher()
    }
}
