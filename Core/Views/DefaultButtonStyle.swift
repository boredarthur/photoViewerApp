import UIKit

enum DefaultButtonStyle {
    case `default`
}

extension DefaultButtonStyle {

    var appearance: DefaultButtonAppearance {
        switch self {
        case .default:
            return DefaultButtonAppearance(
                titleColor: .white,
                font: UIFont.medium(of: 16)
            )
        }
    }
}
