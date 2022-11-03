import Foundation
import Photos
import UIKit

enum AlbumCollectionViewIntent: BaseViewIntent {
    case initialize
    case openDetailedPage(asset: PHAsset)
    case removeAsset(asset: PHAsset)
}
