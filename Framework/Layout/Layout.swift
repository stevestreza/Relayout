import Foundation
import UIKit

public struct Layout: LayingOut {
    public let handler: (UIView) -> [NSLayoutConstraint]
    public init(handler: (UIView) -> [NSLayoutConstraint]) {
        self.handler = handler
    }

    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return handler(view)
    }
}
