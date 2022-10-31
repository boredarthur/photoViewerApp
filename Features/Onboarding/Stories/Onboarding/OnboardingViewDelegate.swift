import Foundation

protocol OnboardingViewDelegate: AnyObject {
    func requestPhotoAccess()
    func savePassedOnboarding()
}
