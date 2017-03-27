//
//  HYContentView.swift
//  HYPageView
//
//  Created by 莫名 on 2017/3/24.
//  Copyright © 2017年 黄易. All rights reserved.
//

import UIKit

private let kHYContentViewCellID = "HYContentViewCellID"

protocol HYContentViewDelegate: class {
    func contentView(_ contentView: HYContentView, didEndScroll index: Int)
    func contentView(_ contentView: HYContentView, originIndex: Int, targetIndex: Int, progress: CGFloat)
}

class HYContentView: UIView {
    
    weak var delegate: HYContentViewDelegate?
    fileprivate var childVCs: [UIViewController]
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kHYContentViewCellID)
        return collectionView
    }()
    fileprivate lazy var currentOffsetX: CGFloat = 0.0
    
    init(frame: CGRect, childVCs: [UIViewController]) {
        self.childVCs = childVCs
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HYContentView {
    
    fileprivate func setupUI() {
        
        collectionView.frame = bounds
        addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource &
extension HYContentView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHYContentViewCellID, for: indexPath)
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentViewDidEndScroll()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        currentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentIndex: Int = Int(currentOffsetX / bounds.width)
        var targetIndex: Int = currentIndex
        var progress: CGFloat = 0.0
        
        var delta: CGFloat = 0
        if scrollView.contentOffset.x - currentOffsetX < 0 { // 向右滑动 索引减小
            targetIndex = currentIndex - 1
            delta = currentOffsetX - scrollView.contentOffset.x
        } else { // 向左滑动 索引增大
            targetIndex = currentIndex + 1
            delta = scrollView.contentOffset.x - currentOffsetX
        }
        progress = delta / bounds.width
        if progress > 1.0 {
            return
        }
        delegate?.contentView(self, originIndex: currentIndex, targetIndex: targetIndex, progress: progress)
    }
    
    private func contentViewDidEndScroll() {
        
        let currentIndex = Int(collectionView.contentOffset.x / bounds.width)
        delegate?.contentView(self, didEndScroll: currentIndex)
    }
}

// MARK: - HYTitleViewDelegate
extension HYContentView: HYTitleViewDelegate {
    
    func titleView(_ titleView: HYTitleView, didSelectedItemAt index: Int) {
        
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
