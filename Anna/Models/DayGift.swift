//
//  DayGift.swift
//  Anna
//
//  Created by Harin Wu on 2020-03-18.
//  Copyright © 2020 Hao Wu. All rights reserved.
//

import Foundation
import Firebase

public struct DayGift {
    var ID: String
    var Date: String
    var Link: String
    var Message: String
    var Image: StorageReference
    var Opened: Bool
}

// MARK: - init
extension DayGift {
    init(ID: String, data: [String:Any]) {
        let str = (data["Date"] as? String ?? "")
        let delimiter = ","
        let parts = str.components(separatedBy: delimiter)
        let day = parts[0]
        
        self.ID = ID
        self.Date = data["Date"] as? String ?? ""
        self.Link = data["Link"] as? String ?? ""
        self.Message = data["Message"] as? String ?? ""
        self.Image = Storage.storage().reference().child("2020").child(day + ".jpg")
        self.Opened = data["Opened"] as? Bool ?? false
    }
}


extension DayGift {
    init() {
        self.ID = ""
        self.Date = ""
        self.Link = ""
        self.Message = ""
        self.Image = StorageReference()
        self.Opened = false
    }
}
