//
//  CategoryCell.swift
//  appstore
//
//  Created by Ahmed.S.Elserafy on 10/16/17.
//  Copyright © 2017 Ahmed.S.Elserafy. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellID = "cellAppsID"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var appStoreController: AppStoreViewController?
    
    var appCategory: CategoryModels? {
        didSet {
            if let name = appCategory?.name {
                nameLabel.text = name
            }
            
            // to reloade all data, Particularly for header to put data into appsCollectionView to be filled by image, coz you deleted super.setupViews that deleted (appsCollectionView, diviedLine, nameLabel)
           
                self.appsCollectionView.reloadData()
        }
    }
    
    lazy var appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let dividedLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = appCategory?.apps?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = appCategory?.apps?[indexPath.item] {
            
            appStoreController?.showDetailedApps(app: app)
        }
    }
    
    func setupViews() {
        
        addSubview(appsCollectionView)
        addSubview(dividedLine)
        addSubview(nameLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": dividedLine]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[labelName(30)][v0][v1(0.5)]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["labelName": nameLabel, "v0": appsCollectionView,"v1": dividedLine]))
    }
}


class AppCell: UICollectionViewCell {
  
    var app: App? {
        didSet {
            if let name = app?.Name {
                nameLabel.text = name
                let size = CGSize(width: frame.width, height: 1000)
                let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                let rect = NSString(string: name).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                if rect.height > 20 {
                    categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
                } else {
                    categoryLabel.frame = CGRect(x: 0, y: frame.width + 20, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 35, width: frame.width, height: 20)
                }
                nameLabel.frame = CGRect(x: 0, y: frame.width + 4, width: frame.width, height: 40)
                // resize and move the view to be enclose the its subviews at the superview
                nameLabel.sizeToFit()
                
            }
            if let category = app?.Category{
                categoryLabel.text = category
            }
            if let price = app?.Price as NSNumber? {
                priceLabel.text = "$\(price)"
            } else {
                priceLabel.text = ""
            }
            if let image = app?.ImageName {
                imageView.image = UIImage(named: image)
            }
            
        }
    }
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Disney Build it: Frozen"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$3.99"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    func setupViews() {
        backgroundColor = .clear
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
        priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


