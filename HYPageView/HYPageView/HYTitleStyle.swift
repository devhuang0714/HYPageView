//
//  HYTitleStyle.swift
//  HYPageView
//
//  Created by 莫名 on 2017/3/24.
//  Copyright © 2017年 黄易. All rights reserved.
//

import UIKit

enum LineScrollType {
    /// 标题文字改变完成时滚动
    case DidEndChange
    /// 实时滚动
    case RealTime
}

class HYTitleStyle: NSObject {

    /// 标题视图高度
    var titleViewHeight: CGFloat = 40
    /// 标题间距
    var margin: CGFloat = 16
    /// 标题字体大小
    var normalFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.selectedFont = normalFont
        }
    }
    /// 选中字体大小 注：如果需要文字大小渐变效果，需要设置hasGradient = true这个属性才会生效
    var selectedFont: UIFont = UIFont.systemFont(ofSize: 14)
    /// 未选中字体颜色
    var normalColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    /// 选中字体颜色 .orange
    var selectedColor: UIColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1.0)
    /// 标题视图是否可以滚动  当不能滚动时，则标题是等宽的
    var isScrollEnable: Bool = true
    /// 是否有随选中标题滚动的下划线
    var hasScrollLine: Bool = false
    /// 滚动条滚动类型
    var lineScrollType: LineScrollType = .DidEndChange
    /// 下划线高度
    var scrollLineHeight: CGFloat = 2
    /// 下划线颜色 .orange
    var scrollLineColor: UIColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1.0)
    /// 标题文字是否有渐变的效果
    var hasGradient: Bool = false
}
