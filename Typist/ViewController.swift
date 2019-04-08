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
        }
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard input accessory view support
        textField.inputAccessoryView = UIView(frame: toolbar.bounds)
        
        // keyboard frame observer
        keyboard
            .toolbar(scrollView: tableView)
            .on(event: .willChangeFrame) { [unowned self] options in
                let height = options.endFrame.height
                UIView.animate(withDuration: 0) {
                    self.bottom.constant = max(0, height - self.toolbar.bounds.height)
                    self.tableView.contentInset.bottom = max(self.toolbar.bounds.height, height)
                    self.tableView.scrollIndicatorInsets.bottom = max(self.toolbar.bounds.height, height)
                    self.toolbar.layoutIfNeeded()
                }
                self.navigationItem.prompt = options.endFrame.debugDescription
            }
            .on(event: .willHide) { [unowned self] options in
                // .willHide is used in cases when keyboard is *not* dismiss interactively.
                // e.g. when `.resignFirstResponder()` is called on textField.
                UIView.animate(withDuration: options.animationDuration, delay: 0, options: UIView.AnimationOptions(curve: options.animationCurve), animations: {
                    self.bottom.constant = 0
                    self.tableView.contentInset.bottom = self.toolbar.bounds.height
                    self.tableView.scrollIndicatorInsets.bottom = self.toolbar.bounds.height
                    self.toolbar.layoutIfNeeded()
                }, completion: nil)
            }
            .start()
    
        self.navigationItem.prompt = "Keybaord frame will appear here."
        self.title = "Typist Demo"
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.textField.resignFirstResponder()
    }
    
}
