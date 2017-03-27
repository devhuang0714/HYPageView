//
//  HYPageView.swift
//  HYPageView
//
//  Created by 莫名 on 2017/3/24.
//  Copyright © 2017年 黄易. All rights reserved.
//

import UIKit

class HYPageView: UIView {

    fileprivate var titles: [String]
    fileprivate var childVCs: [UIViewController]
    fileprivate var parentVC: UIViewController
    fileprivate var titleStyle: HYTitleStyle
    
    fileprivate var titleView: HYTitleView!
    fileprivate var contentView: HYContentView!
    
    init(frame: CGRect, titles: [String], childVCs: [UIViewController], parentVC: UIViewController, titleStyle: HYTitleStyle) {
        self.titles = titles
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.titleStyle = titleStyle
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HYPageView {
    
    fileprivate func setupUI() {
        setupChildVCs()
        setupTitleView()
        setupContentView()
        setupLink()
    }
    
    private func setupChildVCs() {
        
        for vc in childVCs {
            parentVC.addChildViewController(vc)
        }
    }
    
    private func setupTitleView() {
        
        titleView = HYTitleView.init(frame: CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleViewHeight), titles: self.titles, titleStyle: titleStyle)
        titleView.backgroundColor = .white
        addSubview(titleView)
    }
    
    private func setupContentView() {
        
        contentView = HYContentView.init(frame: CGRect(x: 0, y: titleView.frame.height, width: bounds.width, height: bounds.height - titleView.frame.height), childVCs: childVCs)
        addSubview(contentView)
    }
    
    private func setupLink() {
        
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}





