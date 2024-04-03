//
//  ShoppingItem.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 4/4/24.
//

import Foundation

struct ShoppingItem {
    var isDone: Bool
    let itemName: String
    var favorite: Bool
    
    init(isDone: Bool = false, itemName: String, favorite: Bool = false) {
        self.isDone = isDone
        self.itemName = itemName
        self.favorite = favorite
    }
}
