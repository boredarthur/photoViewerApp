import Foundation
import UIKit

struct UserAlbumsTableItemModel {
    var title: String
    var image: UIImage
    var photosCount: Int

    static let noImage = UIImage(systemName: "folder")!.withRenderingMode(.alwaysTemplate)
}
