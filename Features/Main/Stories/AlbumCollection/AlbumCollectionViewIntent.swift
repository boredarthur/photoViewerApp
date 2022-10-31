import Foundation
import UIKit

enum AlbumCollectionViewIntent: BaseViewIntent {
    case initialize
    case fetchAssets(collectionTitle: String)
    case openDetailedPage(photo: UIImage, title: String)
    case removeAsset(localIdentifier: String)
}
