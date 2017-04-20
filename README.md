# Typist

![Swift Version](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)
[![Platform](https://img.shields.io/cocoapods/p/Typist.svg?style=flat)](http://cocoapods.org/pods/Typist)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Typist.svg)](https://img.shields.io/cocoapods/v/Typist.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/totocaster/Typist)
[![Twitter](https://img.shields.io/badge/twitter-@totocaster-blue.svg)](http://twitter.com/totocaster)


Typist is a small, drop-in Swift UIKit keyboard manager for iOS apps. It helps you manage keyboard's screen presence and behavior without notification center and Objective-C.

---

## Usage

Declare what should happen on what event and `start()` listening to keyboard events. That's it.

```swift
let keyboard = Typist.shared // use `Typist()` whenever you can, see note on singleton usage below

func configureKeyboard() {

    keyboard
        .on(event: .didShow) { (options) in
            print("New Keyboard Frame is \(options.endFrame).")
        }
        .on(event: .didHide) { (options) in
            print("It took \(options.animationDuration) seconds to animate keyboard out.")
        }
        .start()

}
```

You _must_ call `start()` for callbacks to be triggered. Calling `stop()` on instance will stop callbacks from triggering, but callbacks themselves won't be dismissed, thus you can resume event callbacks by calling `start()` again.

To remove all event callbacks, call `clear()`.

#### On Singleton Usage

Usage of `shared` singleton, considered to be OK for convenient access to instance. However, it is strongly recommended to instantiate dedicated `Typist()` for each usage (in `UIViewController`, most likely). **Do not use singleton** when two or more objects using `Typist.shared` are presented on screen simultaneously, as it will cause one of the controllers to fail receiving keyboard events.

### Event Callback Options

Every event callback has a parameter of `Typist.KeyboardOptions` type. It is an inert/immutable struct which carries all data that keyboard has at the event of happening:

* **`belongsToCurrentApp`** — `Bool` that identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value is `true` for the app that caused the keyboard to appear and `false` for any other apps.
* **`startFrame`** — `CGRect` that identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the view’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to view coordinates (using the `convert(CGRect, from: UIView?)` method) before using it.
* **`endFrame`** — `CGRect` that identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the view’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to view coordinates (using the `convert(CGRect, from: UIView?)` method) before using it.
* **`animationCurve`** — `UIViewAnimationCurve` constant that defines how the keyboard will be animated onto or off the screen.
* **`animationDuration`** — `Double` that identifies the duration of the animation in seconds.

### Events

Following keyboard events are supported:

* `willShow`
* `didShow`
* `willHide`
* `didHide`
* `willChangeFrame`
* `didChangeFrame`

If you declare two closures on same event, only latter will be executed.

---

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `Typist` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'Typist'
```

Import `Typist` wherever you plan to listen to keyboard events. Usually in your `UIViewController` subclasses.

``` swift
import UIKit
import Typist
```


#### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/Typist.framework` to an iOS project.

```
github "totocaster/Typist"
```

#### Manually
Download and drop ```Typist.swift``` in your project.

---

My thanks to [Jake Marsh](https://twitter.com/jakemarsh) for featuring Typist on Little Bites of Cocoa [#282: Taming the Keyboard with Typist ⌨️](https://littlebitesofcocoa.com/282-taming-the-keyboard-with-typist). It made my day.


---

## License

Typist is released under the MIT license. See ``LICENSE`` for details.
