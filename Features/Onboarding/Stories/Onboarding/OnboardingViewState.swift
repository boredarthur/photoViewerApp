import Foundation

struct OnboardingViewState: BaseViewState {
    var items: [OnboardingCollectionViewCellModel] = []
    var permissionGranted: Bool = false

    func mutate(
        items: [OnboardingCollectionViewCellModel]? = nil,
        permissionGranted: Bool = false
    ) -> OnboardingViewState {
        return OnboardingViewState(
            items: items ?? self.items,
            permissionGranted: permissionGranted
        )
    }
}
