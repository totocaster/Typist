//
//  ViewController.swift
//  Typist
//
//  Created by Toto Tvalavadze on 2016/09/26.
//  Copyright © 2016 Toto Tvalavadze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    
    let keyboard = Typist.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        keyboard
            .on(event: .didShow) { [unowned self] (options) in
                self.textLabel.text = "New Keyboard Frame is \(options.endFrame)."
            }
            .on(event: .didHide) { [unowned self] (options) in
                self.textLabel.text = "It took \(options.animationDuration) seconds to animate keyboard out."
            }
            .start()
        
    }

    @IBAction func hideKeyboard(_ sender: UIButton) {
        textField.resignFirstResponder()
    }
    
    
    
    
}

