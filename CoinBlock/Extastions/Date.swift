//
//  Date.swift
//  CoinBlock
//
//  Created by Oran Levi on 20/05/2023.
//

import Foundation

extension Date {
    
    init(coinString: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH::mm:ss.SSSZ"
        let date = formatter.date(from: coinString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    
    func asShortDataString() -> String {
        return shortFormatter.string(from: self)
    }
    
}
