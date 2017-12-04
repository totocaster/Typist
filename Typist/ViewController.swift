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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableHeaderView = UIView()
            tableView.tableFooterView = UIView()
            tableView.keyboardDismissMode = .interactive // allow dismissing keyboard interactively
        }
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: add keyboard toolbar handler
        
        keyboard.on(event: .willChangeFrame) { [unowned self] options in
            print("will")
            print(options.startFrame)
            print(options.endFrame)
//            self.bottom.constant = UIScreen.main.bounds.height - options.endFrame.origin.y
//            UIView.animate(withDuration: options.animationDuration, delay: 0, options: UIViewAnimationOptions(curve: options.animationCurve), animations: {
//                self.view.layoutIfNeeded()
//            }, completion: nil)
        }.on(event: .didChangeFrame) { [unowned self] options in
            print("did")
            print(options.startFrame)
            print(options.endFrame)
//            self.bottom.constant = UIScreen.main.bounds.height - options.endFrame.origin.y
//            UIView.animate(withDuration: options.animationDuration, delay: 0, options: UIViewAnimationOptions(curve: options.animationCurve), animations: {
//                self.view.layoutIfNeeded()
//            }, completion: nil)
            }.on(event: .willHide) { [unowned self] options in
                print("will")
                print(options.startFrame)
                print(options.endFrame)
        }.start()
        
        textField.inputAccessoryView = UIView(frame: toolbar.bounds)
        
//        keyboard.on(event: .didShow) { [unowned self] options in
//            self.bottom.constant = options.endFrame.height
//        }.on(event: .didHide) { [unowned self] options in
//            self.bottom.constant = 0
//        }.start()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}
