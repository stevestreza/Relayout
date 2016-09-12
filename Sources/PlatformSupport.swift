import Foundation
#if os(OSX)
    import AppKit
    public typealias UIView = NSView
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif
