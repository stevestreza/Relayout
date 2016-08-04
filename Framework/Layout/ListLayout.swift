import Foundation
import UIKit

public struct ListLayout<T>: LayingOut {
    public typealias Element = T

    public let itemsObtainer: (UIView) -> Array<Element>
    public let itemIterator: (UIView, Element, Int, Element?, Element?) -> [NSLayoutConstraint]

    public init(items: (UIView) -> Array<Element>, iterator: (UIView, Element, Int, Element?, Element?) -> [NSLayoutConstraint]) {
        itemsObtainer = items
        itemIterator = iterator
    }

    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        let items = itemsObtainer(view)
        for index in items.startIndex.stride(to: items.endIndex, by: 1) {
            let element = items[index]
            let previous: Element? = (index - 1 >= 0 ? items[index - 1] : nil)
            let next: Element? = (index + 1 < items.count ? items[index + 1] : nil)
            constraints.appendContentsOf(itemIterator(view, element, index, previous, next))
        }
        return constraints
    }
}
