import Foundation
import UIKit

struct AlbumCollectionViewState: BaseViewState {
    var loadingStatus: LoadingStatus? = .idle
    var items: [AlbumCollectionItemModel] = [AlbumCollectionItemModel]()

    func mutate(
        loadingStatus: LoadingStatus? = nil,
        items: [AlbumCollectionItemModel]? = nil
    ) -> AlbumCollectionViewState {
        return AlbumCollectionViewState(
            loadingStatus: loadingStatus ?? self.loadingStatus,
            items: items ?? self.items
        )
    }
}
