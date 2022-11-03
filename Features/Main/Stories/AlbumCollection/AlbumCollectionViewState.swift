import Foundation
import Photos

struct AlbumCollectionViewState: BaseViewState {
    var loadingStatus: LoadingStatus = .idle
    var fetchResult: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
}
