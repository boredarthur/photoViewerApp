import Foundation
import Photos
import UIKit

protocol AlbumCollectionViewDelegate: AnyObject {
    func openDetailPage(with asset: PHAsset)
    func removeAsset(_ asset: PHAsset)
    func dismiss()
}
