import UIKit

extension UIView {

    func withRoundedCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    func addShadow(
        _ color: UIColor = .black,
        _ radius: CGFloat = 3,
        _ opacity: Float = 0.8,
        _ offset: CGSize = CGSize(width: 0, height: -1)
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
}
