import Foundation

#if os(OSX)
import AppKit
#else
import UIKit
#endif

/// Return the NSLayoutConstraint objects from one LayingOut object if a given condition is true, or 
/// the NSLayoutConstraint objects from a second LayingOut object if false.
public struct ConditionalLayout: LayingOut {
    /// The condition to check against the supplied root view.
    public let condition: (UIView) -> Bool

    /// The LayingOut object to call if the condition is true.
    public let layout: LayingOut

    /// The LayingOut object to call if the condition is false.
    public let elseLayout: LayingOut?

    /**
     Creates a new ConditionalLayout with the given conditional closure and LayingOut objects for
     each condition.

     - parameter condition:  The closure to call to check the condition
     - parameter layout:     The LayingOut object to call if the condition is true
     - parameter elseLayout: The LayingOut object to call if the condition is false

     - returns: A new ConditionalLayout object with the given conditional closure and LayingOut
     objects.
     */
    public init(condition: @escaping (UIView) -> Bool, layout: LayingOut, elseLayout: LayingOut? = nil) {
        self.condition = condition
        self.layout = layout
        self.elseLayout = elseLayout
    }

    /**
     Returns NSLayoutConstraint objects from either the `layout` or the `elseLayout` based on the
     `condition`

     - parameter view: The root view to generate NSLayoutConstraint objects for.

     - returns: An Array<NSLayoutConstraint>, either from the `layout` or the `elseLayout` based on
     the `condition`
     */
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

public extension ConditionalLayout {
    /**
     Creates a new ConditionalLayout with the given conditional closure and layout closure for
     the true condition.

     - parameter condition: The closure to call to check the condition
     - parameter handler:   A closure to return NSLayoutConstraint objects from if the condition is
     true.

     - returns: A new ConditionalLayout object with the given conditional closure and layout closure.
     */
    public init(condition: @escaping (UIView) -> Bool, handler: @escaping (UIView) -> [NSLayoutConstraint]) {
        self.init(condition: condition, layout: Layout(handler: handler), elseLayout: nil)
    }

    /**
     Creates a new ConditionalLayout with the given conditional closure and layout closure for each
     condition.

     - parameter condition:   The closure to call to check the condition
     - parameter handler:     A closure to return NSLayoutConstraint objects from if the condition
     is true.
     - parameter elseHandler: A closure to return NSLayoutConstraint objects from if the condition
     is false.

     - returns: A new ConditionalLayout object with the given conditional closure and layout closure.
     */
    public init(condition: @escaping (UIView) -> Bool, handler: @escaping (UIView) -> [NSLayoutConstraint], elseHandler: @escaping ((UIView) -> [NSLayoutConstraint])) {
        self.init(condition: condition, layout: Layout(handler: handler), elseLayout: Layout(handler: elseHandler))
    }

    /**
     Creates a new ConditionalLayout with the given conditional closure and 
     Array<NSLayoutConstraint> for the true condition.

     - parameter condition:   The closure to call to check the condition
     - parameter constraints: The NSLayoutConstraint objects to use if the condition is true.

     - returns: A new ConditionalLayout object with the given conditional closure and 
     NSLayoutConstraint objects.
     */
    public init(condition: @escaping (UIView) -> Bool, constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(constraints)
        self.init(condition: condition, layout: Layout(constraints: constraints), elseLayout: nil)
    }


    /**
     Creates a new ConditionalLayout with the given conditional closure and
     Array<NSLayoutConstraint> for each condition.

     - parameter condition:       The closure to call to check the condition
     - parameter constraints:     The NSLayoutConstraint objects to use if the condition is true
     - parameter elseConstraints: The NSLayoutConstraint objects to use if the condition is false

     - returns: A new ConditionalLayout object with the given conditional closure and
     NSLayoutConstraint objects for each condition
     */
    public init(condition: @escaping (UIView) -> Bool, constraints: [NSLayoutConstraint], elseConstraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(constraints)
        NSLayoutConstraint.deactivate(elseConstraints)
        self.init(condition: condition, layout: Layout(constraints: constraints), elseLayout: Layout(constraints: elseConstraints) )
    }
}

public extension LayingOut {
    /**
     Creates a new ConditionalLayout with the given conditional closure and LayingOut objects for
     each condition.

     - parameter condition:  The closure to call to check the condition

     - returns: A new ConditionalLayout object with the given conditional closure and supplied 
     LayingOut object.
     */
    public func when(_ condition: @escaping (UIView) -> Bool) -> ConditionalLayout {
        return ConditionalLayout(condition: condition, layout: self)
    }
}
