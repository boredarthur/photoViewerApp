import Foundation
import UIKit

class DetailPhotoViewModel: BaseViewModel<DetailPhotoViewIntent, DetailPhotoViewState> {

    override func sendIntent(_ intent: DetailPhotoViewIntent) {
        switch intent {
        case .initialize(let image):
            initialize(image)
        }
    }

    private func initialize(_ image: UIImage) {
        updateState(state: DetailPhotoViewState(
            image: image
        ))
    }
}
