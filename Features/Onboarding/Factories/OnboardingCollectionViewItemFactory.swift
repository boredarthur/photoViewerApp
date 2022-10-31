import Foundation
import Combine

class OnboardingCollectionViewItemFactory {

    public static let shared = OnboardingCollectionViewItemFactory()
    private init() {}

    func getItems() -> AnyPublisher<[OnboardingCollectionViewCellModel], Never> {
        let items = [
            OnboardingCollectionViewCellModel(
                imageName: "question",
                mainTitle: "App ain't do much",
                seconadaryTitle: "But I hope you will enjoy it"
            ),
            OnboardingCollectionViewCellModel(
                imageName: "access",
                mainTitle: "To continue",
                seconadaryTitle: "Grant access to all of your images. We won't post it online, I promise."
            )
        ]

        return Just(items).eraseToAnyPublisher()
    }
}
