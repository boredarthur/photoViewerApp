import Foundation
import Combine
import Photos

class OnboardingViewModel: BaseViewModel<OnboardingViewIntent, OnboardingViewState> {

    private var cancellables = Set<AnyCancellable>()

    private var isAuthorized = false

    override func sendIntent(_ intent: OnboardingViewIntent) {
        switch intent {
        case .initialize:
            initialize()
        case .requestPhotoAccess:
            requestPhotoAccess { [weak self] granted in
                self?.updateState(state: self?.state?.mutate(
                    permissionGranted: granted
                ))
                if !granted {
                    self?.navigateToSettings()
                }
            }
        case .savePassedOnboarding:
            savePassedOnboarding()
        }
    }

    private func initialize() {
        OnboardingCollectionViewItemFactory.shared.getItems().sink { [weak self] items in
            self?.updateState(state: OnboardingViewState(
                items: items
            ))
        }.store(in: &cancellables)
    }

    private func navigateToSettings() {
        DispatchQueue.main.async {
            OnboardingPrompt.shared.showPromptNavigateToSettings()
        }
    }

    private func requestPhotoAccess(onCompletion completion: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized else {
            completion(true)
            return
        }

        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            self?.isAuthorized = status == .authorized
            completion(status == .authorized)
        }
    }

    private func savePassedOnboarding() {
        UserDefaults.standard.set(true, forKey: "kPassedOnboarding")
        UserDefaults.standard.set(self.isAuthorized, forKey: "kGivenAuthorization")
    }
}
