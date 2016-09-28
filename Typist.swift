//
//  Typist.swift
//  Small Swift helper to manage UIKit keyboard on iOS devices.
//
//  Created by Toto Tvalavadze on 2016/09/26. MIT Licence.
//

import UIKit

public class Typist: NSObject {
    
    static public let shared = Typist()
    
    public struct KeyboardOptions {
        /// `Bool` that identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value of this key is `true` for the app that caused the keyboard to appear and `false` for any other apps.
        let belongsToCurrentApp: Bool
        
        /// `CGRect` that identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
        let startFrame: CGRect
        
        /// `CGRect` that identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
        let endFrame: CGRect
        
        /// `UIViewAnimationCurve` constant that defines how the keyboard will be animated onto or off the screen.
        let animationCurve: UIViewAnimationCurve
        
        /// `CGFloat` containing a double that identifies the duration of the animation in seconds.
        let animationDuration: CGFloat
    }
    
    
    public typealias TypistCallback = (KeyboardOptions) -> ()
    
    public enum KeyboardEvent {
        case willShow
        case didShow
        case willHide
        case didHide
        case willChangeFrame
        case didChangeFrame
    }
    
    public func on(event: KeyboardEvent, do callback: TypistCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    public func start() {
        // TODO: start only notification that are needed (based on what handler are assigned)
        let center = NotificationCenter.`default`
        center.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
    
        center.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: .UIKeyboardDidChangeFrame, object: nil)
        
    }
    
    public func stop() {
        // TODO: this needs a bit more work
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
    
    public func clear() {
        callbacks.removeAll()
    }
    
    // MARK: - How sausages are made
    
    internal var callbacks: [KeyboardEvent : TypistCallback] = [:]
    
    internal func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable : Any]?) -> KeyboardOptions {
        var currentApp = false
        if let value = (userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue {
            currentApp = value
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
        
        var animationDuration: CGFloat = 0.0
        if let value = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue {
            animationDuration = CGFloat(value)
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
