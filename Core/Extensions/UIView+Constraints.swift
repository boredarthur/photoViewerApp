import UIKit

extension UIView {

    func fill(container: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func fillIgnoreSafeArea(container: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }

    func fill(container: UIView, padding: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(
            equalTo: container.safeAreaLayoutGuide.leadingAnchor,
            constant: padding
        ).isActive = true
        trailingAnchor.constraint(
            equalTo: container.safeAreaLayoutGuide.trailingAnchor,
            constant: -padding
        ).isActive = true
        topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: padding).isActive = true
        bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -padding).isActive = true
    }

    func fill(container: UIView, verticalPadding: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topAnchor.constraint(
            equalTo: container.safeAreaLayoutGuide.topAnchor,
            constant: verticalPadding
        ).isActive = true
        bottomAnchor.constraint(
            equalTo: container.safeAreaLayoutGuide.bottomAnchor,
            constant: -verticalPadding
        ).isActive = true
    }
}
