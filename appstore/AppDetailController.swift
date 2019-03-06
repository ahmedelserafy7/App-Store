//
//  AppDetailController.swift
//  appstore
//
//  Created by Ahmed.S.Elserafy on 10/30/17.
//  Copyright © 2017 Ahmed.S.Elserafy. All rights reserved.
//

import UIKit

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let headerID = "headerID"
    private let cellId = "cellID"
    var app: App? {
        didSet {
            
            // to avoid repetition(same infinte loop) when you click step into, and return value if it has
            
            if app?.screenshots != nil {
                return
            }
            if let id = app?.id {
                let urlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
                URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        
                        let appDetail = App()
                        appDetail.setValuesForKeys(json as! [String: AnyObject])
                        // using new properties with appDetail, to set the app to be the appDetail for more properties at urlString
                        self.app = appDetail
                        // till hasn't to pass into main every time to reloaad data
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                        
                    } catch let err {
                        print(err)
                    }
                }).resume()
            }
            
        }
        
    }
    
    var appInfos: [AppInformation]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(HeaderDetailCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(InfoDetailsController.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(DescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
        collectionView?.register(InformationCell.self, forCellWithReuseIdentifier: infoId)
        
        appInfos = app?.appsInformation
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! HeaderDetailCell
        // to set imageView by property app at header and equal app that know everything about app, just select the imageView from Class that has all data
        header.app = app
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! DescriptionCell
            cell.textView.attributedText = descriptionAttributedTextFragment()
            return cell
        } else if indexPath.item == 2  {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoId, for: indexPath) as! InformationCell
            cell.app_Info = app
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoDetailsController
        // set app in appDetailController to use the properties which is parsing json with values, it's important to call app setter inside appDetailController to manage to see the app, to reload the entire image at collection view
        cell.app = app
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    private func descriptionAttributedTextFragment()-> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Description\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let desc = app?.desc {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12) ,NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        return attributedText
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            let size = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            
            let estimatedHeight = descriptionAttributedTextFragment().boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
            return CGSize(width: view.frame.width, height: estimatedHeight.height + 32)
        }
        if indexPath.item == 2 {
            /*
             if let itemSize = appInfos?[indexPath.item].value {
             let size = CGSize(width: view.frame.width, height: 1000)
             let estimatedSize = NSString(string: itemSize).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
             //   let completedSize: CGFloat = 12 + 20 + 4 + 168
             return CGSize(width: view.frame.width, height: estimatedSize.height)
             //return CGSize(width: view.frame.width, height: 178)
             }*/
            return CGSize(width: view.frame.width, height: 178)
        }
        return CGSize(width: view.frame.width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
}

private let descriptionCellId = "descriptionCellId"
class DescriptionCell: BaseCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample Description"
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isEditable = false
        tv.isUserInteractionEnabled = false
        //        tv.backgroundColor = .red
        return tv
    }()
    let dividedLine: UIView = {
        let dividedLine = UIView()
        dividedLine.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return dividedLine
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textView)
        addSubview(dividedLine)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividedLine)
        addConstraintsWithFormat(format: "V:|-8-[v0][v1(0.5)]|", views: textView, dividedLine)
    }
}

class HeaderDetailCell: BaseCell {
    var app: App? {
        didSet {
            if let image = app?.imageName {
                imageView.image = UIImage(named: image)
            }
            if let name = app?.name {
                textView.text = name
            }
            
            if let price = app?.price {
                getButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    /* let nameLabel: UILabel = {
     let label = UILabel()
     label.text = "test test"
     label.font = UIFont.systemFont(ofSize: 16)
     return label
     }()*/
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("EGP54.99", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    let segmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = UIColor.darkGray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    let dividedLine: UIView = {
        let dividedLine = UIView()
        dividedLine.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return dividedLine
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addSubview(textView)
        addSubview(getButton)
        addSubview(segmentedControl)
        addSubview(dividedLine)
        addConstraintsWithFormat(format: "H:|-14-[v0(100)]-8-[v1]-8-|", views: imageView, textView)
        addConstraintsWithFormat(format: "V:|-14-[v0(66)]", views: textView)
        
        addConstraintsWithFormat(format: "V:|-14-[v0(100)]", views: imageView)
        
        addConstraintsWithFormat(format: "H:[v0(80)]-14-|", views: getButton)
        addConstraintsWithFormat(format: "V:[v0(30)]-54-|", views: getButton)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]-14-|", views: segmentedControl)
        addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: segmentedControl)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividedLine)
        addConstraintsWithFormat(format: "V:[v0(0.5)]|", views: dividedLine)
        
    }
}
private let infoId = "Info_ID"
private let info_cell = "info_cell"
class InformationCell: BaseCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var app_Info: App? {
        didSet{
            collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = app_Info?.appsInformation?.count {
            return count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: info_cell, for: indexPath) as! InfoDataCell
        cell.appInfo = app_Info?.appsInformation?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return 0
     }*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = app_Info?.appsInformation?[indexPath.item].value else {
            return .zero
        }
        let size = CGSize(width: frame.width - 94 - 14, height: 1000)
        let estimatedSize = NSString(string: item).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
        return CGSize(width: frame.width, height: estimatedSize.height)
    }
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Information"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    let dividedLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override func setupViews() {
        collectionView.register(InfoDataCell.self, forCellWithReuseIdentifier: info_cell)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(infoLabel)
        addSubview(collectionView)
        addSubview(dividedLine)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: infoLabel)
        addConstraintsWithFormat(format: "V:|-12-[v0(20)]-4-[v1][v2(0.5)]-4-|", views: infoLabel, collectionView, dividedLine)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividedLine)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        /*
         // top layout of sharing
         addConstraint(NSLayoutConstraint(item: sharingdValue, attribute: .top, relatedBy: .equal, toItem: ratingValue, attribute: .bottom, multiplier: 1, constant: 8))
         // left
         addConstraint(NSLayoutConstraint(item: sharingdValue, attribute: .left, relatedBy: .equal, toItem: sellerLabel, attribute: .right, multiplier: 1, constant: 46))
         
         // height
         addConstraint(NSLayoutConstraint(item: sharingdValue, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
         */
        //addConstraintsWithFormat(format: "V:-8-[v0]-8-", views: sellerName)
        
    }
    class InfoDataCell: BaseCell {
        var appInfo: AppInformation? {
            didSet {
                nameLabel.text = appInfo?.name
                valueLabel.text = appInfo?.value
            }
        }
        let nameLabel: UILabel = {
            let label = UILabel()
            //            label.text = "Developer"
            label.textColor = .darkGray
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 12)
            return label
        }()
        let valueLabel: UILabel = {
            let label = UILabel()
            //            label.text = "Jack Ma"
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 12)
            return label
        }()
        override func setupViews() {
            addSubview(nameLabel)
            addSubview(valueLabel)
            addConstraintsWithFormat(format: "H:|[v0(94)]-14-[v1]|", views: nameLabel, valueLabel)
            addConstraintsWithFormat(format: "V:|[v0(20)]", views: nameLabel)
            addConstraintsWithFormat(format: "V:|[v0(20)]", views: valueLabel)
            
        }
    }
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        
    }
}
