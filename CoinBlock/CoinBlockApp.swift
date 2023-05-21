//
//  CoinBlockApp.swift
//  CoinBlock
//
//  Created by Oran Levi on 14/05/2023.
//

import SwiftUI

@main
struct CoinBlockApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(vm)
        }
    }
}
