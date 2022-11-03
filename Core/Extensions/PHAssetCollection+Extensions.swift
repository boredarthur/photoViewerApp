import Photos

extension PHAssetCollection {

    var firstAsset: PHAsset? {
        let photoOptions = PHFetchOptions()
        photoOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photoOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        photoOptions.fetchLimit = 1

        return estimatedAssetCount > 0 ? PHAsset.fetchAssets(in: self, options: photoOptions).object(at: 0) : nil
    }
}
