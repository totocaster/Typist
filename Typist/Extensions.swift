//
//  Extensions.swift
//  Typist-Demo
//
//  Created by Lasha Efremidze on 12/2/17.
//  Copyright © 2017 Toto Tvalavadze. All rights reserved.
//

import UIKit

extension UIViewAnimationOptions {
    init(curve: UIViewAnimationCurve) {
        switch curve {
        case .easeIn:
            self = [.curveEaseIn]
        case .easeOut:
            self = [.curveEaseOut]
        case .easeInOut:
            self = [.curveEaseInOut]
        case .linear:
            self = [.curveLinear]
        }
    }
}
