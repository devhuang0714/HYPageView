//
//  HYTitleView.swift
//  HYPageView
//
//  Created by 莫名 on 2017/3/24.
//  Copyright © 2017年 黄易. All rights reserved.
//

import UIKit

protocol HYTitleViewDelegate: class {
    func titleView(_ titleView: HYTitleView, didSelectedItemAt index: Int)
}

class HYTitleView: UIView {
    
    weak var delegate: HYTitleViewDelegate?

    fileprivate var titles: [String]
    fileprivate var titleStyle: HYTitleStyle
    
    fileprivate lazy var scrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = self.titleStyle.scrollLineColor
        return scrollLine
    }()
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var currentIndex: Int = 0
    
    init(frame: CGRect, titles: [String], titleStyle: HYTitleStyle) {
        self.titles = titles
        self.titleStyle = titleStyle
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HYTitleView {
    
    fileprivate func setupUI() {
        setupScrollView()
        setupTitleLabels()
        setupTitleLabelsFrame()
        setupScrollLine()
    }
    
    private func setupScrollView() {
        scrollView.frame = bounds
        addSubview(scrollView)
    }
    
    private func setupTitleLabels() {
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.tag = index
            label.text = title
            label.font = titleStyle.normalFont
            label.textColor = index == currentIndex ? titleStyle.selectedColor : titleStyle.normalColor
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGesture)
        }
    }
    
    private func setupTitleLabelsFrame() {
        
        var x: CGFloat = 0.0
        var width: CGFloat = bounds.width / CGFloat(titleLabels.count)
        
        var preLabel: UILabel!
        for (index, label) in titleLabels.enumerated() {
            
            if titleStyle.isScrollEnable { // 可以滚动
                width = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleStyle.selectedFont], context: nil).size.width
                if index == 0 {
                    x = titleStyle.margin * 0.5
                } else {
                    x = preLabel.frame.maxX + titleStyle.margin
                }
            } else {
                x = CGFloat(index) * width
            }
            
            label.frame = CGRect(x: x, y: 0, width: width, height: bounds.height)
            preLabel = label
        }
        
        if titleStyle.isScrollEnable {
            guard let lastLabel = titleLabels.last else {
                return
            }
            scrollView.contentSize = CGSize(width: lastLabel.frame.maxX + titleStyle.margin * 0.5, height: 0)
        } else {
            scrollView.contentSize = CGSize.zero
        }
    }
    
    private func setupScrollLine() {
        scrollLine.isHidden = !titleStyle.hasScrollLine
        
        let selectedLabel = titleLabels[currentIndex]
        scrollLine.frame = CGRect(x: selectedLabel.frame.minX, y: bounds.height - titleStyle.scrollLineHeight, width: selectedLabel.frame.width, height: titleStyle.scrollLineHeight)
        scrollView.addSubview(scrollLine)
    }
}

extension HYTitleView {
    
    @objc fileprivate func titleLabelClick(_ tapGesture: UITapGestureRecognizer) {
        
        guard let newLabel = tapGesture.view as? UILabel else { return }
        
        let oldLabel = titleLabels[currentIndex]
        changeSelect(oldLabel, newLabel)
        
        delegate?.titleView(self, didSelectedItemAt: newLabel.tag)
    }
    
    fileprivate func changeSelect(_ oldLabel: UILabel, _ newLabel: UILabel) {

        oldLabel.textColor = titleStyle.normalColor
        newLabel.textColor = titleStyle.selectedColor
        currentIndex = newLabel.tag
        
        if titleStyle.isScrollEnable {
            var offsetX: CGFloat = newLabel.center.x - bounds.width * 0.5
            if offsetX < 0 {
                offsetX = 0
            }
            if offsetX > scrollView.contentSize.width - bounds.width {
                offsetX = scrollView.contentSize.width - bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
            UIView.animate(withDuration: 0.25) {
                self.scrollLine.frame.origin.x = newLabel.frame.origin.x
                self.scrollLine.frame.size.width = newLabel.frame.size.width
            }
        } else {
            self.scrollLine.frame.origin.x = newLabel.frame.origin.x
            self.scrollLine.frame.size.width = newLabel.frame.size.width
        }
    }
}

// MARK: - HYContentViewDelegate
extension HYTitleView: HYContentViewDelegate {
    
    func contentView(_ contentView: HYContentView, didEndScroll index: Int) {
        if currentIndex == index { return }
        
        let oldLabel = titleLabels[currentIndex]
        let newLabel = titleLabels[index]
        changeSelect(oldLabel, newLabel)
    }
    
    func contentView(_ contentView: HYContentView, originIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        let originLabel = titleLabels[originIndex]
        let targetLabel = titleLabels[targetIndex]

        if titleStyle.hasGradient { // 标题文字渐变
            targetLabel.textColor = mixtureColor(titleStyle.normalColor, titleStyle.selectedColor, progress)
            originLabel.textColor = mixtureColor(titleStyle.selectedColor, titleStyle.normalColor, progress)
            
            let fontDelta: CGFloat = titleStyle.selectedFont.pointSize - titleStyle.normalFont.pointSize
            targetLabel.font = UIFont.systemFont(ofSize: titleStyle.normalFont.pointSize + (fontDelta * progress))
            originLabel.font = UIFont.systemFont(ofSize: titleStyle.selectedFont.pointSize - (fontDelta * progress))
        }
        
        if titleStyle.lineScrollType == .RealTime { // 滚动条实时滚动
            let xDelta: CGFloat = targetLabel.frame.minX - originLabel.frame.minX
            let wDelta: CGFloat = targetLabel.frame.width - originLabel.frame.width
            
            scrollLine.frame.origin.x = originLabel.frame.origin.x + xDelta * progress
            scrollLine.frame.size.width = originLabel.frame.size.width + wDelta * progress
        }
    }
}

extension HYTitleView {
    /// 混合颜色
    ///
    /// - Parameters:
    ///   - color1: RGB颜色1
    ///   - color2: RGB颜色2
    ///   - ratio: 比例值
    /// - Returns: 混合后的颜色
    fileprivate func mixtureColor(_ color1: UIColor, _ color2: UIColor, _ ratio: CGFloat) -> UIColor {
        
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


