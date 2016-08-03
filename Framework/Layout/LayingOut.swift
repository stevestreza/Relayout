import Foundation
import UIKit

public protocol LayingOut {
    func constraints(in in: UIView) -> [NSLayoutConstraint]
}
