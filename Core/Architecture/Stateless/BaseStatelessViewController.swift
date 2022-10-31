import Foundation
import UIKit

class BaseStatelessViewController<V: BaseStatelessView>: UIViewController {

    private var currentStatusBarStyle = UIStatusBarStyle.lightContent

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentStatusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getView().viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getView().viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getView().viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getView().viewWillDisappear(animated)
    }

    override func loadView() {
        self.view = V.init(frame: UIScreen.main.bounds)
    }

    func getView() -> V {
        return self.view as? V ?? V.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
