import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

/**
 *    A LayingOut object that merges the NSLayoutConstraint objects from an Array of LayingOut
 *    objects.
 */
public struct LayoutGroup: LayingOut {
    /// The LayingOut objects to generate constraints from.
    public let layouts: [LayingOut]

    /**
     Creates a new LayoutGroup from an Array of LayingOut objects.

     - parameter layouts: The LayingOut objects to generate constraints from.

     - returns: A new LayoutGroup with the given LayingOut objects.
     */
    public init(layouts: [LayingOut]) {
        self.layouts = layouts
    }

    /**
     Returns the constraints from each LayingOut object combined together.

     - parameter view: The root view to return constraints for.

     - returns: The NSLayoutConstraint objects from each LayingOut object flattened into an Array.
     */
    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return layouts.flatMap { $0.constraints(in: view) }
    }
}

/**
 Creates a LayoutGroup from the supplied LayingOut objects.
 
 - note: If either parameter is itself a LayoutGroup, the LayingOut objects from that LayoutGroup
 will be flattened into a single Array<LayingOut>.

 - parameter lhs: A LayingOut object to add to a LayoutGroup
 - parameter rhs: A LayingOut object to add to a LayoutGroup

 - returns: A new LayoutGroup with the supplied LayingOut objects.
 */
public func +(lhs: LayingOut, rhs: LayingOut) -> LayoutGroup {
    var layouts: [LayingOut] = []
    if let lhsGroup = lhs as? LayoutGroup {
        layouts.appendContentsOf(lhsGroup.layouts)
    }
    else {
        layouts.append(lhs)
    }

    if let rhsGroup = rhs as? LayoutGroup {
        layouts.appendContentsOf(rhsGroup.layouts)
    }
    else {
        layouts.append(rhs)
    }

    return LayoutGroup(layouts: layouts)
}