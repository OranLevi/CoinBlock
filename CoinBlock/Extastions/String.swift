//
//  String.swift
//  CoinBlock
//
//  Created by Oran Levi on 20/05/2023.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression , range: nil)
    }
}
