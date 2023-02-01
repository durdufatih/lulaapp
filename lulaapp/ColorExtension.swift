//
//  ColorExtension.swift
//  lulaapp
//
//  Created by Mehmet Fatih Durdu on 25.01.2023.
//

import UIKit


extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(in: 0...1),
           green: .random(in: 0...1),
           blue:  .random(in: 0...1),
           alpha: 1.0
        )
    }
}
