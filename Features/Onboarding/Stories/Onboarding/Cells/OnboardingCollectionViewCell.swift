import UIKit

class OnboardingCollectionViewCell: BaseCollectionViewCell {

    private let imageView = UIImageView()
    private let stackView = UIStackView()
    private let mainTitleLabel = UILabel()
    private let secondaryTitleLabel = UILabel()

    static let identifier = "OnboardingCollectionViewCell"

    var model: OnboardingCollectionViewCellModel!

    override func render() {
        super.render()
        configureSubviews()
    }

    private func applyStyles() {
        imageViewStyle(imageView)
        stackViewStyle(stackView)
        mainTitleLabelStyle(mainTitleLabel)
        secondaryTitleLabelStyle(secondaryTitleLabel)
    }

    private func configureSubviews() {
        addSubview(imageView)
        addSubview(stackView)
        stackView.addArrangedSubview(mainTitleLabel)
        stackView.addArrangedSubview(secondaryTitleLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 320).isActive = true

        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28).isActive = true
        stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
    }

    func configure(with model: OnboardingCollectionViewCellModel) {
        self.model = model
        applyStyles()
    }
}

extension OnboardingCollectionViewCell {

    private func imageViewStyle(_ view: UIImageView) {
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: model.imageName)
    }

    private func stackViewStyle(_ view: UIStackView) {
        view.distribution = .fillEqually
        view.contentMode = .scaleToFill
        view.alignment = .center
        view.axis = .vertical
    }

    private func mainTitleLabelStyle(_ view: UILabel) {
        view.font = UIFont.bold(of: 28)
        view.textAlignment = .center
        view.textColor = .white
        view.text = model.mainTitle
    }

    private func secondaryTitleLabelStyle(_ view: UILabel) {
        view.font = UIFont.regular(of: 16)
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 0
        view.text = model.seconadaryTitle
    }
}
