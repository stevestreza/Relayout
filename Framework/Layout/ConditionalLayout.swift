import Foundation
import UIKit

/// Returns constraints if the conditional closure returns true, or none if false.
public struct ConditionalLayout: LayingOut {
    public let condition: (UIView) -> Bool
    public let layout: LayingOut
    public let elseLayout: LayingOut?
    
    public init(condition: (UIView) -> Bool, layout: LayingOut, elseLayout: LayingOut? = nil) {
        self.condition = condition
        self.layout = layout
        self.elseLayout = elseLayout
    }

    public init(condition: (UIView) -> Bool, handler: (UIView) -> [NSLayoutConstraint]) {
        self.init(condition: condition, layout: Layout(handler: handler), elseLayout: nil)
    }

    public init(condition: (UIView) -> Bool, handler: (UIView) -> [NSLayoutConstraint], elseHandler: ((UIView) -> [NSLayoutConstraint])) {
        self.init(condition: condition, layout: Layout(handler: handler), elseLayout: Layout(handler: elseHandler))
    }

    public init(condition: (UIView) -> Bool, constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivateConstraints(constraints)
        self.init(condition: condition, layout: Layout(constraints: constraints), elseLayout: nil)
    }

    public init(condition: (UIView) -> Bool, constraints: [NSLayoutConstraint], elseConstraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivateConstraints(constraints)
        NSLayoutConstraint.deactivateConstraints(elseConstraints)
        self.init(condition: condition, layout: Layout(constraints: constraints), elseLayout: Layout(constraints: elseConstraints) )
    }

    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        if condition(view) {
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
    public func when(condition: (UIView) -> Bool) -> ConditionalLayout {
        return ConditionalLayout(condition: condition, layout: self)
    }
}
