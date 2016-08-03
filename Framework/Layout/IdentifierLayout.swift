import Foundation
import UIKit

struct IdentifierLayout: LayingOut {
    let identifier: String
    let layout: LayingOut
    init(identifier: String, layout: LayingOut) {
        self.identifier = identifier
        self.layout = layout
    }

    init(identifier: String, handler: (UIView) -> [NSLayoutConstraint]) {
        self.init(identifier: identifier, layout: Layout(handler: handler))
    }

    func constraints(in view: UIView) -> [NSLayoutConstraint] {
        return layout.constraints(in: view).map { constraint in
            constraint.identifier = self.identifier
            return constraint
        }
    }
}

extension LayingOut {
    func identified(by identifier: String) -> IdentifierLayout {
        return IdentifierLayout(identifier: identifier, layout: self)
    }
}
