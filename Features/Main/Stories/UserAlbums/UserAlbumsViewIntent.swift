import Foundation
import Photos

enum UserAlbumsViewIntent: BaseViewIntent {
    case initialize
    case openCollection(collection: PHAssetCollection?)
    case createCollection
    case removeCollection(collection: PHAssetCollection)
}
