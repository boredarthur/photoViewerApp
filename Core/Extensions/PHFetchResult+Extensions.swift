import Photos
import UIKit

extension PHFetchResult {

    @objc func getPhoto(_ asset: PHAsset) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true

            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: 50, height: 50),
                contentMode: .aspectFill,
                options: requestOptions) { image, _ in
                    continuation.resume(returning: image)
                }
        }
    }
}
