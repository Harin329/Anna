//
//  Coupon.swift
//  Anna
//
//  Created by Harin Wu on 2022-02-07.
//  Copyright © 2022 Hao Wu. All rights reserved.
//

import Foundation

public struct Coupon {
    var ID: String
    var Text: String
    var Category: String
    var Valid: Bool
}

// MARK: - init
extension Coupon {
    init(ID: String, data: [String:Any]) {
        self.ID = ID
        self.Text = data["Text"] as? String ?? ""
        self.Category = data["Category"] as? String ?? ""
        self.Valid = data["Valid"] as? Bool ?? false
    }
}


extension Coupon {
    init() {
        self.ID = ""
        self.Text = ""
        self.Category = ""
        self.Valid = false
    }
}
