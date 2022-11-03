import Foundation
import Combine
import Photos
import UIKit

class UserAlbumsViewModel: BaseViewModel<UserAlbumsViewIntent, UserAlbumsViewState> {

    private var cancellables = Set<AnyCancellable>()

    override func sendIntent(_ intent: UserAlbumsViewIntent) {
        switch intent {
        case .initialize:
            initialize()
        case .openCollection(let collection):
            openCollection(collection)
        case .createCollection:
            createCollection()
        case .removeCollection(let collection):
            removeCollection(collection)
        }
    }

    private func initialize() {
        updateState(state: UserAlbumsViewState(
            loadingStatus: .loading
        ))

        PhotoLibraryManager.shared.updateUserCollections()
        let allPhotosAssets = PhotoLibraryManager.shared.getAllPhotosAssets()
        let userCollections = PhotoLibraryManager.shared.getUserCollections()

        UserAlbumsTableItemFactory.shared.getItems(
            allPhotosAssets,
            userCollections
        ).sink { [weak self] items in
            guard let self = self else { return }
            self.updateState(state: self.state?.mutate(
                loadingStatus: .idle,
                items: items
            ))
        }.store(in: &cancellables)
    }

    private func openCollection(_ collection: PHAssetCollection?) {
        MainRouter.shared.openCollection(collection)
    }

    private func createCollection() {
        UserAlbumsPrompt.shared.showPromptForCreatingNewCollection()
    }

    private func removeCollection(_ collection: PHAssetCollection) {
        do {
            try PhotoLibraryManager.shared.removeCollection(collection)
        } catch {
            if let error = error as? FetchError {
                switch error {
                case .invalidName:
                    UserAlbumsPrompt.shared.showPromptForFetchingErrorInvalidName(error.description)
                default:
                    break
                }
            }
        }
    }
}
