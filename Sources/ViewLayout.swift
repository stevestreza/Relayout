import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

/// Manages a context of NSLayoutConstraint objects that will be applied to a given view.
public class ViewLayout {
    /// The root view that will have its layout managed by the ViewLayout.
    public let rootView: UIView

    /// The LayingOut objects that will define the layout for the rootView.
    public let layouts: [LayingOut]

    /**
     Creates a new ViewLayout with the given rootView and LayingOut objects.

     - parameter rootView: The root view that will have its layout managed by the ViewLayout.
     - parameter layouts:  The LayingOut objects that will define the layout for the rootView.

     - returns: A new ViewLayout for the given rootView and LayingOut objects.
     */
    public init(rootView: UIView, layouts: [LayingOut]) {
        self.rootView = rootView
        self.layouts = layouts
    }

    /**
     Creates a new ViewLayout with the given rootView and a single LayingOut object.

     - parameter rootView: The root view that will have its layout managed by the ViewLayout.
     - parameter layout:   The LayingOut object that will define the layout for the rootView.

     - returns: A new ViewLayout for the given rootView and LayingOut object.
     */
    public convenience init(rootView: UIView, layout: LayingOut) {
        self.init(rootView: rootView, layouts: [layout])
    }

    private(set) var activeConstraints: [NSLayoutConstraint] = []
    private var isLayingOut = false

    /**
     Deactivates the NSLayoutConstraint objects previously on the view, generates a new 
     Array<NSLayoutConstraint> to apply to the view, and then activates those.

     - note: You can call this from within a UIView animation context and your view will animate
     into place. If you're adding new views to the layout, consider pre-setting their `frame` 
     property to define their starting position.
     
     - note: This method is reentrant, but will not recalculate NSLayoutConstraint objects, so you 
     can call this from methods that may themselves trigger a layout (but nothing will happen 
     subsequently).
     */
    public func layout() {
        guard isLayingOut == false else { return }
        isLayingOut = true

        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints = layouts.flatMap { $0.constraints(in: self.rootView) }
        NSLayoutConstraint.activate(activeConstraints)

		#if os(OSX)
			rootView.needsLayout = true
			rootView.updateConstraintsForSubtreeIfNeeded()
			rootView.layoutSubtreeIfNeeded()
		#else
			rootView.setNeedsLayout()
			rootView.layoutIfNeeded()
		#endif

        isLayingOut = false
    }
}

public extension LayingOut {
    /**
     Creates a new ViewLayout from the given LayingOut object and a root view.

     - parameter rootView: The root view that will have its layout managed by the ViewLayout.

     - returns: A new ViewLayout for the given rootView and LayingOut object.
     */
    public func viewLayout(withRootView rootView: UIView) -> ViewLayout {
        return ViewLayout(rootView: rootView, layout: self)
    }
}
