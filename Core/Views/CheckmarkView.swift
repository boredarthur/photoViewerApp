import Foundation
import UIKit

class CheckmarkView: UIView {

    private var circleLayer: CAShapeLayer?
    private var checkmarkLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)

        let circleLayer = CAShapeLayer()
        let radius: CGFloat = 80.0
        circleLayer.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: 150, height: 150),
            cornerRadius: radius
        ).cgPath
        circleLayer.position = CGPoint(x: frame.midX - 75, y: frame.midY - 75)
        circleLayer.fillColor = UIColor.white.cgColor
        circleLayer.opacity = 0
        layer.addSublayer(circleLayer)
        self.circleLayer = circleLayer

        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.midX - 30, y: frame.midY + 10))
        path.addLine(to: CGPoint(x: frame.midX - 5, y: frame.midY + 40))
        path.addLine(to: CGPoint(x: frame.midX + 40, y: frame.midY - 30))

        let checkmark = CAShapeLayer()
        checkmark.fillColor = UIColor.clear.cgColor
        checkmark.strokeColor = UIColor(named: "contentAccentColor")?.cgColor
        checkmark.lineWidth = 8
        checkmark.lineJoin = .round
        checkmark.lineCap = .round
        checkmark.path = path.cgPath
        layer.addSublayer(checkmark)
        self.checkmarkLayer = checkmark
    }

    func animate(with duration: TimeInterval, onCompletion completion: ((Bool) -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?(true)
        }
        let circleAnimation = CABasicAnimation(keyPath: "opacity")
        circleAnimation.fromValue = 0
        circleAnimation.toValue = 1
        circleAnimation.duration = duration - 0.2
        circleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        circleLayer!.opacity = 1
        circleLayer!.add(circleAnimation, forKey: "circleAnimation")

        let checkmarkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkmarkAnimation.fromValue = 0
        checkmarkAnimation.duration = duration
        checkmarkAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        checkmarkLayer!.add(checkmarkAnimation, forKey: "checkmarkAnimation")

        CATransaction.commit()
    }
}
