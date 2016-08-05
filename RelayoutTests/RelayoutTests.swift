//
//  RelayoutTests.swift
//  RelayoutTests
//
//  Created by Steve Streza on 8/2/16.
//  Copyright © 2016 Steve Streza. All rights reserved.
//

import XCTest
@testable import Relayout

class RelayoutTests: XCTestCase {
    func newLayout() -> (UIView, UIView, LayingOut)  {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        let subview = UIView(frame: .zero)
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)

        view.constraints.forEach { view.removeConstraint($0) }

        let layout = Layout { rootView -> [NSLayoutConstraint] in
            XCTAssertEqual(rootView, view)
            return [
                subview.widthAnchor.constraintEqualToConstant(40),
                subview.heightAnchor.constraintEqualToConstant(40),
                subview.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 20),
                subview.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20),
            ]
        }
        return (view, subview, layout)
    }

    func testViewLayout() {
        let (view, subview, layout) = newLayout()
        let viewLayout = ViewLayout(rootView: view, layout: layout)

        XCTAssertEqual(view.constraints.count, 0)

        viewLayout.layout()
        XCTAssertNotEqual(view.constraints.count, 0)
        XCTAssertEqual(subview.frame.width, 40)
        XCTAssertEqual(subview.frame.height, 40)
        XCTAssertEqual(subview.frame.minX, 20)
        XCTAssertEqual(subview.frame.minY, 20)
    }

    func testIdentifiedLayout() {
        let (view, _, layout) = newLayout()
        let identifiedLayout = ViewLayout(rootView: view, layout: layout.identified(by: "Test"))
        XCTAssertEqual(view.constraints.count, 0)

        identifiedLayout.layout()
        view.constraints.forEach { XCTAssertEqual($0.identifier, "Test") }
    }

    func testConditionalLayout() {
        let (view, subview, layout) = newLayout()

        var test: Bool = false
        let identifiedLayout = ViewLayout(rootView: view, layout: layout.when({ _ in test }))
        XCTAssertEqual(view.constraints.count, 0)

        identifiedLayout.layout()
        XCTAssertEqual(view.constraints.count, 0)

        test = true
        identifiedLayout.layout()
        XCTAssertNotEqual(view.constraints.count, 0)
        XCTAssertEqual(subview.frame.width, 40)
        XCTAssertEqual(subview.frame.height, 40)
        XCTAssertEqual(subview.frame.minX, 20)
        XCTAssertEqual(subview.frame.minY, 20)
    }
}
