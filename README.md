# Typist

Small Swift helper to manage UIKit keyboard on iOS devices.

---

## Usage

Basic usage:

```swift
let keybaord = Typist.shared

func configureKeyboard() {
	
    keybaord
        .on(event: .didShow) { (options) in
            print("New Keyboard Frame is \(options.endFrame).")
        }
        .on(event: .didHide) { (options) in
            sprint("It took \(options.animationDuration) seconds to animate keyboard out.")
        }
        .start()

}
```

Usage of both—singleton, or your own instance of `Typist`—is considered to be OK depending on what do you want to accomplish.

You _must_ call `start()` for callbacks to be triggered. `stop()` will stop callbacks from trigering, but callbacks themselfs won't be cleared, thus you can resume event callbacks by calling `start()` again.

To clear all event callbacks, call `clear()`.

## Callback Options

Every event callback has a parameter of `Typist.KeyboardOptions`. It is inert/immutable struct which carries all data that keyboard has at the event of happening:

* **`belongsToCurrentApp`** — `Bool` that identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value of this key is `true` for the app that caused the keyboard to appear and `false` for any other apps.
* **`startFrame`** — `CGRect` that identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
* **`endFrame`** — `CGRect` that identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
* **`animationCurve`** — `UIViewAnimationCurve` constant that defines how the keyboard will be animated onto or off the screen.
* **`animationDuration`** — `CGFloat` containing a double that identifies the duration of the animation in seconds.


## Events ##

Following keyboard events are supported:

* `willShow`
* `didShow`
* `willHide`
* `didHide`
* `willChangeFrame`
* `didChangeFrame`

If you declare two closures on same event, only latter will be executed. (For now...?)

## Licence

MIT.
