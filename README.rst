Relayout
========

.. image:: https://travis-ci.org/stevestreza/Relayout.svg

Relayout is a Swift microframework to make using Auto Layout easier with static and dynamic layouts.

Why?
====

If you want to build a UI using Apple's UI frameworks today, you have three good options. You can use Auto Layout in Interface Builder, you can use Auto Layout in code and maintain references to those constraints, or you can implement a layout function with `layoutSubviews`:code:. Each of these approaches has pros and cons.

- If you layout manually with `layoutSubviews`:code:, you're usually doing the job of Auto Layout - describing the layout of UI elements. But instead of doing it with objects to describe those relationships, you end up describing it with mathematical equations. This can be the most explicit and least error prone, but can be difficult to read and understand later. You also don't pick up features like right-to-left language support. But you get the benefit of having a single method that handles all your layout, regardless of why a layout changed. 
- If you use Auto Layout in Interface Builder, you can end up with inconsistencies in your actual layout vs what Interface Builder creates, as it tries to magically fix issues with your layout. It can also be difficult to change those constraints later, either at runtime, or when you need to add a new feature. However, if you need a simple UI that doesn't change much, it can be an effective and quick way to get the job done.
- If you use Auto Layout in code, you get the benefits of the higher level abstraction and improved code readability. And this can be a good approach if you don't need dynamism in your UI. But if you need to be able to change the UI at runtime, you have to hold on to references to individual constraints, add and remove constraints, and hope you don't see the dreaded "Unable to simultaneously satisfy constraints" warning.

The fundamental problem behind making dynamic layouts is *state transformations*. Going from 1 state to 2 is easy (add 2 transformations, A -> B and B -> A). Going from 2 to 3 is still fairly easy (add 4 transformations, B -> C, A -> C, C -> B, and C -> A). But as you add more and more states, you end up doubling the number of transformations you need to account for, all while fully satisfying the constraint system. This exponential growth is unsustainable, especially when you don't really care about the transformations as much as the states themselves.

Wouldn't it be great if we could cherry pick some of the most useful properties of the approaches? Auto Layout is a very good tool because of how descriptive it is, and we should use it, but not in its current form. Let's take a page from React.js and define a function that returns a pile of constraints that we want for a given UI state. 

You could define a single object that generates a pile of constraints for your view. Any time anything happens that could possibly change those constraints, throw the old ones out and generate a new set of constraints. That's what Relayout is.

Since the goal of Relayout is to make it easier to use Auto Layout, it tries to have a minimal impact on your app. You can use it in a view controller or within individual views. You can use it for parts of your app, and not use it elsewhere. You can compose layouts together and control them conditionally based on behaviors like `UITraitCollection`:code: state. Whatever you want to do.

What It Is Not
--------------

Relayout is not a tool for creating constraints. That's up to you. Want to use the `NSLayoutConstraint`:code: visual formatting language? The iOS 9+ anchor APIs? A third-party library like PureLayout? As long as it returns `NSLayoutConstraint`:code: objects, Relayout can use them. But we're not going to be opinionated about how you create them, or whether they come pre-activated or not. 

Relayout is also not an alternative or replacement to Auto Layout, but rather an augmentation. It **requires** the use of Auto Layout, and that means the rules that come along with it. So if you hate Auto Layout and don't want to use it, then Relayout may not be for you (though you may find that the reasons you hate Auto Layout no longer exist when using Relayout!).

Relayout is also not the definitive implementation of a functional layout. It's an idea, that having a function that generates a list of constraints is a good way to build UI. It's a set of objects that implement that idea. Feel free to take this idea, and build on it, to help make it easier to build and scale UIs.

Finally, Relayout is not a great tool to use in conjunction with Interface Builder. Both Interface Builder and Relayout want you to supply a complete set of constraints to fully describe a UI. Trying to get those two to play nicely is a fight neither you nor I want to solve.

Installing
==========

You can install Relayout with Carthage, CocoaPods, or manually.

With CocoaPods
--------------

Add the following to your `Podfile`:code:. ::

   pod 'Relayout', '~> 1.0'

With Carthage
-------------

Add the following to your `Cartfile`:code:. ::

   github stevestreza/Relayouta ~> 1.0

Manually
--------

`Relayout.xcodeproj`:code: creates a `Relayout.framework`, so you can include the framework as an Xcode target dependency, and copy/link it into your app. Alternatively, you can include the source files from the Framework target as you see fit.

Swift 3
-------

When Swift 3 lands the project will be immediately updated to support it with a major update to the version number (e.g. version `2.0.0`:code:).

Usage
=====

You can use Relayout from within both views and view controllers. To take advantage of it, you will need a `ViewLayout`:code: object. Create one with a root view (such as the view controller's view, the table cell's content view, or the view itself). You will also need to give it an object that conforms to the `LayingOut`:code: protocol. This protocol is very simple and has one method which takes your root view and returns an `Array<NSLayoutConstraint>`:code:, which represents the list of constraints that you want applied.

Once you have a `ViewLayout`:code: object, you'll want to call its `layout()`:code: method anywhere that might trigger a layout. Places where that may happen include `updateConstraints`:code:, `setFrame`:code:, `traitCollectionDidChange`:code:, and any place where your UI's state changes.

The simplest way to return constraints is to use the `Layout`:code: object, which accepts either an `Array<NSLayoutConstraint>`:code: to pass through directly, or a closure that takes your root view and returns the `Array<NSLayoutConstraint>`:code: to apply to it.

Relayout was designed to be composable, meaning that the `Layout`:code: object is one building block to use to build powerful and flexible layouts. There are a number of implementations of the `LayingOut`:code: protocol, either existing or planned. So far you can use:

- `LayoutGroup`:code:, which returns all of the `NSLayoutConstraint`:code: objects provided by an `Array<LayingOut>`:code: object
- `IdentifyingLayout`:code:, which adds an identifier to all `NSLayoutConstraint`:code: objects for a given `LayingOut`:code: object (which is useful for debugging unsatisfiable constraint errors)
- `ConditionalLayout`:code:, which returns the `NSLayoutConstraint`:code: objects from a given `LayingOut`:code: object if the condition is true, and optionally return other `NSLayoutConstraint`:code: objects if the condition is false
- `TraitCollectionLayout`:code:, which returns the `NSLayoutConstraint`:code: objects from a given `LayingOut`:code: object iff the root view has certain `UITraitCollection`:code: traits
- `ListLayout`:code:, which iterates over a list of objects, calling a closure that returns `NSLayoutConstraint`:code: objects when passed the object, its index, and the previous and next objects in the list (to easily constrain between an object and its next and previous views).

And you can of course implement the `LayingOut`:code: protocol if you see fit. It has no `Self`:code: requirement, so you can use them interchangeably anywhere.

