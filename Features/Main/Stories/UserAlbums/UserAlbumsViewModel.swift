import Foundation
import Combine
import UIKit

class UserAlbumsViewModel: BaseViewModel<UserAlbumsViewIntent, UserAlbumsViewState> {

    private var cancellables = Set<AnyCancellable>()

    override func sendIntent(_ intent: UserAlbumsViewIntent) {
        switch intent {
        case .initialize:
            Task { await initialize() }
        case .openCollection(let title):
            openCollection(with: title)
        case .createCollection:
            createCollection()
        case .removeCollection(let title):
            removeCollection(with: title)
        }
    }

    private func initialize() async {
        updateState(state: UserAlbumsViewState(
            loadingStatus: .loading
        ))

        let (allPhotosAssets, allPhotosThumbnail) = await PhotoLibraryManager.shared.fetchAllPhotosAssetsWithThumbnail()
        let (userCollections, userCollectionsThumbnails) = PhotoLibraryManager.shared.fetchUserCollections()
        let photosCountForCollections = await PhotoLibraryManager.shared.fetchAssetsCountForCollections()

        UserAlbumsTableItemFactory.shared.getItems(
            allPhotosAssets,
            allPhotosThumbnail,
            userCollections,
            userCollectionsThumbnails,
            photosCountForCollections
        ).sink { [weak self] items in
            guard let self = self else { return }
            self.updateState(state: self.state?.mutate(
                loadingStatus: .idle,
                items: items
            ))
        }.store(in: &cancellables)
    }

    private func openCollection(with title: String) {
        MainRouter.shared.openCollection(with: title)
    }

    private func createCollection() {
        updateState(state: self.state?.mutate(loadingStatus: .loading))
        UserAlbumsPrompt.shared.showPromptForCreatingNewCollection { [weak self] in
            self?.updateState(state: self?.state?.mutate(loadingStatus: .idle))
        }
    }

    private func removeCollection(with title: String) {
        do {
            try PhotoLibraryManager.shared.removeCollection(with: title)
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
