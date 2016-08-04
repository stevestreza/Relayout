//
//  MenuViewController.swift
//  DeclarativeAutoLayout
//
//  Created by Steve Streza on 6/27/16.
//  Copyright © 2016 Steve Streza. All rights reserved.
//

import Foundation
import Relayout
import UIKit

extension Array {
    var pairs: [(Element, Element)] {
        var pairs: [(Element, Element)] = []

        guard count >= 2 else { return pairs}
        guard let first = self.first else { return pairs }

        var lastThing: Element = first
        for index in startIndex.advancedBy(1).stride(to: endIndex, by: 1) {
            let next = self[index]
            pairs.append((lastThing, next))
            lastThing = next
        }

        return pairs
    }
}

final class MenuViewController: UIViewController {
    var layout: ViewLayout!

    var allButtons: [UIButton] {
        var buttons = self.buttons
        buttons.append(cancelButton)
        return buttons
    }

    var firstButton: UIButton {
        return buttons.first ?? cancelButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton = button(title: "Cancel")
        cancelButton.layer.zPosition = 200
        cancelButton.layoutSubviews()
        view.addSubview(cancelButton)

        layout = ViewLayout(rootView: view, layouts: [
            // Horizontal layout or vertical?
            ConditionalLayout(
                condition: { view in self.buttons.count < 6 && view.traitCollection.horizontalSizeClass == .Regular },
                // Horizontal
                layout: LayoutGroup(layouts: [
                    // Constrain each button horizontally by making the top/bottom/width equal to the next button
                    ListLayout(
                        items: { _ in self.buttons },
                        iterator: { (view, button, _, previous, next) -> [NSLayoutConstraint] in
                            guard let next = next ?? self.cancelButton else { return [] }
                            return [
                                button.topAnchor.constraintEqualToAnchor(next.topAnchor),
                                button.bottomAnchor.constraintEqualToAnchor(next.bottomAnchor),
                                (next == self.cancelButton ? nil : button.widthAnchor.constraintEqualToAnchor(next.widthAnchor, multiplier: 1)),
                                button.trailingAnchor.constraintEqualToAnchor(next.leadingAnchor, constant: (next == self.cancelButton ? -20 : -4))
                            ]
                            .flatMap { $0 }
                        }
                    ),
                    // Constrain the first and
                    Layout { view -> [NSLayoutConstraint] in
                        guard let firstButton = self.buttons.first ?? self.cancelButton else { return [] }
                        return [
                            firstButton.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 10),
                            self.cancelButton.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -10)
                        ]
                    }
                ]),
                // Vertical
                elseLayout: LayoutGroup(layouts: [
                    ListLayout(
                        items: { [weak self] _ in self?.buttons.reverse() ?? [] },
                        iterator: { (view, button, _, prev, _) -> [NSLayoutConstraint] in
                            guard let previous = (prev ?? self.cancelButton) else { return [] }
                            return [
                                button.leadingAnchor.constraintEqualToAnchor(previous.leadingAnchor),
                                button.trailingAnchor.constraintEqualToAnchor(previous.trailingAnchor),
                                button.bottomAnchor.constraintEqualToAnchor(previous.topAnchor, constant: (prev == nil ? -20 : -4))
                            ]
                        }
                    ),
                    Layout(constraints: [
                        cancelButton.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 10),
                        cancelButton.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -10)
                    ]),
                ])
            ),
            ConditionalLayout(
                condition: { [weak self] _ in self?.menuVisible ?? false},
                layout: Layout { [weak self] _ in
                    guard let strongSelf = self else { return [] }
                    return [strongSelf.cancelButton.bottomAnchor.constraintEqualToAnchor(strongSelf.view.bottomAnchor, constant: 0 - strongSelf.bottomLayoutGuide.length - 10)]
                },
                elseLayout: Layout { [weak self] _ in
                    guard let strongSelf = self else { return [] }
                    return [strongSelf.firstButton.topAnchor.constraintEqualToAnchor(strongSelf.view.bottomAnchor, constant: 10)]
                }
            )
        ])


        layout.layout()
    }

    private func button(title title: String) -> UIButton {
        let button = UIButton(type: UIButtonType.RoundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(17)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        return button
    }

    var buttons: [UIButton] = []
    var cancelButton: UIButton! = UIButton(type: .Custom)

    var menuVisible: Bool = false
    @IBAction func toggleMenuVisible() {
        menuVisible = !menuVisible
        layoutMenu(animated: true)
    }

    @IBAction func add() {
        let newButton = button(title: "Button \(buttons.count + 1)")
        newButton.frame = (buttons.last ?? cancelButton)!.frame
        newButton.layer.zPosition = CGFloat(100 - buttons.count)
        newButton.layoutSubviews()

        view.addSubview(newButton)
        buttons.append(newButton)

        layoutMenu(animated: true)
    }

    func layoutMenu(animated animated: Bool) {
        UIView.animateWithDuration(animated ? 0.5 : 0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: layout.layout, completion: nil)
    }

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layout?.layout()
    }
}
