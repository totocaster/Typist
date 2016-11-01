# Typist

![Swift Version](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Typist.svg)](https://img.shields.io/cocoapods/v/Typist.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/totocaster/Typist)
[![Platform](https://img.shields.io/cocoapods/p/Typist.svg?style=flat)](http://cocoapods.org/pods/Typist)


Typist is a small, drop-in Swift UIKit keyboard manager for iOS apps. It helps you manage keyboard's screen presence and behavior without notification center and Objective-C.

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

## Usage

Declare what should happen on what event and `start()` listening to keyboard events. That's it.

```swift
let keyboard = Typist.shared

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

Usage of both—`shared` singleton, or your own instance of `Typist`—is considered to be OK depending on what you want to accomplish. However, **do not use singleton** when two or more objects (`UIViewController`s, most likely) using `Typist.shared` are presented on screen simultaneously. This will cause one of the controllers to fail at receiving keyboard events. 

You _must_ call `start()` for callbacks to be triggered. Calling `stop()` on instance will stop callbacks from triggering, but callbacks themselves won't be dismissed, thus you can resume event callbacks by calling `start()` again.

To remove all event callbacks, call `clear()`.

### Event Callback Options

Every event callback has a parameter of `Typist.KeyboardOptions` type. It is an inert/immutable struct which carries all data that keyboard has at the event of happening:

* **`belongsToCurrentApp`** — `Bool` that identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value is `true` for the app that caused the keyboard to appear and `false` for any other apps.
* **`startFrame`** — `CGRect` that identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
* **`endFrame`** — `CGRect` that identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
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

## License

Typist is released under the MIT license. See ``LICENSE`` for details.
