import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

/**
 *    Protocol for generating an Array<NSLayoutConstraint> to apply in a given view.
 */
public protocol LayingOut {
    /**
     Generate the constraints that should apply to the given view.

     - parameter view: The target view that NSLayoutConstraint objects should be generated for.

     - note: These NSLayoutConstraint objects will have `NSLayoutConstraint.activateConstraints(_:)` 
     called on them by the `ViewLayout`, so you don't need to activate them, though you can.
     - note: The NSLayoutConstraint objects returned should be limited to the root view and subviews 
     within its view hierarchy. You shouldn't constrain to the root view's superviews, for example; 
     that's an encapsulation violation and probably a code smell.

     - returns: An Array<NSLayoutConstraint> that will be applied.
     */
    func constraints(in view: UIView) -> [NSLayoutConstraint]
}
