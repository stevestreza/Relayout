import Foundation
import UIKit

public struct LayoutGroup: LayingOut {
    public let layouts: [LayingOut]
    public init(layouts: [LayingOut]) {
        self.layouts = layouts
    }

    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return layouts.flatMap { $0.constraints(in: view) }
    }
}

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