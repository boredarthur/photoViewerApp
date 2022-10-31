import UIKit

class DetailPhotoView: BaseView<DetailPhotoViewState> {

    var imageViewOriginalCenter: CGPoint!
    weak var delegate: DetailPhotoViewDelegate?
    var panGestureRecognizer: UIPanGestureRecognizer!
    var swipeDownGestureRecognizer: UISwipeGestureRecognizer!

    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubiews()
        applyStyles()
    }

    private func configureSubiews() {
        addSubview(imageView)
        imageView.fill(container: self)
    }

    private func applyStyles() {
        viewStyle(self)
        imageViewStyle(imageView)
    }

    override func render(state: DetailPhotoViewState) {
        super.render(state: state)
        imageView.image = state.image
    }
}

extension DetailPhotoView {

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: imageView)

        switch sender.state {
        case .began:
            imageViewOriginalCenter = imageView.center
        case .changed:
            imageView.center = CGPoint(
                x: imageViewOriginalCenter.x + translation.x,
                y: imageViewOriginalCenter.y + translation.y
            )
        default:
            break
        }
    }

    @objc private func didPinch(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        imageView.transform = CGAffineTransformScale(imageView.transform, scale, scale)
        sender.scale = 1
    }

    @objc private func didRotate(_ sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let previousTransform = imageView.transform
        imageView.transform = CGAffineTransformRotate(previousTransform, rotation)
        sender.rotation = 0
    }

    @objc private func swipeDownAction() {
        delegate?.dismiss()
    }
}

extension DetailPhotoView: UIGestureRecognizerDelegate {

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if gestureRecognizer == panGestureRecognizer &&
            otherGestureRecognizer == swipeDownGestureRecognizer {
            return true
        }
        return false
    }
}

// MARK: Styles

extension DetailPhotoView {

    private func viewStyle(_ view: UIView) {
        view.backgroundColor = .black
    }

    private func imageViewStyle(_ view: UIImageView) {
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        view.addGestureRecognizer(pinchGestureRecognizer)

        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        view.addGestureRecognizer(rotationGestureRecognizer)

        swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
        swipeDownGestureRecognizer.direction = .down
        swipeDownGestureRecognizer.delegate = self
        view.addGestureRecognizer(swipeDownGestureRecognizer)
    }
}
