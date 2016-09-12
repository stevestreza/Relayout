import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

/**
 *    A LayingOut object that returns NSLayoutConstraint objects from a closure.
 */
public struct Layout: LayingOut {
    /// The closure that generates NSLayoutConstraint objects for a given view.
    public let handler: (UIView) -> [NSLayoutConstraint]

    /**
     Creates a new Layout for the given closure.

     - parameter handler: A closure that generates NSLayoutConstraint objects for a given view.

     - returns: A new Layout object for the given closure.
     */
    public init(handler: @escaping (UIView) -> [NSLayoutConstraint]) {
        self.handler = handler
    }

    /**
     Returns the NSLayoutConstraint objects from the given closure.

     - parameter view: The root view to generate NSLayoutConstraint objects for.

     - returns: An Array<NSLayoutConstraint> to use for the given view.
     */
    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return handler(view)
    }
}

public extension Layout {
    /**
     Creates a new Layout that always returns a given Array<NSLayoutConstraint>.

     - parameter constraints: The NSLayoutConstraint objects to use.

     - returns: A new Layout object for the given NSLayoutConstraint objects.
     */
    public init(constraints: [NSLayoutConstraint]) {
        self.handler = { _ in constraints }
    }
}
