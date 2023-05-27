//
//  HomeStatisticView.swift
//  CoinBlock
//
//  Created by Oran Levi on 19/05/2023.
//

import SwiftUI

struct HomeStatisticView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        
        HStack{
            ForEach(vm.statistic) { item in
                StatisticView(stat: item)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        } .frame(width: UIScreen.main.bounds.width,alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatisticView(showPortfolio: .constant(true))
            .environmentObject(dev.homeVM)
    }
}
