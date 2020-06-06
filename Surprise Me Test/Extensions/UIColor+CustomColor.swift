//
//  UIColor+CustomColor.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Structure that stores custom colors.
    struct CustomColor {
        static var customBlue: UIColor {
            return UIColor(red: (39.0 / 255.0),
                           green: (204 / 255.0),
                           blue: (217 / 255.0),
                           alpha: 1.0)
        }
    }
}
