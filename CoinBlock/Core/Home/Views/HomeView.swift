//
//  HomeView.swift
//  CoinBlock
//
//  Created by Oran Levi on 14/05/2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @State private var showPortfolio: Bool = false // animate
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack{
            
            // background
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            // content
            VStack{
                homeHeader
                
                HomeStatisticView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.horizontal)
                
                if vm.allCoin.isEmpty && vm.searchText.count > 1 {
                    Text("No results")
                        .offset(y: UIScreen.main.bounds.height / 4)
                }
                
                if !showPortfolio {
                    allCoinList
                        .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    ZStack(alignment: .top){
                        if vm.portfolioCoin.isEmpty && vm.searchText.isEmpty {
                            portfolioEmptyText
                        } else {
                            portfolioCoin
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin),
                           isActive: $showDetailView,
                           label: { EmptyView()})
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }.environmentObject(dev.homeVM)
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        HStack{
            CircleButtonView(iconName: "plus")
                .opacity(showPortfolio ? 1 : 0)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" :"Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinList: some View {
        List{
            ForEach(vm.allCoin) { item in
                CoinRowView(coin: item, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: item)
                    }
            }
        }
        .refreshable {
            vm.reloadData()
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoin: some View {
        List{
            ForEach(vm.portfolioCoin) { item in
                CoinRowView(coin: item, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: item)
                    }
            }
        }
        .refreshable {
            vm.reloadData()
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack{
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }.onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
                
            }
            
            Spacer()
            if showPortfolio {
                HStack(spacing: 4){
                    Text("Holding")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holding || vm.sortOption == .holdingReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holding ? 0 : 180))
                }.onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holding ? .holdingReversed : .holding
                    }
                    
                }
            }
            HStack(spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
                
            }
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0),anchor: .center)
        }
    }
    
    private var portfolioEmptyText: some View{
        Text("You haven't added any coins to your portfolio yet! Click the + button to get started.")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
}

extension HomeView {
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}
