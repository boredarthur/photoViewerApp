import UIKit

class DefaultButton: BaseButton {

    private let roundedView = UIView()
    private(set) var appearance = DefaultButtonStyle.default.appearance

    var style: DefaultButtonStyle = .default {
        didSet {
            appearance = style.appearance
            configureButtonStyle()
        }
    }

    override func render() {
        super.render()

        self.addSubview(roundedView)
        roundedView.fill(container: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()

        updateAppearance()
    }

    override func configureButtonStyle() {
        setTitleColor(appearance.titleColor, for: .normal)
        setTitleColor(appearance.titleColor, for: .highlighted)
        titleLabel?.textAlignment = .center
        titleLabel?.font = appearance.font

        roundedView.isUserInteractionEnabled = false
    }

    func updateAppearance() {
        roundedView.backgroundColor = UIColor(named: "contentAccentColor") ?? .clear
        roundedView.withRoundedCorners(radius: 10)
    }
}

// MARK: Animations

extension DefaultButton {

    func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = 0.7
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -5.0, 5.0, -2.0, 2.0, -2.0, 2.0, 0.0]
        layer.add(animation, forKey: "transform.translation.x")
    }
}
