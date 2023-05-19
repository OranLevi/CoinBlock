//
//  Statistic.swift
//  CoinBlock
//
//  Created by Oran Levi on 19/05/2023.
//

import Foundation

struct Statistic : Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
}

let newModel = Statistic(title: "", value: "")
