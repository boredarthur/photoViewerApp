import Foundation
import Photos

class DetailPhotoViewModel: BaseViewModel<DetailPhotoViewIntent, DetailPhotoViewState> {

    var asset: PHAsset!

    override func sendIntent(_ intent: DetailPhotoViewIntent) {
        switch intent {
        case .initialize(let asset):
            self.asset = asset
            initialize(asset)
        }
    }

    private func initialize(_ asset: PHAsset) {
       updateState(state: DetailPhotoViewState(
            image: PhotoLibraryManager.shared.getImage(for: asset)
       ))
    }
}
