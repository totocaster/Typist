//
//  ViewController.swift
//  Typist
//
//  Created by Toto Tvalavadze on 2016/09/26.
//  Copyright © 2016 Toto Tvalavadze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let keyboard = Typist.shared
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: add keyboard toolbar handler
        
        keyboard.on(event: .willChangeFrame) { [unowned self] options in
            self.bottom.constant = UIScreen.main.bounds.height - options.endFrame.origin.y
            UIView.animate(withDuration: options.animationDuration, delay: 0, options: UIViewAnimationOptions(curve: options.animationCurve), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }.start()
        
//        keyboard.on(event: .didShow) { [unowned self] options in
//            self.bottom.constant = options.endFrame.height
//        }.on(event: .didHide) { [unowned self] options in
//            self.bottom.constant = 0
//        }.start()
    }
    
}
