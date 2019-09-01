//
//  ViewController.swift
//  ReorderingItemsUICollectionView
//
//  Created by lai001 on 2019/9/1.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var dataSource: [[String]] = {
        return (0...1).map({ i in (0...5).map({ "\(i) - \($0)" }) })
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = CGSize(width: 0, height: 50)
        return layout
    }()
    
    lazy var collectview: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: "forCellWithReuseIdentifier")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "withReuseIdentifier")
        return collectionView
    }()
    
    lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handLongPressGestureRecognizer))
        return longPressGestureRecognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectview)
        
        collectview.translatesAutoresizingMaskIntoConstraints = false
        
        collectview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectview.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func handLongPressGestureRecognizer(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            if let indexPath = collectview.indexPathForItem(at: sender.location(in: collectview)) {
                collectview.beginInteractiveMovementForItem(at: indexPath)
            }
            
        case .changed:
            collectview.updateInteractiveMovementTargetPosition(sender.location(in: collectview))
            
            
        case .ended:
            collectview.endInteractiveMovement()
            
        default:
            collectview.cancelInteractiveMovement()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forCellWithReuseIdentifier", for: indexPath) as! LabelCollectionViewCell
        cell.label.text = dataSource[indexPath.section][indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "withReuseIdentifier", for: indexPath) as! SectionHeader
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case indexPath.section = 0 {
            dataSource[1].insert(dataSource[0].remove(at: indexPath.item), at: 0)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
                collectionView.insertItems(at: [IndexPath(item: 0, section: 1)])
            })
        }
        
        if case indexPath.section = 1 {
            dataSource[0].append(dataSource[indexPath.section].remove(at: indexPath.item))
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
                collectionView.insertItems(at: [IndexPath(item: dataSource[0].count - 1, section: 0)])
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataSource[destinationIndexPath.section].insert(dataSource[sourceIndexPath.section].remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
    }
    
}


class LabelCollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class SectionHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
