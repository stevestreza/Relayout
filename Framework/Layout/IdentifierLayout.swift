import Foundation
import UIKit

/**
 *    Adds a given String identifier to the NSLayoutConstraint objects returned by a given LayingOut
 *    object.
 */
public struct IdentifierLayout: LayingOut {
    /// The String identifier to add to the NSLayoutConstraint objects
    public let identifier: String

    /// Specifies whether an index number should be added to the identifier.
    public let numbered: Bool

    /// The LayingOut object to get NSLayoutConstraint objects from
    public let layout: LayingOut

    /**
     Creates a new IdentifierLayout with a given String identifier and LayingOut object.

     - parameter identifier: The String identifier to add to the NSLayoutConstraint objects
     - parameter numbered:   Whether an index number should be added to the identifier. Defaults
     to false.
     - parameter layout:     The LayingOut object to get NSLayoutConstraint objects from

     - returns: A new IdentifierLayout with the given String identifier and LayingOut object.
     */
    public init(identifier: String, numbered: Bool = false, layout: LayingOut) {
        self.identifier = identifier
        self.numbered = numbered
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
        let constraints = layout.constraints(in: view)
        return constraints.indices.map { index in
            let constraint = constraints[index]

            let identifier: String
            if numbered {
                identifier = "\(self.identifier) [\(index)]"
            }
            else {
                identifier = self.identifier
            }
            constraint.identifier = identifier
            return constraint
        }
    }
}

public extension IdentifierLayout {
    /**
     Creates a new IdentifierLayout with a given String identifier and closure.

     - parameter identifier: The String identifier to add to the NSLayoutConstraint objects
     - parameter numbered:   Whether an index number should be added to the identifier. Defaults
     to false.
     - parameter handler: A closure that generates NSLayoutConstraint objects for a given view.

     - returns: A new IdentifierLayout with the given String identifier and closure.
     */
    public init(identifier: String, numbered: Bool = false, handler: (UIView) -> [NSLayoutConstraint]) {
        self.init(identifier: identifier, numbered: numbered, layout: Layout(handler: handler))
    }
}

public extension LayingOut {
    /**
     Creates a new IdentifierLayout with a given String identifier for the called LayingOut object.

     - parameter identifier: The String identifier to add tot he NSLayoutConstraint objects
     - parameter numbered:   Whether an index number should be added to the identifier. Defaults
     to false.

     - returns: A new IdentifierLayout with the given String identifier for the called LayingOut 
    object.
     */
    public func identified(by identifier: String, numbered: Bool = false) -> IdentifierLayout {
        return IdentifierLayout(identifier: identifier, numbered: numbered, layout: self)
    }
}
