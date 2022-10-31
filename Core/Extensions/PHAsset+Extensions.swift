import Photos

extension PHAsset {

    var title: String {
        return PHAssetResource.assetResources(for: self)[0].originalFilename
    }

    func isEdited() -> Bool {
        return PHAssetResource.assetResources(for: self).contains(where: { $0.type == .adjustmentData })
    }

    func isRAW() -> Bool {
        return PHAssetResource.assetResources(for: self)
            .contains(where: {
                $0.uniformTypeIdentifier == UTType.rawImage.identifier ||
                $0.uniformTypeIdentifier == "com.adobe.raw-image"
            })
    }
}
