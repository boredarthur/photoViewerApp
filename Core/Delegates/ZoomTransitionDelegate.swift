import UIKit

enum TransitionState {
    case initial
    case final
}

@objc protocol ZoomingViewController {
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView?
    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView?
}

class ZoomTransitionDelegate: NSObject {

    var transitionDuration: CGFloat = 0.5
    var operation: UINavigationController.Operation = .none

    private let zoomScale = CGFloat(15)
    private let backgroundScale = CGFloat(0.7)

    typealias ZoomingViews = (otherView: UIView, imageView: UIView)

    func configureViews(
        for state: TransitionState,
        containerView: UIView,
        backgroundViewController: UIViewController,
        viewsInBackground: ZoomingViews,
        viewsInForeground: ZoomingViews,
        snapshotViews: ZoomingViews
    ) {
        switch state {
        case .initial:
            backgroundViewController.view.transform = .identity
            backgroundViewController.view.alpha = 1

            snapshotViews.imageView.frame = containerView.convert(
                viewsInBackground.imageView.frame,
                from: viewsInBackground.imageView.superview
            )
        case .final:
            backgroundViewController.view.transform = CGAffineTransform(
                scaleX: backgroundScale,
                y: backgroundScale
            )
            backgroundViewController.view.alpha = 0

            snapshotViews.imageView.frame = containerView.convert(
                viewsInForeground.imageView.frame,
                from: viewsInForeground.imageView.superview
            )
        }
    }
}

extension ZoomTransitionDelegate: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView

        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController

        if operation == .pop {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
        }

        let fakeBackgroundImageView = (backgroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)
        let fakeForegroundImageView = (foregroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)

        if let backgroundImageView = fakeBackgroundImageView,
           let foregoundImageView = fakeForegroundImageView {
            let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
            imageViewSnapshot.contentMode = .scaleAspectFit
            imageViewSnapshot.layer.masksToBounds = true

            backgroundImageView.isHidden = true
            foregoundImageView.isHidden = true

            let foregroundViewBackgroundColor = foregroundViewController.view.backgroundColor
            foregroundViewController.view.backgroundColor = .clear
            containerView.backgroundColor = .clear

            containerView.addSubview(backgroundViewController.view)
            containerView.addSubview(foregroundViewController.view)
            containerView.addSubview(imageViewSnapshot)

            var preTransitionState = TransitionState.initial
            var postTransitionState = TransitionState.final

            if operation == .pop {
                preTransitionState = .final
                postTransitionState = .initial
            }

            configureViews(
                for: preTransitionState,
                containerView: containerView,
                backgroundViewController: backgroundViewController,
                viewsInBackground: (backgroundImageView, backgroundImageView),
                viewsInForeground: (foregoundImageView, foregoundImageView),
                snapshotViews: (imageViewSnapshot, imageViewSnapshot)
            )

            foregroundViewController.view.layoutIfNeeded()

            UIView.animate(
                withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.0,
                options: [],
                animations: { [weak self] in
                    self?.configureViews(
                        for: postTransitionState,
                        containerView: containerView,
                        backgroundViewController: backgroundViewController,
                        viewsInBackground: (backgroundImageView, backgroundImageView),
                        viewsInForeground: (foregoundImageView, foregoundImageView),
                        snapshotViews: (imageViewSnapshot, imageViewSnapshot)
                    )
                }) { _ in 
                    backgroundViewController.view.transform = .identity
                    imageViewSnapshot.removeFromSuperview()
                    backgroundImageView.isHidden = false
                    foregoundImageView.isHidden = false
                    foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor

                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
        }
    }
}

extension ZoomTransitionDelegate: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is ZoomingViewController && toVC is ZoomingViewController {
            self.operation = operation
            return self
        }
        return nil
    }
}
