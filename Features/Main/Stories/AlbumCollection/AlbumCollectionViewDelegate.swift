import Foundation
import UIKit

protocol AlbumCollectionViewDelegate: AnyObject {
    func openDetailPage(for photo: UIImage, _ title: String)
    func removeAsset(with localIdentifier: String)
    func refreshAssets()
    func dismiss()
}
