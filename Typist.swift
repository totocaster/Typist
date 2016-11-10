//
//  Typist.swift
//  Small Swift helper to manage UIKit keyboard on iOS devices.
//
//  Created by Toto Tvalavadze on 2016/09/26. MIT Licence.
//

import UIKit

/**
 Typist is small, drop-in Swift UIKit keyboard manager for iOS apps. It helps you manage keyboard's screen presence and behavior without notification center and Objective-C.
 
 Declare what should happen on what event and `start()` listening to keyboard events. Like so:
 
 ```
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
 */
public class Typist: NSObject {
    
    /// Returns the shared instance of Typist, creating it if necessary.
    static public let shared = Typist()
    
    
    /// Inert/immutable objects which carries all data that keyboard has at the event of happening.
    public struct KeyboardOptions {
        /// Identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value of this key is `true` for the app that caused the keyboard to appear and `false` for any other apps.
        public let belongsToCurrentApp: Bool
        
        /// Identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
        public let startFrame: CGRect
        
        /// Identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
        public let endFrame: CGRect
        
        /// Constant that defines how the keyboard will be animated onto or off the screen.
        public let animationCurve: UIViewAnimationCurve
        
        /// Identifies the duration of the animation in seconds.
        public let animationDuration: Double
    }
    
    /// TypistCallback
    public typealias TypistCallback = (KeyboardOptions) -> ()
    
    
    /// Keyboard events that can happen. Translates directly to `UIKeyboard` notifications from UIKit.
    public enum KeyboardEvent {
        /// Event raised by UIKit's `.UIKeyboardWillShow`.
        case willShow
        
        /// Event raised by UIKit's `.UIKeyboardDidShow`.
        case didShow
        
        /// Event raised by UIKit's `.UIKeyboardWillShow`.
        case willHide
        
        /// Event raised by UIKit's `.UIKeyboardDidHide`.
        case didHide
        
        /// Event raised by UIKit's `.UIKeyboardWillChangeFrame`.
        case willChangeFrame
        
        /// Event raised by UIKit's `.UIKeyboardDidChangeFrame`.
        case didChangeFrame
    }
    
    /// Declares Typist behavior. Pass a closure parameter and event to mind those two. Without calling `start()` none of the closures will be executed.
    ///
    /// - parameter event: Event on which callback should be executed.
    /// - parameter do: Closure of code which will be executed on keyboard `event`.
    /// - returns: `Self` for convenience so many `on` functions can be chained.
    public func on(event: KeyboardEvent, do callback: TypistCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    /// Starts listening to events and calling corresponding events handlers.
    public func start() {
        let center = NotificationCenter.`default`
        
        for event in callbacks.keys {
            center.addObserver(self, selector: event.selector, name: event.notification, object: nil)
        }
    }
    
    /// Stops listening to keyboard events. Callback closures won't be cleared, thus calling `start()` again will resume calling previously set event handlers.
    public func stop() {
        // TODO: this needs a bit more work
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
    
    /// Clears all event handlers. Equivalent of setting `nil` for all events.
    public func clear() {
        callbacks.removeAll()
    }
    
    // MARK: - How sausages are made
    
    internal var callbacks: [KeyboardEvent : TypistCallback] = [:]
    
    internal func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable : Any]?) -> KeyboardOptions {
        var currentApp = true
        if #available(iOS 9.0, *) {
            if let value = (userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue {
                currentApp = value
            }
        }
        
        var endFrame = CGRect()
        if let value = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            endFrame = value
        }
        
        var startFrame = CGRect()
        if let value = (userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            startFrame = value
        }
        
        var animationCurve = UIViewAnimationCurve.linear
        if let index = (userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let value = UIViewAnimationCurve(rawValue:index) {
            animationCurve = value
        }
        
        var animationDuration: Double = 0.0
        if let value = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            animationDuration = value
        }
        
        return KeyboardOptions(belongsToCurrentApp: currentApp, startFrame: startFrame, endFrame: endFrame, animationCurve: animationCurve, animationDuration: animationDuration)
    }
    
    
    // MARK: - UIKit notification handling
    
    internal func keyboardWillShow(note: Notification) {
        if let callback = callbacks[.willShow] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    internal func keyboardDidShow(note: Notification) {
        if let callback = callbacks[.didShow] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    
    internal func keyboardWillHide(note: Notification) {
        if let callback = callbacks[.willHide] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    internal func keyboardDidHide(note: Notification) {
        if let callback = callbacks[.didHide] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    
    internal func keyboardWillChangeFrame(note: Notification) {
        if let callback = callbacks[.willChangeFrame] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    internal func keyboardDidChangeFrame(note: Notification) {
        if let callback = callbacks[.didChangeFrame] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
}

fileprivate extension Typist.KeyboardEvent {
    var notification: NSNotification.Name {
        get {
            switch self {
            case .willShow:
                return .UIKeyboardWillShow
            case .didShow:
                return .UIKeyboardDidShow
            case .willHide:
                return .UIKeyboardWillHide
            case .didHide:
                return .UIKeyboardDidHide
            case .willChangeFrame:
                return .UIKeyboardWillChangeFrame
            case .didChangeFrame:
                return .UIKeyboardDidChangeFrame
            }
        }
    }
    
    var selector: Selector {
        get {
            switch self {
            case .willShow:
                return #selector(Typist.keyboardWillShow(note:))
            case .didShow:
                return #selector(Typist.keyboardDidShow(note:))
            case .willHide:
                return #selector(Typist.keyboardWillHide(note:))
            case .didHide:
                return #selector(Typist.keyboardDidHide(note:))
            case .willChangeFrame:
                return #selector(Typist.keyboardWillChangeFrame(note:))
            case .didChangeFrame:
                return #selector(Typist.keyboardDidChangeFrame(note:))
            }
        }
    }
}
