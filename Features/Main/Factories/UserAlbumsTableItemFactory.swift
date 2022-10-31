import Foundation
import UIKit
import Combine
import Photos

class UserAlbumsTableItemFactory {

    public static let shared = UserAlbumsTableItemFactory()
    private init() {}

    func getItems(
        _ allPhotos: PHFetchResult<PHAsset>,
        _ allPhotosThumbnail: UIImage?,
        _ userCollections: PHFetchResult<PHAssetCollection>,
        _ userCollectionsThumbnails: [String: UIImage],
        _ photosCount: [String: Int]
    ) -> AnyPublisher<[UserAlbumsTableItemModel], Never> {
        var items = [UserAlbumsTableItemModel]()
        items.append(UserAlbumsTableItemModel(
            title: "All Photos",
            image: allPhotosThumbnail ?? UserAlbumsTableItemModel.noImage,
            photosCount: allPhotos.count
        ))

        userCollections.enumerateObjects { assetCollection, _, _ in
            if let title = assetCollection.localizedTitle {
                items.append(UserAlbumsTableItemModel(
                    title: title,
                    image: userCollectionsThumbnails[title] ?? UserAlbumsTableItemModel.noImage,
                    photosCount: photosCount[title] ?? 0
                ))
            }
        }
        return Just(items).eraseToAnyPublisher()
    }
}
