//
//  ViewController.swift
//  appstore
//
//  Created by Ahmed.S.Elserafy on 10/16/17.
//  Copyright © 2017 Ahmed.S.Elserafy. All rights reserved.
//

import UIKit

class AppStoreViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellID = "celId"
    private let largeCellID = "largeCellID"
    private let headerID = "headerID"
    
    var featuredApps: FeaturedApps?
    var appCategories: [CategoryModels]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CategoryModels.fetchMyAppCategory { (featuredApps) in
            self.featuredApps = featuredApps
            // to ensure to get back the json data, and update it
            self.appCategories = featuredApps.appCategories
            self.collectionView?.reloadData()
        }
//        appCategories = CategoryModels.sampleAppCategory()

        navigationItem.title = "Featured"
        
        collectionView?.backgroundColor = .white
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellID)
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
   
    // to build it as Struct 
    /*
    let app: [CollectionApp] = {
        let apps = Apps(name: "Frozen App", category: "Entertainment", price: 3.99, image: #imageLiteral(resourceName: "frozen"))
        let collecApp = CollectionApp(name: "Best New Apps", apps: [apps])
        
        let gameApp = Apps(name: "Telepaint", category: "Games", price: 2.99, image: #imageLiteral(resourceName: "telepaint"))
        let angryGameApp = Apps(name: "Angry Birds", category: "Games", price: NSNumber(), image: #imageLiteral(resourceName: "angrybirdsspace"))
        
        let collecGame = CollectionApp(name: "Best New Games", apps: [gameApp, angryGameApp])
        return [collecApp, collecGame]
    }()
    */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        //return app.count
        
        if let count = appCategories?.count {
            return count
        } else {
            return 0
        }
      //  return 0
//          return (appCategories?.count)!
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellID, for: indexPath) as! LargeCategoryCell
            cell.appCategory = appCategories?[indexPath.item]
            cell.appStoreController = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CategoryCell
     //   cell.appCategory = app[indexPath.item]
      cell.appCategory = featuredApps?.appCategories?[indexPath.item]
        cell.appStoreController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 {
            return CGSize(width: view.frame.width, height: 150)
        }
        return CGSize(width: view.frame.width, height: 220)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! Header
        header.appCategory = featuredApps?.bannerCategory
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    // to get access the detailed app by clicking app(imageView, name, category, price)
    func showDetailedApps(app: App) {
        let layout = UICollectionViewFlowLayout()
        let appDetailController = AppDetailController(collectionViewLayout: layout)
        // access the data(app) that we 're clicking on, and the data is going to be passed into appDetailController upon the push
        appDetailController.app = app
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

class Header: CategoryCell {
    var leftAnchorImageView: NSLayoutConstraint?
    
    override func setupViews() {
        // comment super.setupViews(): to remove nameLabel, dividedLine
//        super.setupViews()
        appsCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: bannerCellId)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        appsCollectionView.isPagingEnabled = true
        addSubview(appsCollectionView)
        /*
        appsCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        appsCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        appsCollectionView.widthAnchor.constraint(equalToConstant: 375).isActive = true
        appsCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 4).isActive = true
        appsCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        UIView.animate(withDuration: 2.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.appsCollectionView.leftAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        }, completion: nil)*/
        
        leftAnchorImageView = appsCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor)
            leftAnchorImageView?.isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":appsCollectionView]))
    }
    
    let bannerCellId = "bannerCellID"
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellId, for: indexPath) as! BannerCell
        cell.app = appCategory?.appss?[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    class BannerCell: AppCell {
       // var rightAnchorSide: NSLayoutConstraint?
        override func setupViews() {
            
            imageView.layer.cornerRadius = 0
            imageView.contentMode = .scaleToFill
        
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
           
           addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
 
        }
    }

}

class LargeCategoryCell: CategoryCell {
    
    let largeAppCell = "largeAppCell"
    
    override func setupViews() {
        // super.setupViews(): very important to say that (appsCollectionView) labelName, image, and divided line are existed
        // to call all previous data
        super.setupViews()
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeAppCell)
    }
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCell, for: indexPath) as! LargeAppCell
        cell.app = appCategory?.appss?[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 32)
    }
    
    class LargeAppCell: AppCell {
        override func setupViews() {
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            // to expand imageView, and appsCollectionView contains only imageView
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v0]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
        }
    }
}





/*
class LargeCategoryCell: CategoryCell {
 
    let largeAppCell = "largeAppCell"
 
    override func setupViews() {
        super.setupViews()
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeAppCell)
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 32)
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCell, for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    class LargeAppCell: AppCell {
        
        override func setupViews() {
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v0]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        }
    }
}
*/


















