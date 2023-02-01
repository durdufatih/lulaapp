//
//  ListenModel.swift
//  lulaapp
//
//  Created by Mehmet Fatih Durdu on 21.01.2023.
//

import Foundation

struct ListenModel{
    let name :String
    let image:String
    let shownName : String
    
    init(name: String, image: String, shownName: String) {
        self.name = name
        self.image = image
        self.shownName = shownName
    }
}
