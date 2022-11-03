import UIKit

class UserAlbumsPrompt: BasePrompt {

    public static let shared = UserAlbumsPrompt()
    private override init() {}

    func showPromptForCreatingNewCollection(completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Create new album",
            message: "Enter the name for new album",
            preferredStyle: .alert
        )
        alert.addTextField()

        let sumbitAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let title = alert.textFields?[0].text,
                  title.range(of: ".*[^A-Za-z0-9_ ].*", options: .regularExpression) == nil
            else {
                self.showPromptForFetchingErrorInvalidName("We support only letters, numbers and symbols. Sorry!")
                return
            }

            PhotoLibraryManager.shared.createNewCollection(with: title)
            completion?()
            alert.dismiss(animated: true)
        }

        alert.addAction(sumbitAction)
        presentPrompt(alert)
    }

    func showPromptForFetchingErrorInvalidName(_ message: String) {
        let alert = UIAlertController(
            title: "Oops",
            message: message,
            preferredStyle: .alert
        )

        let submitAction = UIAlertAction(title: "Let me try again", style: .default) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(submitAction)
        presentPrompt(alert)
    }
}
