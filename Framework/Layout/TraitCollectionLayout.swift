import Foundation
import UIKit

public struct TraitCollectionLayout: LayingOut {
    let matchingTraitCollection: UITraitCollection
    let layout: LayingOut

    public init(matching: UITraitCollection, layout: LayingOut) {
        self.matchingTraitCollection = matching
        self.layout = layout
    }

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

public extension TraitCollectionLayout {
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
    func when(userInterfaceIdiom idiom: UIUserInterfaceIdiom) -> TraitCollectionLayout {
        return TraitCollectionLayout(userInterfaceIdiom: idiom, layout: self)
    }

    func when(displayScale scale: CGFloat) -> TraitCollectionLayout {
        return TraitCollectionLayout(displayScale: scale, layout: self)
    }

    func when(horizontalSizeClass sizeClass: UIUserInterfaceSizeClass) -> TraitCollectionLayout {
        return TraitCollectionLayout(horizontalSizeClass: sizeClass, layout: self)
    }

    func when(verticalSizeClass sizeClass: UIUserInterfaceSizeClass) -> TraitCollectionLayout {
        return TraitCollectionLayout(verticalSizeClass: sizeClass, layout: self)
    }

    var whenPhone: TraitCollectionLayout {
        return when(userInterfaceIdiom: .Phone)
    }

    var whenPad: TraitCollectionLayout {
        return when(userInterfaceIdiom: .Pad)
    }

    var whenTV: TraitCollectionLayout {
        return when(userInterfaceIdiom: .TV)
    }

    var whenCarPlay: TraitCollectionLayout {
        return when(userInterfaceIdiom: .CarPlay)
    }

    var whenHorizontallyCompact: TraitCollectionLayout {
        return when(horizontalSizeClass: .Compact)
    }

    var whenHorizontallyRegular: TraitCollectionLayout {
        return when(horizontalSizeClass: .Regular)
    }

    var whenVerticallyCompact: TraitCollectionLayout {
        return when(verticalSizeClass: .Compact)
    }

    var whenVerticallyRegular: TraitCollectionLayout {
        return when(verticalSizeClass: .Regular)
    }
}
