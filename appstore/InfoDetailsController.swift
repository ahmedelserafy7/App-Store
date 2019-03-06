//
//  InfoDetailsController.swift
//  appstore
//
//  Created by Ahmed.S.Elserafy on 11/1/17.
//  Copyright © 2017 Ahmed.S.Elserafy. All rights reserved.
//

import UIKit

class InfoDetailsController: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let cellID = "cellID"
    var app: App? {
        didSet {
            
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = app?.screenshots?.count {
            return count
        }
        return 0
        // return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! InfoDetailsCell
        if let image = app?.screenshots?[indexPath.item] {
            cell.imageView.image = UIImage(named: image)
        }
        // can't use this, coz if nil will crash
        // cell.imageView.image = UIImage(named: (app?.screenshots?[indexPath.item])!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 80, height: frame.height - 66)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "iPhone"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let dividedLine: UIView = {
        let dividedLine = UIView()
        dividedLine.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return dividedLine
    }()
    
    override func setupViews() {
        super.setupViews()
        collectionView.dataSource = self
        collectionView.delegate = self
        //     backgroundColor = .red
        collectionView.register(InfoDetailsCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(nameLabel)
        addSubview(collectionView)
        addSubview(dividedLine)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividedLine)
        addConstraintsWithFormat(format: "V:|-14-[v0(16)][v1][v2(1)]|", views: nameLabel, collectionView, dividedLine)
    }
    
    class InfoDetailsCell : BaseCell {
        
        let imageView : UIImageView = {
            let iv = UIImageView()
            //     iv.contentMode = .scaleAspectFill
            //            iv.layer.masksToBounds = true
            iv.contentMode = .scaleToFill
            iv.backgroundColor = .green
            return iv
        }()
        
        override func setupViews() {
            super.setupViews()
            addSubview(imageView)
            
            //      layer.masksToBounds = true
            addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
            addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
            backgroundColor = .yellow
            
        }
    }
}
