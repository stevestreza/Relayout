import Foundation
import UIKit

public struct IdentifierLayout: LayingOut {
    public let identifier: String
    public let layout: LayingOut
    public init(identifier: String, layout: LayingOut) {
        self.identifier = identifier
        self.layout = layout
    }

    public init(identifier: String, handler: (UIView) -> [NSLayoutConstraint]) {
        self.init(identifier: identifier, layout: Layout(handler: handler))
    }

    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return layout.constraints(in: view).map { constraint in
            constraint.identifier = self.identifier
            return constraint
        }
    }
}

public extension LayingOut {
    public func identified(by identifier: String) -> IdentifierLayout {
        return IdentifierLayout(identifier: identifier, layout: self)
    }
}
