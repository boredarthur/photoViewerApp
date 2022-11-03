import Foundation
import Photos
import UIKit

struct UserAlbumsTableItemModel {
    var collection: PHAssetCollection?
    var allPhotos: PHFetchResult<PHAsset>?
    var previewPhoto: UIImage
    var photosCount: Int

    static let noImage = UIImage(systemName: "folder")!.withRenderingMode(.alwaysTemplate)
}
