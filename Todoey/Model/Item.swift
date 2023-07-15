//
//  Item.swift
//  Todoey
//
//  Created by 🤪😋😝Ronaldo👻👻👻 Ánh on 14/07/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = " "
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    let toParents = LinkingObjects(fromType: Category.self, property: "items")
}
