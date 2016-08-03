import Foundation
import UIKit

public struct Layout: LayingOut {
    public let handler: (UIView) -> [NSLayoutConstraint]
    public init(handler: (UIView) -> [NSLayoutConstraint]) {
        self.handler = handler
    }

    public init(constraints: [NSLayoutConstraint]) {
        self.handler = { _ in constraints }
    }

    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return handler(view)
    }
}
