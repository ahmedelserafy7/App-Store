//
//  CategoryModels.swift
//  appstore
//
//  Created by Ahmed.S.Elserafy on 10/18/17.
//  Copyright © 2017 Ahmed.S.Elserafy. All rights reserved.
//

import UIKit

struct FeaturedApps: Decodable {
    let bannerCategory: CategoryModels?
    let categories: [CategoryModels]?
}

struct CategoryModels: Decodable {
    let name: String?
    let apps: [App]?
    let type: String?
}

struct App: Decodable {
    let Id: Int?
    let Name: String?
    let Category: String?
    let ImageName : String?
    let Price: Double?
    
    let Screenshots: [String]?
    let appInformation: [AppInformation]?
    let description: String?
}


struct AppInformation: Decodable {
    let Name: String?
    let Value: String?
}





