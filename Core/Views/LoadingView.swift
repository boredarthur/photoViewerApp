import Foundation
import UIKit

class LoadingView: UIView {

    private var cameraImageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureView() {
        let cameraImageView = UIImageView()
        cameraImageView.image = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.tintColor = UIColor(named: "contentAccentColor")!
        addSubview(cameraImageView)
        cameraImageView.placeInCenter(of: self)
        cameraImageView.size(100)

        self.cameraImageView = cameraImageView
    }

    func animate() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Float.pi * 2.0
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        cameraImageView!.layer.add(rotationAnimation, forKey: "cameraRotation")

        let scalingAnimation = CABasicAnimation(keyPath: "transform.scale")

        scalingAnimation.fromValue = 0.7
        scalingAnimation.toValue = 1.2
        scalingAnimation.duration = 1.0
        scalingAnimation.repeatCount = Float.infinity
        scalingAnimation.autoreverses = true
        scalingAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        cameraImageView!.layer.add(scalingAnimation, forKey: "cameraScaling")
    }

    func stopAnimating() {
        cameraImageView!.layer.removeAllAnimations()
    }
}
