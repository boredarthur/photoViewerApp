import Foundation
import UIKit

class BaseView<S: BaseViewState>: BaseStatelessView {

    func render(state: S) { }
}
