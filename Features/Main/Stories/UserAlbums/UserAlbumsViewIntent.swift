import Foundation

enum UserAlbumsViewIntent: BaseViewIntent {
    case initialize
    case openCollection(title: String)
    case createCollection
    case removeCollection(title: String)
}
