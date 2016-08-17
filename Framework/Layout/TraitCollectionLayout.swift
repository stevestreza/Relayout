import Foundation
import UIKit

/**
 *    A LayingOut object that returns NSLayoutConstraint objects only when the rootView has certain
 *    traits in its UITraitCollection.
 */
public struct TraitCollectionLayout: LayingOut {
    /// The UITraitCollection to match traits against.
    let matchingTraitCollection: UITraitCollection

    /// The LayingOut object to derive NSLayoutConstraint objects from if the rootView contains the
    /// traits in the `matchingTraitCollection`.
    let layout: LayingOut

    /**
     Creates a new TraitCollectionLayout checking against a given UITraitCollection and returning
     the NSLayoutConstraint objects from a given LayingOut object.

     - parameter matching: The UITraitCollection to match traits against.
     - parameter layout:   The LayingOut object to derive NSLayoutConstraint objects from if the 
     rootView contains the traits in the `matchingTraitCollection`.

     - returns: A new TraitCollectionLayout checking against a given UITraitCollection and returning
     the NSLayoutConstraint objects from a given LayingOut object.
     */
    public init(matching: UITraitCollection, layout: LayingOut) {
        self.matchingTraitCollection = matching
        self.layout = layout
    }

    /**
     Returns the NSLayoutConstraint objects from the given LayingOut object if the `view` contains
     the traits in the `matchingTraitCollection`, or an empty Array<NSLayoutConstraint> if not.

     - parameter view: The root view to generate NSLayoutConstraint objects for.

     - returns: An Array<NSLayoutConstraint> to use for the given view.
     */
    public func constraints(in view: UIView) -> [NSLayoutConstraint] {
        let traitCollection = view.traitCollection
        if traitCollection.containsTraitsInCollection(matchingTraitCollection) {
            return layout.constraints(in: view)
        }
        else {
            return []
        }
    }
}

public extension TraitCollectionLayout {
    /**
     Creates a new TraitCollectionLayout checking against given traits and returning the 
     NSLayoutConstraint objects from a given LayingOut object if they match.

     - parameter idiom:               A UIUserInfterfaceIdiom to check against, or nil if you don't 
     want to check against it
     - parameter scale:               A display scale to check against, or nil if you don't want to 
     check against it
     - parameter horizontalSizeClass: A horizontal UIUserInterfaceSizeClass to check against, or nil 
     if you don't want to check against it
     - parameter verticalSizeClass:   A vertical UIUserInterfaceSizeClass to check against, or nil 
     if you don't want to check against it
     - parameter layout:   The LayingOut object to derive NSLayoutConstraint objects from if the
     rootView contains the traits in the `matchingTraitCollection`.

     - returns: A new TraitCollectionLayout checking against a given UITraitCollection and returning
     the NSLayoutConstraint objects from a given LayingOut object.
     */
    public init(
        userInterfaceIdiom idiom: UIUserInterfaceIdiom? = nil,
        displayScale scale: CGFloat? = nil,
        horizontalSizeClass: UIUserInterfaceSizeClass? = nil,
        verticalSizeClass: UIUserInterfaceSizeClass? = nil,
        layout: LayingOut
    ) {
        let traitCollection = UITraitCollection(userInterfaceIdiom: idiom, displayScale: scale, horizontalSizeClass: horizontalSizeClass, verticalSizeClass: verticalSizeClass)
        self.init(matching: traitCollection, layout: layout)
    }
}

extension LayingOut {
    /**
     Creates a new TraitCollectionLayout checking against a given user interface idiom and returning 
     the NSLayoutConstraint objects from the called LayingOut object if they match.

     - parameter idiom:               A UIUserInfterfaceIdiom to check against

     - returns: A new TraitCollectionLayout checking against a given UITraitCollection and returning
     the NSLayoutConstraint objects from the called LayingOut object.
     */
    func when(userInterfaceIdiom idiom: UIUserInterfaceIdiom) -> TraitCollectionLayout {
        return TraitCollectionLayout(userInterfaceIdiom: idiom, layout: self)
    }

    /**
     Creates a new TraitCollectionLayout checking against a given display scale and returning
     the NSLayoutConstraint objects from the called LayingOut object if they match.

     - parameter scale:               A display scale to check against

     - returns: A new TraitCollectionLayout checking against a given UITraitCollection and returning
     the NSLayoutConstraint objects from the called LayingOut object.
     */
    func when(displayScale scale: CGFloat) -> TraitCollectionLayout {
        return TraitCollectionLayout(displayScale: scale, layout: self)
    }

    /**
     Creates a new TraitCollectionLayout checking against a given horizontal size class and 
     returning the NSLayoutConstraint objects from the called LayingOut object if they match.

     - parameter horizontalSizeClass: A horizontal UIUserInterfaceSizeClass to check against

     - returns: A new TraitCollectionLayout checking against a given UITraitCollection and returning
     the NSLayoutConstraint objects from the called LayingOut object.
     */
    func when(horizontalSizeClass sizeClass: UIUserInterfaceSizeClass) -> TraitCollectionLayout {
        return TraitCollectionLayout(horizontalSizeClass: sizeClass, layout: self)
    }

