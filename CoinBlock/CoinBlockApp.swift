//
//  CoinBlockApp.swift
//  CoinBlock
//
//  Created by Oran Levi on 14/05/2023.
//

import SwiftUI

@main
struct CoinBlockApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
