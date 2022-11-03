import Foundation
import UIKit

class AlbumCollectionViewCell: BaseCollectionViewCell {

    static let identifier = "AlbumCollectionViewCell"
    var model: AlbumCollectionItemModel!
    var representedAssetIdentifier: String!

    let imageView = UIImageView()
    private let modifiedLabel = UILabel()
    private let rawLabel = UILabel()

    func configure(with model: AlbumCollectionItemModel) {
        self.model = model
        applyStyles()
        configureSubviews()
    }

    private func configureSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(modifiedLabel)
        contentView.addSubview(rawLabel)

        rawLabel.translatesAutoresizingMaskIntoConstraints = false
        modifiedLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.fill(container: contentView)

        rawLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        rawLabel.leadingAnchor.constraint(
            greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.leadingAnchor
        ).isActive = true
        rawLabel.bottomAnchor.constraint(
            equalTo: imageView.bottomAnchor,
            constant: -15
        ).isActive = true
        rawLabel.trailingAnchor.constraint(
            equalTo: imageView.trailingAnchor,
            constant: -15
        ).isActive = true

        modifiedLabel.topAnchor.constraint(
            equalTo: contentView.safeAreaLayoutGuide.topAnchor,
            constant: 15
        ).isActive = true
        modifiedLabel.leadingAnchor.constraint(
            greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.leadingAnchor
        ).isActive = true
        modifiedLabel.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor
        ).isActive = true
        modifiedLabel.trailingAnchor.constraint(
            equalTo: imageView.trailingAnchor,
            constant: -15
        ).isActive = true
    }

    private func applyStyles() {
        contentViewStyle(contentView)
        imageViewStyle(imageView)
        modifiedLabelStyle(modifiedLabel)
        rawLabelStyle(rawLabel)
    }
}

extension AlbumCollectionViewCell {

    private func contentViewStyle(_ view: UIView) {
        view.backgroundColor = .clear
    }

    private func imageViewStyle(_ view: UIImageView) {
        view.contentMode = .scaleAspectFit
        view.image = model.image
    }

    private func rawLabelStyle(_ view: UILabel) {
        view.isHidden = model.isRaw ? false : true
        view.text = "RAW"
        view.font = UIFont.regular(of: 12)
        view.textColor = .white
        view.addShadow()
    }

    private func modifiedLabelStyle(_ view: UILabel) {
        view.isHidden = model.isEdited ? false : true
        view.text = "Modified"
        view.font = UIFont.regular(of: 12)
        view.textColor = .white
        view.addShadow()
    }
}
