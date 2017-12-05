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
            self.bottom.constant = UIScreen.main.bounds.height - options.endFrame.origin.y
            UIView.animate(withDuration: options.animationDuration, delay: 0, options: UIViewAnimationOptions(curve: options.animationCurve), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }.on(event: .didChangeFrame) { [unowned self] options in
            
        }.start()
        
        keyboard.frameChanged = { [unowned self] frame in
            self.bottom.constant = UIScreen.main.bounds.height - frame.origin.y
            UIView.animate(withDuration: 0) {
                self.view.layoutIfNeeded()
            }
        }
        
//        textField.inputAccessoryView = UIView(frame: toolbar.bounds)
        keyboard.scrollView = tableView
        
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

//extension ViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let location = scrollView.panGestureRecognizer.location(in: scrollView)
//        let absoluteLocation = scrollView.convert(location, to: self.view)
//        if scrollView.panGestureRecognizer.state == .changed {
//            print(UIScreen.main.bounds.height - absoluteLocation.y)
//        }
//    }
//
//}