    /**
     Creates a new TraitCollectionLayout checking against a given vertical size class and returning
     the NSLayoutConstraint objects from the called LayingOut object if they match.

     - parameter verticalSizeClass:   A vertical UIUserInterfaceSizeClass to check against

     - returns: A new TraitCollectionLayout checking against a given UITraitCollection and returning
     the NSLayoutConstraint objects from the called LayingOut object.
     */
    func when(verticalSizeClass sizeClass: UIUserInterfaceSizeClass) -> TraitCollectionLayout {
        return TraitCollectionLayout(verticalSizeClass: sizeClass, layout: self)
    }

    /**
     Creates a new TraitCollectionLayout checking against given size classes and returning
     the NSLayoutConstraint objects from the called LayingOut object if they match.

     - parameter horizontalSizeClass: A horizontal UIUserInterfaceSizeClass to check against
     - parameter verticalSizeClass:   A vertical UIUserInterfaceSizeClass to check against

     - returns: A new TraitCollectionLayout checking against a given UITraitCollection and returning
     the NSLayoutConstraint objects from the called LayingOut object.
     */
    func when(horizontalSizeClass horizontalSizeClass: UIUserInterfaceSizeClass, verticalSizeClass: UIUserInterfaceSizeClass) -> TraitCollectionLayout {
        return TraitCollectionLayout(horizontalSizeClass: horizontalSizeClass, verticalSizeClass: verticalSizeClass, layout: self)
    }
    
    /// Creates a new TraitCollectionLayout checking if the user interface idiom is a phone and 
    /// returning the NSLayoutConstraint objects from the called LayingOut object if they match.
    var whenPhone: TraitCollectionLayout {
        return when(userInterfaceIdiom: .Phone)
    }

    /// Creates a new TraitCollectionLayout checking if the user interface idiom is a pad and
    /// returning the NSLayoutConstraint objects from the called LayingOut object if they match.
    var whenPad: TraitCollectionLayout {
        return when(userInterfaceIdiom: .Pad)
    }

    /// Creates a new TraitCollectionLayout checking if the user interface idiom is a TV and
    /// returning the NSLayoutConstraint objects from the called LayingOut object if they match.
    @available(iOS 9, *)
    var whenTV: TraitCollectionLayout {
        return when(userInterfaceIdiom: .TV)
    }

    /// Creates a new TraitCollectionLayout checking if the user interface idiom is in CarPlay mode 
    /// and returning the NSLayoutConstraint objects from the called LayingOut object if they match.
    @available(iOS 9, *)
    var whenCarPlay: TraitCollectionLayout {
        return when(userInterfaceIdiom: .CarPlay)
    }

    /// Creates a new TraitCollectionLayout checking if the user interface idiom is horizontally 
    /// compact and returning the NSLayoutConstraint objects from the called LayingOut object if 
    /// they match.
    var whenHorizontallyCompact: TraitCollectionLayout {
        return when(horizontalSizeClass: .Compact)
    }

    /// Creates a new TraitCollectionLayout checking if the user interface idiom is horizontally
    /// regular and returning the NSLayoutConstraint objects from the called LayingOut object if
    /// they match.
    var whenHorizontallyRegular: TraitCollectionLayout {
        return when(horizontalSizeClass: .Regular)
    }

    /// Creates a new TraitCollectionLayout checking if the user interface idiom is vertically
    /// compact and returning the NSLayoutConstraint objects from the called LayingOut object if
    /// they match.
    var whenVerticallyCompact: TraitCollectionLayout {
        return when(verticalSizeClass: .Compact)
    }

    /// Creates a new TraitCollectionLayout checking if the user interface idiom is vertically
    /// regular and returning the NSLayoutConstraint objects from the called LayingOut object if
    /// they match.
    var whenVerticallyRegular: TraitCollectionLayout {
        return when(verticalSizeClass: .Regular)
    }
}

private extension UITraitCollection {
    private convenience init(
        userInterfaceIdiom idiom: UIUserInterfaceIdiom? = nil,
        displayScale scale: CGFloat? = nil,
        horizontalSizeClass: UIUserInterfaceSizeClass? = nil,
        verticalSizeClass: UIUserInterfaceSizeClass? = nil
    ) {
        var collections: [UITraitCollection] = []

        if let idiom = idiom {
            collections.append(UITraitCollection(userInterfaceIdiom: idiom))
        }

        if let scale = scale {
            collections.append(UITraitCollection(displayScale: scale))
        }

        if let horizontalSizeClass = horizontalSizeClass {
            collections.append(UITraitCollection(horizontalSizeClass: horizontalSizeClass))
        }

        if let verticalSizeClass = verticalSizeClass {
            collections.append(UITraitCollection(verticalSizeClass: verticalSizeClass))
        }
        
        self.init(traitsFromCollections: collections)
    }
}
