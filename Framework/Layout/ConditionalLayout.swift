import Foundation
import UIKit

/// Returns constraints if the conditional closure returns true, or none if false.
public struct ConditionalLayout: LayingOut {
    public let condition: () -> Bool
    public let layout: LayingOut
    public let elseLayout: LayingOut?
    
    public init(condition: () -> Bool, layout: LayingOut, elseLayout: LayingOut? = nil) {
        self.condition = condition
        self.layout = layout
        self.elseLayout = elseLayout
    }

    public init(condition: () -> Bool, handler: (UIView) -> [NSLayoutConstraint], elseHandler: ((UIView) -> [NSLayoutConstraint])? = nil) {
        self.init(condition: condition, layout: Layout(handler: handler), elseLayout: elseHandler.flatMap { Layout(handler: $0) })
    }

    public init(condition: () -> Bool, handler: (UIView) -> [NSLayoutConstraint]) {
        self.init(condition: condition, layout: Layout(handler: handler))
    }

    public init(condition: () -> Bool, constraints: [NSLayoutConstraint], elseConstraints: [NSLayoutConstraint]? = nil) {
        NSLayoutConstraint.deactivateConstraints(constraints)
        if let elseConstraints = elseConstraints {
            NSLayoutConstraint.deactivateConstraints(elseConstraints)
        }
        self.init(condition: condition, layout: Layout(constraints: constraints), elseLayout: elseConstraints.flatMap { Layout(constraints: $0) })
    }

    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        if condition() {
            return layout.constraints(in: view)
        }
        else if let layout = elseLayout {
            return layout.constraints(in: view)
        }
        else {
            return []
        }
    }
}

public extension LayingOut {
    public func when(condition: () -> Bool) -> ConditionalLayout {
        return ConditionalLayout(condition: condition, layout: self)
    }
}
