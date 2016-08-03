import Foundation
import UIKit

struct Layout: LayingOut {
    let handler: (UIView) -> [NSLayoutConstraint]
    init(handler: (UIView) -> [NSLayoutConstraint]) {
        self.handler = handler
    }

    func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return handler(view)
    }
}
