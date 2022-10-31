import Foundation

enum FetchError: Error {
    case invalidName
    case assetDeletion
    case cancellation
    case unexpected

    var description: String {
        switch self {
        case .invalidName:
            return "While trying to delete album, an error occured, try once more"
        case .assetDeletion:
            return "Can not fetch photo. Try once more"
        case .cancellation:
            return "Operation was cancelled"
        case .unexpected:
            return "Unexpected error occured"
        }
    }
}
