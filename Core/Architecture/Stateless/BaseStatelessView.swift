import Foundation
import UIKit

class BaseStatelessView: UIView {

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func viewDidLoad() {
        calculateDimensions()
    }

    func viewDidAppear(_ animated: Bool) { }

    func viewWillAppear(_ animated: Bool) { }

    func viewWillDisappear(_ animated: Bool) { }

    func calculateDimensions() { }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
