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
        public let animationCurve: UIView.AnimationCurve
        
        /// Identifies the duration of the animation in seconds.
        public let animationDuration: Double
     
        /// Maps the animationCurve to it's respective `UIView.AnimationOptions` value.
        public var animationOptions: UIView.AnimationOptions {
            switch self.animationCurve {
            case UIView.AnimationCurve.easeIn:
                return UIView.AnimationOptions.curveEaseIn
            case UIView.AnimationCurve.easeInOut:
                return UIView.AnimationOptions.curveEaseInOut
            case UIView.AnimationCurve.easeOut:
                return UIView.AnimationOptions.curveEaseOut
            case UIView.AnimationCurve.linear:
                return UIView.AnimationOptions.curveLinear
            @unknown default:
                fatalError()
            }
        }
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
    
    /// Declares Typist behavior. Pass a closure parameter and event to bind those two. Without calling `start()` none of the closures will be executed.
    ///
    /// - parameter event: Event on which callback should be executed.
    /// - parameter do: Closure of code which will be executed on keyboard `event`.
    /// - returns: `Self` for convenience so many `on` functions can be chained.
    @discardableResult
    public func on(event: KeyboardEvent, do callback: TypistCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    // TODO: add docs
    public func toolbar(scrollView: UIScrollView) -> Self {
        self.scrollView = scrollView
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
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
    
    /// Clears all event handlers. Equivalent of setting `nil` for all events.
    public func clear() {
        callbacks.removeAll()
    }
    
    deinit {
        stop()
    }
    
    // MARK: - How sausages are made
    
    internal var callbacks: [KeyboardEvent : TypistCallback] = [:]
    
    internal func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable : Any]?) -> KeyboardOptions {
        var currentApp = true
        if #available(iOS 9.0, *) {
            if let value = (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue {
                currentApp = value
            }
        }
        
        var endFrame = CGRect()
        if let value = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            endFrame = value
        }
        
        var startFrame = CGRect()
        if let value = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            startFrame = value
        }
        
        var animationCurve = UIView.AnimationCurve.linear
        if let index = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let value = UIView.AnimationCurve(rawValue:index) {
            animationCurve = value
        }
        
        var animationDuration: Double = 0.0
        if let value = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            animationDuration = value
        }
        
        return KeyboardOptions(belongsToCurrentApp: currentApp, startFrame: startFrame, endFrame: endFrame, animationCurve: animationCurve, animationDuration: animationDuration)
    }
    
    
    // MARK: - UIKit notification handling
    
    @objc internal func keyboardWillShow(note: Notification) {
        callbacks[.willShow]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
    @objc internal func keyboardDidShow(note: Notification) {
        callbacks[.didShow]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
    
    @objc internal func keyboardWillHide(note: Notification) {
        callbacks[.willHide]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
    @objc internal func keyboardDidHide(note: Notification) {
        callbacks[.didHide]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
    
    @objc internal func keyboardWillChangeFrame(note: Notification) {
        callbacks[.willChangeFrame]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
        _options = keyboardOptions(fromNotificationDictionary: note.userInfo)
    }
    @objc internal func keyboardDidChangeFrame(note: Notification) {
        callbacks[.didChangeFrame]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
        _options = keyboardOptions(fromNotificationDictionary: note.userInfo)
    }
    
    // MARK: - Input Accessory View Support
    
    fileprivate var scrollView: UIScrollView? {
        didSet {
            scrollView?.keyboardDismissMode = .interactive // allows dismissing keyboard interactively
            scrollView?.addGestureRecognizer(panGesture)
        }
    }
    
    fileprivate lazy var panGesture: UIPanGestureRecognizer = { [unowned self] in
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer))
        recognizer.delegate = self
        return recognizer
    }()
    
    fileprivate var _options: KeyboardOptions?
    
    @IBAction func handlePanGestureRecognizer(recognizer: UIPanGestureRecognizer) {
        var useWindowCoordinates = true
        var window: UIWindow?
        var bounds: CGRect = .zero
        
        // check to see if we can access the UIApplication.sharedApplication property. If not, due to being in an extension context where sharedApplication isn't
        // available, grab the screen bounds and use the screen to determine the touch's absolute location.
        let sharedApplicationSelector = NSSelectorFromString("sharedApplication")
        if let applicationClass = NSClassFromString("UIApplication"), applicationClass.responds(to: sharedApplicationSelector) {
            if let application = UIApplication.perform(sharedApplicationSelector).takeUnretainedValue() as? UIApplication, let appWindow = application.windows.first {
                window = appWindow
                bounds = appWindow.bounds
            }
        }
        else {
            useWindowCoordinates = false
            bounds = UIScreen.main.bounds
        }
    
        guard
            let options = _options,
            case .changed = recognizer.state,
            let view = recognizer.view
            else { return }
        
        let location = recognizer.location(in: view)
        
        var absoluteLocation: CGPoint
        
        if useWindowCoordinates {
            absoluteLocation = view.convert(location, to: window)
        }
        else {
            absoluteLocation = view.convert(location, to: UIScreen.main.coordinateSpace)
        }
        
        var frame = options.endFrame
        frame.origin.y = max(absoluteLocation.y, bounds.height - frame.height)
        frame.size.height = bounds.height - frame.origin.y
        let event = KeyboardOptions(belongsToCurrentApp: options.belongsToCurrentApp, startFrame: options.startFrame, endFrame: frame, animationCurve: options.animationCurve, animationDuration: options.animationDuration)
        callbacks[.willChangeFrame]?(event)
    }
}

private extension Typist.KeyboardEvent {
    var notification: NSNotification.Name {
        get {
            switch self {
            case .willShow:
                return UIResponder.keyboardWillShowNotification
            case .didShow:
                return UIResponder.keyboardDidShowNotification
            case .willHide:
                return UIResponder.keyboardWillHideNotification
            case .didHide:
                return UIResponder.keyboardDidHideNotification
            case .willChangeFrame:
                return UIResponder.keyboardWillChangeFrameNotification
            case .didChangeFrame:
                return UIResponder.keyboardDidChangeFrameNotification
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

extension Typist: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return scrollView?.keyboardDismissMode == .interactive
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === panGesture
    }
    
}


// MARK: UIView extensions (convenience)

extension UIView.AnimationOptions {
    public init(curve: UIView.AnimationCurve) {
        switch curve {
        case .easeIn:
            self = [.curveEaseIn]
        case .easeOut:
            self = [.curveEaseOut]
        case .easeInOut:
            self = [.curveEaseInOut]
        case .linear:
            self = [.curveLinear]
        @unknown default:
            self = [.curveLinear]
        }
    }
}

