import Foundation
import UIKit

class UserAlbumsTableViewCell: BaseTableViewCell {

    private let albumImageView = UIImageView()
    private let albumNameLabel = UILabel()
    private let photosCountLabel = UILabel()

    static let identifier = "UserAlbumsTableViewCell"

    var model: UserAlbumsTableItemModel!

    override func render() {
        super.render()
        configureSubviews()
    }

    private func applyStyles() {
        cellStyle(self.contentView)
        albumImageViewStyle(albumImageView)
        albumNameLabelStyle(albumNameLabel)
        photosCountLabelStyle(photosCountLabel)
    }

    private func configureSubviews() {
        addSubview(albumImageView)
        addSubview(albumNameLabel)
        addSubview(photosCountLabel)

        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        photosCountLabel.translatesAutoresizingMaskIntoConstraints = false

        albumImageView.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor,
            constant: 15
        ).isActive = true
        albumImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true

        albumNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10).isActive = true
        albumNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        albumNameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true

        photosCountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: albumNameLabel.trailingAnchor).isActive = true
        photosCountLabel.trailingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.trailingAnchor,
            constant: -25
        ).isActive = true
        photosCountLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        photosCountLabel.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -10
        ).isActive = true
    }

    func configure(with model: UserAlbumsTableItemModel) {
        self.model = model
        applyStyles()
    }
}

extension UserAlbumsTableViewCell {

    private func cellStyle(_ view: UIView) {
        backgroundColor = .clear
    }

    private func albumImageViewStyle(_ view: UIImageView) {
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 4.0
        view.layer.masksToBounds = true
        view.image = model.image
        view.tintColor = UIColor(named: "contentAccentColor")
    }

    private func albumNameLabelStyle(_ view: UILabel) {
        view.font = UIFont.regular(of: 18)
        view.text = model.title
        view.textColor = .white
    }

    private func photosCountLabelStyle(_ view: UILabel) {
        view.font = UIFont.regular(of: 18)
        view.text = String(describing: model.photosCount)
        view.textColor = .white.withAlphaComponent(0.3)
    }
}
