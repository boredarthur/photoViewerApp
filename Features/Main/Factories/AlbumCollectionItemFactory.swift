import Foundation
import UIKit
import Photos
import Combine

class AlbumCollectionItemFactory {

    public static let shared = AlbumCollectionItemFactory()
    private init() {}

    func getItems(
        from title: String,
        _ index: Int? = nil,
        _ endIndex: Int? = nil,
        completion: ((Int) -> Void)
    ) -> AnyPublisher<[AlbumCollectionItemModel]?, Never> {
        let allPhotosAssets = PhotoLibraryManager.shared.fetchAllPhotosAssets(from: title)

        if let index = index, index < allPhotosAssets.count - 1 {
            let endIndex = !(index + 17 >= allPhotosAssets.count - 1) ? index + 17 : (allPhotosAssets.count - 1)
            let items = fetchInRange(allPhotosAssets, index, endIndex)
            completion(endIndex)
            return Just(items).eraseToAnyPublisher()
        }

        return Just(nil).eraseToAnyPublisher()
    }

    private func fetchInRange(
        _ allPhotosAssets: [PHAsset],
        _ startIndex: Int,
        _ endIndex: Int
    ) -> [AlbumCollectionItemModel] {
        let items = allPhotosAssets[startIndex...endIndex].compactMap {

            let isEdited = $0.isEdited()
            let isRaw = $0.isRAW()
            let title = $0.title
            let localIdentifier = $0.localIdentifier
            var model: AlbumCollectionItemModel?

            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .exact
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.resizeMode = .fast
            requestOptions.isSynchronous = true

            PHCachingImageManager.default().requestImage(
                for: $0,
                targetSize: CGSize(width: 500, height: 500),
                contentMode: .aspectFit,
                options: requestOptions) { image, _ in
                    if let image = image {
                        model = AlbumCollectionItemModel(
                            image: image,
                            title: title,
                            localIdentifier: localIdentifier,
                            isEdited: isEdited,
                            isRaw: isRaw
                        )
                    }
                }

            return model
        }
        return items
    }

    private func fetchAll(_ allPhotosAssets: [PHAsset]) -> [AlbumCollectionItemModel] {
        let items = allPhotosAssets.compactMap {

            let isEdited = $0.isEdited()
            let isRaw = $0.isRAW()
            let title = $0.title
            let localIdentifier = $0.localIdentifier
            var model: AlbumCollectionItemModel?

            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .exact
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.resizeMode = .fast
            requestOptions.isSynchronous = true

            PHCachingImageManager.default().requestImage(
                for: $0,
                targetSize: CGSize(width: 500, height: 500),
                contentMode: .aspectFit,
                options: requestOptions) { image, _ in
                    if let image = image {
                        model = AlbumCollectionItemModel(
                            image: image,
                            title: title,
                            localIdentifier: localIdentifier,
                            isEdited: isEdited,
                            isRaw: isRaw
                        )
                    }
                }

            return model
        }
        return items
    }
}
