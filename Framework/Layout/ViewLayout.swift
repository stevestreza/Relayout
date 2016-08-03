import Foundation
import UIKit

public class ViewLayout {
    public let rootView: UIView
    public let layouts: [LayingOut]

    public init(rootView: UIView, layouts: [LayingOut]) {
        self.rootView = rootView
        self.layouts = layouts
    }

    public convenience init(rootView: UIView, layout: LayingOut) {
        self.init(rootView: rootView, layouts: [layout])
    }

    private(set) var activeConstraints: [NSLayoutConstraint] = []

    public func layout() {
        NSLayoutConstraint.deactivateConstraints(activeConstraints)
        activeConstraints = layouts.flatMap { $0.constraints(in: self.rootView) }
        NSLayoutConstraint.activateConstraints(activeConstraints)

        rootView.setNeedsLayout()
        rootView.layoutIfNeeded()
    }
}

public extension LayingOut {
    public func viewLayout(withRootView rootView: UIView) -> ViewLayout {
        return ViewLayout(rootView: rootView, layout: self)
    }
}
