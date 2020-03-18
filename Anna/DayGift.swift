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
    var Image: String
    var Opened: Bool
}

// MARK: - init
extension DayGift {
    init(ID: String, data: [String:Any]) {
        self.ID = ID
        self.Date = data["Date"] as? String ?? ""
        self.Link = data["Link"] as? String ?? ""
        self.Message = data["Message"] as? String ?? ""
        self.Image = "gs://anna-and-harin.appspot.com/DailyPicture/" + (data["Date"] as? String ?? "") + ".JPG"
        self.Opened = data["Opened"] as? Bool ?? false
    }
}


extension DayGift {
    init() {
        self.ID = ""
        self.Date = ""
        self.Link = ""
        self.Message = ""
        self.Image = ""
        self.Opened = false
    }
}
