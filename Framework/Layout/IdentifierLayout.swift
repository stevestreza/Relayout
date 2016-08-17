import Foundation
import UIKit

/**
 *    Adds a given String identifier to the NSLayoutConstraint objects returned by a given LayingOut
 *    object.
 */
public struct IdentifierLayout: LayingOut {
    /// The String identifier to add to the NSLayoutConstraint objects
    public let identifier: String

    /// The LayingOut object to get NSLayoutConstraint objects from
    public let layout: LayingOut

    /**
     Creates a new IdentifierLayout with a given String identifier and LayingOut object.

     - parameter identifier: The String identifier to add to the NSLayoutConstraint objects
     - parameter layout:     The LayingOut object to get NSLayoutConstraint objects from

     - returns: A new IdentifierLayout with the given String identifier and LayingOut object.
     */
    public init(identifier: String, layout: LayingOut) {
        self.identifier = identifier
        self.layout = layout
    }

    /**
     Returns the NSLayoutConstraint objects from the given LayingOut object with the identifier
     applied.

     - parameter view: The root view to generate NSLayoutConstraint objects for.

     - returns: An Array<NSLayoutConstraint> to use for the given view with the identifier property
     set to the String identifier.
     */
    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return layout.constraints(in: view).map { constraint in
            constraint.identifier = self.identifier
            return constraint
        }
    }
}

public extension IdentifierLayout {
    /**
     Creates a new IdentifierLayout with a given String identifier and closure.

     - parameter identifier: The String identifier to add to the NSLayoutConstraint objects
     - parameter handler: A closure that generates NSLayoutConstraint objects for a given view.

     - returns: A new IdentifierLayout with the given String identifier and closure.
     */
    public init(identifier: String, handler: (UIView) -> [NSLayoutConstraint]) {
        self.init(identifier: identifier, layout: Layout(handler: handler))
    }
}

public extension LayingOut {
    /**
     Creates a new IdentifierLayout with a given String identifier for the called LayingOut object.

     - parameter identifier: The String identifier to add tot he NSLayoutConstraint objects

     - returns: A new IdentifierLayout with the given String identifier for the called LayingOut 
    object.
     */
    public func identified(by identifier: String) -> IdentifierLayout {
        return IdentifierLayout(identifier: identifier, layout: self)
    }
}
