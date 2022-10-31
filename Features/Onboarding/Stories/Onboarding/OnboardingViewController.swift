import UIKit

class OnboardingViewController: BaseViewController<OnboardingView, OnboardingViewIntent,
                                OnboardingViewState, OnboardingViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.sendIntent(.initialize)
        getView().delegate = self
    }
}

extension OnboardingViewController: OnboardingViewDelegate {

    func requestPhotoAccess() {
        viewModel.sendIntent(.requestPhotoAccess)
    }

    func savePassedOnboarding() {
        viewModel.sendIntent(.savePassedOnboarding)
    }
}
