import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

/**
 *    Iterates over an Array<T> of objects (along with their next and previous items) and generates
 *    NSLayoutConstraint objects for each item. This is very useful if you need to constrain views
 *    relative to each other.
 */
public struct ListLayout<T>: LayingOut {
    /// The type of object being iterated over.
    public typealias Element = T

    /**
     Returns an Array<Element> of objects to iterate over. Called once at the beginning of the
     layout cycle.
     
     - parameter: The root view to generate NSLayoutConstraint objects for.

     - returns: An Array<Element> of objects to be iterated over.
     */
    public let itemsObtainer: (UIView) -> Array<Element>

    /**
     Returns an Array<NSLayoutConstraint> for each object obtained from the `itemsObtainer`.

     - parameter rootView: The root view to generate NSLayoutConstraint objects for.
     - parameter element:  The element to generate NSLayoutConstraint objects for.
     - parameter index:    The index of the element returned from the `itemsObtainer`.
     - parameter previous: The previous element returned from the `itemsObtainer`, or nil if this is
     the first object.
     - parameter next:     The next element returned from the `itemsObtainer`, or nil if this is the
     last object.

     - returns: An Array<NSLayoutConstraint> to use for the given element.
     */
    public let itemIterator: (rootView: UIView, element: Element, index: Int, previous: Element?, next: Element?) -> [NSLayoutConstraint]

    /**
     Creates a new ListLayout with the given items obtainer and item iterator.

     - parameter items:    A closure to generate the list of objects to iterate over.
     - parameter iterator: A closure to call iterating over each item.

     - returns: A new ListLayout object with the given items obtainer and item iterator
     */
    public init(items: (UIView) -> Array<Element>, iterator: (rootView: UIView, element: Element, index: Int, previous: Element?, next: Element?) -> [NSLayoutConstraint]) {
        itemsObtainer = items
        itemIterator = iterator
    }

    /**
     Fetches the list of objects to iterate over, then fetches the constraints needed for each item
     iterated over, and returns them in a single Array<NSLayoutConstraint>.

     - parameter view: The root view to generate NSLayoutConstraint objects for.

     - returns: An Array<NSLayoutConstraint> to use for the given view.
     */
    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let items = itemsObtainer(view)
        for index in items.indices {
            let element = items[index]
            let previous: Element? = (index - 1 >= 0 ? items[index - 1] : nil)
            let next: Element? = (index + 1 < items.count ? items[index + 1] : nil)

            let newConstraints = itemIterator(rootView: view, element: element, index: index, previous: previous, next: next)
            constraints.appendContentsOf(newConstraints)
        }
        return constraints
    }
}
