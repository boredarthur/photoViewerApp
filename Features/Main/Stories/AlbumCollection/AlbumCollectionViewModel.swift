import Foundation
import Combine

class AlbumCollectionViewModel: BaseViewModel<AlbumCollectionViewIntent, AlbumCollectionViewState> {

    private var cancellables = Set<AnyCancellable>()
    private var items = [AlbumCollectionItemModel]()

    private var currentIndex = 0

    override func sendIntent(_ intent: AlbumCollectionViewIntent) {
        switch intent {
        case .initialize:
            initialize()
        case .fetchAssets(let collectionTitle):
            Task(priority: .background) {
                fetchAssets(with: collectionTitle)
            }
        case .openDetailedPage(let photo, let title):
            MainRouter.shared.openDetailedPhoto(with: photo, title)
        case .removeAsset(let localIdentifier):
            removeAsset(with: localIdentifier)
        }
    }

    private func initialize() {
        updateState(state: AlbumCollectionViewState(
            loadingStatus: .loading
        ))
    }

    private func fetchAssets(with collectionTitle: String) {
        AlbumCollectionItemFactory.shared.getItems(from: collectionTitle, currentIndex) { newIndex in
            self.currentIndex = newIndex + 1 // Fetching next 17 photos
        }.sink { [weak self] items in
            guard let self = self else { return }
            guard let items = items else {
                if self.items.count == 0 {
                    self.updateState(state: self.state?.mutate(
                        loadingStatus: .empty
                    ))
                }
                return
            }
            items.forEach { self.items.append($0) }
            self.updateState(state: self.state?.mutate(
                loadingStatus: .idle,
                items: self.items
            ))
        }.store(in: &cancellables)
    }

    private func removeAsset(with localIdentifier: String) {
        do {
            try PhotoLibraryManager.shared.removeAsset(with: localIdentifier)
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
