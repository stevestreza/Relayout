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
        for index in stride(from: startIndex.advanced(by: 1), to: endIndex, by: 1) {
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
        cancelButton.layer.zPosition = 2000
        cancelButton.layoutSubviews()
        cancelButton.addTarget(self, action: #selector(MenuViewController.toggleMenuVisible), for: .touchUpInside)
        view.addSubview(cancelButton)

        layout = ViewLayout(rootView: view, layouts: [
            // Horizontal layout or vertical?
            ConditionalLayout(
                condition: { view in self.buttons.count < 6 && view.traitCollection.horizontalSizeClass == .regular },
                // Horizontal
                layout: LayoutGroup(layouts: [
                    // Constrain each button horizontally by making the top/bottom/width equal to the next button
                    ListLayout(
                        items: { _ in self.buttons },
                        iterator: { (view, button, _, previous, next) -> [NSLayoutConstraint] in
                            guard let next = next ?? self.cancelButton else { return [] }
                            return [
                                button.topAnchor.constraint(equalTo: next.topAnchor),
                                button.bottomAnchor.constraint(equalTo: next.bottomAnchor),
                                (next == self.cancelButton ? nil : Optional<NSLayoutConstraint>.some(button.widthAnchor.constraint(equalTo: next.widthAnchor, multiplier: 1))),
                                button.trailingAnchor.constraint(equalTo: next.leadingAnchor, constant: (next == self.cancelButton ? -20 : -4))
                            ].flatMap { $0 }
                        }
                    ),
                    // Constrain the first and
                    Layout { view -> [NSLayoutConstraint] in
                        guard let firstButton = self.buttons.first ?? self.cancelButton else { return [] }
                        return [
                            firstButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                            self.cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
                        ]
                    }
                ]),
                // Vertical
                elseLayout: LayoutGroup(layouts: [
                    ListLayout(
                        items: { [weak self] _ in self?.buttons.reversed() ?? [] },
                        iterator: { (view, button, _, prev, _) -> [NSLayoutConstraint] in
                            guard let previous = (prev ?? self.cancelButton) else { return [] }
                            return [
                                button.leadingAnchor.constraint(equalTo: previous.leadingAnchor),
                                button.trailingAnchor.constraint(equalTo: previous.trailingAnchor),
                                button.bottomAnchor.constraint(equalTo: previous.topAnchor, constant: (prev == nil ? -20 : -4))
                            ]
                        }
                    ),
                    Layout(constraints: [
                        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
                    ]),
                ])
            ),
            ConditionalLayout(
                condition: { [weak self] _ in self?.menuVisible ?? false},
                layout: Layout { [weak self] _ in
                    guard let strongSelf = self else { return [] }
                    return [strongSelf.cancelButton.bottomAnchor.constraint(equalTo: strongSelf.view.bottomAnchor, constant: 0 - strongSelf.bottomLayoutGuide.length - 10)]
                },
                elseLayout: Layout { [weak self] _ in
                    guard let strongSelf = self else { return [] }
                    return [strongSelf.firstButton.topAnchor.constraint(equalTo: strongSelf.view.bottomAnchor, constant: 10)]
                }
            )
        ])


        layout.layout()
    }

    fileprivate func button(title: String) -> UIButton {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        return button
    }

    var buttons: [UIButton] = []
    var cancelButton: UIButton! = UIButton(type: .custom)

    var menuVisible: Bool = false
    @IBAction func toggleMenuVisible() {
        menuVisible = !menuVisible
        layoutMenu(animated: true)
    }

    var buttonCount = 0

    @IBAction func add() {
        buttonCount += 1

        let newButton = button(title: "Button \(buttonCount)")
        newButton.frame = (buttons.last ?? cancelButton)!.frame
        newButton.layer.zPosition = CGFloat(1000 - buttonCount)
        newButton.layoutSubviews()
        newButton.addTarget(self, action: #selector(MenuViewController.removeButton(_:)), for: .touchUpInside)
        view.addSubview(newButton)
        buttons.append(newButton)

        layoutMenu(animated: true)
    }

    @IBAction func removeButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: { 
            sender.alpha = 0
        }) { _ in
            sender.removeFromSuperview()
            self.buttons = self.buttons.filter { $0 != sender }
            self.layoutMenu(animated: true)
        }
    }

    func layoutMenu(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.5 : 0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: layout.layout, completion: nil)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layout?.layout()
    }
}
