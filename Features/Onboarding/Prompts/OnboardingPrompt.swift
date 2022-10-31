import Foundation
import UIKit

class OnboardingPrompt: BasePrompt {

    static let shared = OnboardingPrompt()
    private override init() {}

    func showPromptNavigateToSettings() {
        let alert = UIAlertController(
            title: "Ew",
            message: "You didn't give us permission to look at your photos. You can rethink that decision in settings.",
            preferredStyle: .alert
        )

        let settingsAction = UIAlertAction(
            title: "Bring me there", style: .default
        ) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }

        let cancel = UIAlertAction(title: "Get out", style: .destructive)
        alert.addAction(settingsAction)
        alert.addAction(cancel)

        presentPrompt(alert)
    }
}
