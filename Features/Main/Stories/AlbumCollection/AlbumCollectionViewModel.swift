import Foundation
import Photos
import Combine

class AlbumCollectionViewModel: BaseViewModel<AlbumCollectionViewIntent, AlbumCollectionViewState> {

    var collection: PHAssetCollection?
    private var cancellables = Set<AnyCancellable>()

    override func sendIntent(_ intent: AlbumCollectionViewIntent) {
        switch intent {
        case .initialize:
            initialize()
        case .openDetailedPage(let asset):
            MainRouter.shared.openDetailedPhoto(with: asset)
        case .removeAsset(let asset):
            removeAsset(asset)
        }
    }

    private func initialize() {
        let assetsFetchResult = PhotoLibraryManager.shared.getAssetsFetchResult(from: collection)
        if assetsFetchResult.count == 0 {
            updateState(state: AlbumCollectionViewState(
                loadingStatus: .empty
            ))
        } else {
            updateState(state: AlbumCollectionViewState(
                fetchResult: PhotoLibraryManager.shared.getAssetsFetchResult(from: collection)
            ))
        }
    }

    private func removeAsset(_ asset: PHAsset) {
        do {
            try PhotoLibraryManager.shared.removeAsset(asset)
        } catch {
            if let error = error as? FetchError {
                switch error {
                case .assetDeletion:
                    UserAlbumsPrompt.shared.showPromptForFetchingErrorInvalidName(error.description)
                default:
                    break
                }
            }
        }
    }
}
