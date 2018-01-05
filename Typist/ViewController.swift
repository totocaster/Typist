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
        keyboard.toolbar(scrollView: tableView).on(event: .willChangeFrame) { [unowned self] options in
            let height = options.endFrame.height
            self.bottom.constant = max(0, height - self.toolbar.bounds.height)
            UIView.animate(withDuration: 0) {
                self.tableView.contentInset.bottom = max(self.toolbar.bounds.height, height)
                self.tableView.scrollIndicatorInsets.bottom = max(self.toolbar.bounds.height, height)
                self.view.layoutIfNeeded()
            }
        }.start()
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
