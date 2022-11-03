import Foundation
import Photos

protocol UserAlbumsViewDelegate: AnyObject {
    func reloadData()
    func openCollection(_ collection: PHAssetCollection?)
    func removeCollection(_ collection: PHAssetCollection)
}
