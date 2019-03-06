//
//  CategoryModels.swift
//  appstore
//
//  Created by Ahmed.S.Elserafy on 10/18/17.
//  Copyright © 2017 Ahmed.S.Elserafy. All rights reserved.
//

import UIKit

class FeaturedApps: NSObject {
    var bannerCategory : CategoryModels?
    var appCategories: [CategoryModels]?

    override func setValue(_ value: Any?, forKey key: String) {
        if key == "bannerCategory" {
            bannerCategory = CategoryModels()
            // to be initialized
            bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
        } else if key == "categories" {
            appCategories = [CategoryModels]()
            for dict in value as! [[String: AnyObject]] {
                let appCategory = CategoryModels()
                appCategory.setValuesForKeys(dict)
                appCategories?.append(appCategory)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class CategoryModels: NSObject {
    
    var name: String?
    var appss: [App]?
    var type: String?
    
    // set property with specified / determined key to get its value
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            
            appss = [App]()
            // handle with value as key to be the key instaed of dictionary[0]
            for dict in value as! [[String : AnyObject]] {
                let app = App()
                // bind properties to values by keys in dictionary to identify properties
                app.setValuesForKeys(dict)
                appss?.append(app)
            }
            
        }
        else {
            super.setValue(value, forKey: key)
        }
        
    }
    
    static func fetchMyAppCategory(completionHandler:@escaping (FeaturedApps)->()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
    
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if error != nil {
                print(error!)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                let featuredApps = FeaturedApps()
                //setValuesForKeys: accept dictionary bind properties with values with condition properties the same keys to identify properties
                featuredApps.setValuesForKeys(json)
                
                /*
                var appCategories = [CategoryModels]()
                for dict in json["categories"] as! [[String: AnyObject]] {
                    let appCategory = CategoryModels()
                    // extract values from keys "dict" and bind it to appCategory
                    appCategory.setValuesForKeys(dict)
                    appCategories.append(appCategory)
                }*/
 
                DispatchQueue.main.async {
                  completionHandler(featuredApps)
                }
         //       print(featuredApps)

            } catch let err {
                print(err)
            }
        }.resume()
    }
    /*
    static func sampleAppCategory()->[CategoryModels] {
        
        let bestNewApps = CategoryModels()
        bestNewApps.name = "Best New Apps"
        
        var apps = [App]()
        let frozenApp = App()
        frozenApp.name = "Disney Build it: Frozen"
        frozenApp.category = "Entertainemt"
        frozenApp.price = NSNumber(floatLiteral: 3.99)
        frozenApp.imageName = "frozen"
        apps.append(frozenApp)
        bestNewApps.apps = apps
        
        let bestNewGames = CategoryModels()
        bestNewGames.name = "Best New Games"
        
        var gameApp = [App]()
        let gameApps = App()
        gameApps.name = "Telepaint"
        gameApps.imageName = "telepaint"
        gameApps.price = NSNumber(floatLiteral: 2.99)
        gameApps.category = "Games"
        gameApp.append(gameApps)
        bestNewGames.apps = gameApp
        
        
        let angryGameApps = App()
        angryGameApps.name = "Angey Birds"
        angryGameApps.imageName = "angrybirdsspace"
        angryGameApps.price = NSNumber()
        angryGameApps.category = "Games"
        gameApp.append(angryGameApps)
        bestNewGames.apps = gameApp
        
        return [bestNewApps, bestNewGames]
    }*/
    
}

class App: NSObject {
    
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName : String?
    var price: NSNumber?
    
    var screenshots: [String]?
    var appsInformation: [AppInformation]?
    var desc: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description" {
            // set like that, coz it is string not class contains values/ properties
            desc = value as? String
        } else if key == "appInformation" {
            appsInformation = [AppInformation]()
            for dict in value as! [[String: AnyObject]] {
                let appInfo = AppInformation()
                appInfo.name = dict["Name"] as! String?
                appInfo.value = dict["Value"] as! String?
                appsInformation?.append(appInfo)
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}


class AppInformation: AnyObject {
    var name: String?
    var value: String?
}





