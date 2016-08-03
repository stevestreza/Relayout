import Foundation
import UIKit

class ViewLayout {
    let rootView: UIView
    let layouts: [LayingOut]

    init(rootView: UIView, layouts: [LayingOut]) {
        self.rootView = rootView
        self.layouts = layouts
    }

    convenience init(rootView: UIView, layout: LayingOut) {
        self.init(rootView: rootView, layouts: [layout])
    }

    private(set) var activeConstraints: [NSLayoutConstraint] = []

    func layout() {
        NSLayoutConstraint.deactivateConstraints(activeConstraints)
        activeConstraints = layouts.flatMap { $0.constraints(in: self.rootView) }
        NSLayoutConstraint.activateConstraints(activeConstraints)

        rootView.setNeedsLayout()
        rootView.layoutIfNeeded()
    }
}

extension LayingOut {
    func viewLayout(withRootView rootView: UIView) -> ViewLayout {
        return ViewLayout(rootView: rootView, layout: self)
    }
}
