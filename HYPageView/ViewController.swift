//
//  ViewController.swift
//  HYPageView
//
//  Created by 莫名 on 2017/3/24.
//  Copyright © 2017年 黄易. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "HYPageView"
        
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .cyan
        setupUI()
    }
}

extension ViewController {
    
    fileprivate func setupUI() {
        
//        let titles = ["头条", "军事", "段子", "哈哈"]
        let titles = ["推荐", "头条", "军事", "段子", "轻松一刻", "哈哈哈", "段子", "轻松一刻", "哈哈"]
        
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
        }
        
        let titleStyle = HYTitleStyle()
//        titleStyle.isScrollEnable = false
        // 样式一
        titleStyle.hasScrollLine = true
        
        // 样式二
//        titleStyle.hasScrollLine = true
//        titleStyle.lineScrollType = .RealTime
        
        // 样式三
//        titleStyle.hasGradient = true
////        titleStyle.selectedColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1.0)
        
        // 样式四
//        titleStyle.hasGradient = true
//        titleStyle.selectedFont = UIFont.systemFont(ofSize: 16)
        
        let pageView = HYPageView.init(frame: view.bounds, titles: titles, childVCs: childVCs, parentVC: self, titleStyle: titleStyle)
        view.addSubview(pageView)
    }
}





