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
        view.addSubview(cancelButton)

        layout = ViewLayout(rootView: view, layouts: [
            Layout(constraints: [
                cancelButton.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 10),
                cancelButton.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -10)
            ]),
            Layout { [weak self] view -> [NSLayoutConstraint] in
                guard let strongSelf = self else { return [] }
                let cancelButton = strongSelf.cancelButton!

                let buttonConstraints = strongSelf.allButtons.reverse().pairs.flatMap({ (buttons: (UIButton, UIButton)) -> [NSLayoutConstraint] in
                    let (previous, button) = buttons
                    let offset: CGFloat = (previous == cancelButton) ? -20 : -4
                    return [
                        button.leadingAnchor.constraintEqualToAnchor(previous.leadingAnchor),
                        button.trailingAnchor.constraintEqualToAnchor(previous.trailingAnchor),
                        button.bottomAnchor.constraintEqualToAnchor(previous.topAnchor, constant: offset)
                    ]
                })

                return buttonConstraints
            },
            ConditionalLayout(
                condition: { [weak self] in self?.menuVisible ?? false},
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
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        button.layer.cornerRadius = 10
        return button
    }

    var buttons: [UIButton] = []
    var cancelButton: UIButton! = UIButton(type: .Custom)

    var menuVisible: Bool = false
    @IBAction func toggleMenuVisible() {
        menuVisible = !menuVisible
        layoutMenu()
    }

    @IBAction func add() {
        let newButton = button(title: "Button \(buttons.count + 1)")
        newButton.frame = (buttons.last ?? cancelButton)!.frame
        view.addSubview(newButton)
        buttons.append(newButton)

        layoutMenu()
    }

    func layoutMenu() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: layout.layout, completion: nil)
    }
}
