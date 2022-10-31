import Foundation
import Photos

struct UserAlbumsViewState: BaseViewState {
    var loadingStatus: LoadingStatus? = .idle
    var items: [UserAlbumsTableItemModel] = [UserAlbumsTableItemModel]()

    func mutate(
        loadingStatus: LoadingStatus? = nil,
        items: [UserAlbumsTableItemModel]? = nil
    ) -> UserAlbumsViewState {
        return UserAlbumsViewState(
            loadingStatus: loadingStatus ?? self.loadingStatus,
            items: items ?? self.items
        )
    }
}
