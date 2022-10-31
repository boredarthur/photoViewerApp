import Foundation

protocol UserAlbumsViewDelegate: AnyObject {
    func openCollection(with title: String)
    func refreshCollections()
    func removeCollection(with title: String)
}
