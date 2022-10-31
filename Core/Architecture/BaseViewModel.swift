import Foundation
import Combine

open class BaseViewModel<A: BaseViewIntent, S: BaseViewState> {

    let stateSubject: PassthroughSubject<S, Error> = PassthroughSubject<S, Error>()
    var state: S?

    public required init() { }

    open func sendIntent(_ intent: A) { }

    func updateState(state: S? = nil) {
        if let state = state {
            self.state = state
        }
        if let state = self.state {
            stateSubject.send(state)
        }
    }
}
