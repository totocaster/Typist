//
//  Typist.swift
//  TCKeyboard
//
//  Created by Toto Tvalavadze on 2016/09/26.
//  Copyright © 2016 Toto Tvalavadze. All rights reserved.
//

import UIKit

class Typist: NSObject {
    
    static let shared = Typist()
    
    struct KeyboardOptions {
        /// UIKeyboardIsLocalUserInfoKey: The key for an NSNumber object containing a Boolean that identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value of this key is YES for the app that caused the keyboard to appear and NO for any other apps.
        let belongsToCurrentApp: Bool
        
        /// UIKeyboardFrameBeginUserInfoKey: The key for an NSValue object containing a CGRect that identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the convertRect:fromWindow: method) or to view coordinates (using the convertRect:fromView: method) before using it.
        let startFrame: CGRect
        
        /// UIKeyboardFrameEndUserInfoKey: The key for an NSValue object containing a CGRect that identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the convertRect:fromWindow: method) or to view coordinates (using the convertRect:fromView: method) before using it.
        let endFrame: CGRect
        
        /// UIKeyboardAnimationCurveUserInfoKey: The key for an NSNumber object containing a UIViewAnimationCurve constant that defines how the keyboard will be animated onto or off the screen.
        let animationCurve: UIViewAnimationCurve
        
        /// UIKeyboardAnimationDurationUserInfoKey: The key for an NSNumber object containing a double that identifies the duration of the animation in seconds.
        let animationDuration: CGFloat
    }
    
    
    typealias TypistCallback = (KeyboardOptions) -> ()
    
    enum KeyboardEvent {
        case willShow
        case didShow
        case willHide
        case didHide
        case willChangeFrame
        case didChangeFrame
    }
    
    var callbacks: [KeyboardEvent : TypistCallback] = [:]
    
    func on(event: KeyboardEvent, do callback: TypistCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    
    func start() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
    
        center.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: .UIKeyboardDidChangeFrame, object: nil)
        
    }
    
    func stop() {
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
    
    fileprivate func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable : Any]?) -> KeyboardOptions {
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
    
}

extension Typist {
    func keyboardWillShow(note: NSNotification) {
        if let callback = callbacks[.willShow] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    func keyboardDidShow(note: NSNotification) {
        if let callback = callbacks[.didShow] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        if let callback = callbacks[.willHide] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    func keyboardDidHide(note: NSNotification) {
        if let callback = callbacks[.didHide] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    
    func keyboardWillChangeFrame(note: NSNotification) {
        if let callback = callbacks[.willChangeFrame] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
    func keyboardDidChangeFrame(note: NSNotification) {
        if let callback = callbacks[.didChangeFrame] {
            callback(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }
    }
}
