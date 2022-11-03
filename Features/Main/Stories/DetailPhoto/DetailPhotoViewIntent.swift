import Foundation
import Photos

enum DetailPhotoViewIntent: BaseViewIntent {
    case initialize(asset: PHAsset)
}
