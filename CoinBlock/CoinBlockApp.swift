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
    
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
                
                ZStack{
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
