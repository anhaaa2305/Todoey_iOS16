//
//  Category.swift
//  Todoey
//
//  Created by 🤪😋😝Ronaldo👻👻👻 Ánh on 14/07/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = " "
    let items = List<Item> () 
}
