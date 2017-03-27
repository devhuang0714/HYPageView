//
//  UIColor-Extension.swift
//  HYPageView
//
//  Created by 莫名 on 2017/3/24.
//  Copyright © 2017年 黄易. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        return UIColor.init(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    /// 混合颜色
    ///
    /// - Parameters:
    ///   - color1: RGB颜色1
    ///   - color2: RGB颜色2
    ///   - ratio: 比例值
    /// - Returns: 混合后的颜色
    class func mixtureColor(_ color1: UIColor, _ color2: UIColor, _ ratio: CGFloat) -> UIColor {
        
        guard let comps1 = color1.cgColor.components else {
            fatalError("请使用RGB颜色")
        }
        guard let comps2 = color2.cgColor.components else {
            fatalError("请使用RGB颜色")
        }
        if comps1.count < 3 {
            fatalError("color1请使用RGB颜色")
        }
        if comps2.count < 3 {
            fatalError("color2请使用RGB颜色")
        }
        
        let r: CGFloat = comps2[0] * ratio + comps1[0] * (1 - ratio)
        let g: CGFloat = comps2[1] * ratio + comps1[1] * (1 - ratio)
        let b: CGFloat = comps2[2] * ratio + comps1[2] * (1 - ratio)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
