import UIKit

class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configureButtonStyle()

        addTarget(self, action: #selector(highlitedState), for: .touchDown)
        addTarget(self, action: #selector(normalState), for: .touchCancel)
        addTarget(self, action: #selector(normalState), for: .touchUpInside)
        addTarget(self, action: #selector(normalState), for: .touchUpOutside)
        addTarget(self, action: #selector(normalState), for: .touchDragExit)
    }

    func render() {
        calculateDimensions()
    }

    func calculateDimensions() { }

    func configureButtonStyle() { }

    @objc func highlitedState() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
            self.titleLabel?.alpha = 0.8
        }
    }

    @objc func normalState() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
            self.titleLabel?.alpha = 1.0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        render()
        configureButtonStyle()

        addTarget(self, action: #selector(highlitedState), for: .touchDown)
        addTarget(self, action: #selector(normalState), for: .touchCancel)
        addTarget(self, action: #selector(normalState), for: .touchUpInside)
        addTarget(self, action: #selector(normalState), for: .touchUpOutside)
        addTarget(self, action: #selector(normalState), for: .touchDragExit)
    }
}
