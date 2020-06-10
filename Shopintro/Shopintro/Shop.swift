//
//  Shop.swift
//  Shopintro
//
//  Created by Owner on 2020/06/10.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class Shop: SQLTable {
    var id = -1
    var address = ""
    var name = ""
    var longitude = 0.0
    var latitude = 0.0
    
    init(){
        super.init(tableName: "shop")
    }
    required convenience init(tableName: String){
        self.init()
    }
}
