//
//  ViewController.swift
//  DeclarativeAutoLayout
//
//  Created by Steve Streza on 6/23/16.
//  Copyright © 2016 Steve Streza. All rights reserved.
//

import Relayout
import UIKit

class CrustyViewController: UIViewController {

    var layout: ViewLayout?

    @IBOutlet var targetView: UIView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var widthSlider: UISlider!
    @IBOutlet var insetSlider: UISlider!

    let imageView = UIImageView(image: UIImage(named: "Crusty"))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        layout = ViewLayout(rootView: targetView, layouts: [
            IdentifierLayout(identifier: "Top Left") { _ in
                let inset = CGFloat(self.insetSlider.value)
                var constraints: [NSLayoutConstraint] = []
                if self.segmentedControl.selectedSegmentIndex == 0 {
                    constraints = [
                        self.imageView.leadingAnchor.constraintEqualToAnchor(self.targetView.leadingAnchor, constant: inset),
                        self.imageView.topAnchor.constraintEqualToAnchor(self.targetView.topAnchor, constant: inset)
                    ]
                }
                return constraints
            },
            IdentifierLayout(identifier: "Top Right") { _ in
                let inset = CGFloat(self.insetSlider.value)
                var constraints: [NSLayoutConstraint] = []
                if self.segmentedControl.selectedSegmentIndex == 1 {
                    constraints = [
                        self.imageView.trailingAnchor.constraintEqualToAnchor(self.targetView.trailingAnchor, constant: -inset),
                        self.imageView.topAnchor.constraintEqualToAnchor(self.targetView.topAnchor, constant: inset)
                    ]
                }
                return constraints
            },
            IdentifierLayout(identifier: "Bottom Left") { _ in
                let inset = CGFloat(self.insetSlider.value)
                var constraints: [NSLayoutConstraint] = []
                if self.segmentedControl.selectedSegmentIndex == 2 {
                    constraints = [
                        self.imageView.leadingAnchor.constraintEqualToAnchor(self.targetView.leadingAnchor, constant: inset),
                        self.imageView.bottomAnchor.constraintEqualToAnchor(self.targetView.bottomAnchor, constant: -inset)
                    ]
                }
                return constraints
            },
            IdentifierLayout(identifier: "Bottom Right") { _ in
                let inset = CGFloat(self.insetSlider.value)
                var constraints: [NSLayoutConstraint] = []
                if self.segmentedControl.selectedSegmentIndex == 3 {
                    constraints = [
                        self.imageView.trailingAnchor.constraintEqualToAnchor(self.targetView.trailingAnchor, constant: -inset),
                        self.imageView.bottomAnchor.constraintEqualToAnchor(self.targetView.bottomAnchor, constant: -inset)
                    ]
                }
                return constraints
            },
            IdentifierLayout(identifier: "Center") { _ in
                var constraints: [NSLayoutConstraint] = []
                if self.segmentedControl.selectedSegmentIndex == 4 {
                    constraints = [
                        self.imageView.centerXAnchor.constraintEqualToAnchor(self.targetView.centerXAnchor, constant: 0),
                        self.imageView.centerYAnchor.constraintEqualToAnchor(self.targetView.centerYAnchor, constant: 0),
                    ]
                }
                return constraints
            },
            IdentifierLayout(identifier: "Sizing") { _ in 
                return [
                    self.imageView.widthAnchor.constraintEqualToAnchor(self.imageView.heightAnchor, multiplier: 1),
                    self.imageView.widthAnchor.constraintEqualToConstant(CGFloat(self.widthSlider.value))
                ]
            },
        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        targetView.addSubview(imageView)

        layout?.layout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateUI(animated animated: Bool = true) {
        UIView.animateWithDuration((animated ? 0.5 : 0.0), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.layout?.layout()
        }, completion: nil)
    }

    @IBAction func moveCrusty() {
        updateUI(animated: true)
    }
    
    @IBAction func moveCrustyWithoutAnimating() {
        updateUI(animated: false)
    }
    
    override func viewWillLayoutSubviews() {
    }
}

