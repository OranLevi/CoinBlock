//
//  HomeViewModel.swift
//  CoinBlock
//
//  Created by Oran Levi on 16/05/2023.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoin: [CoinModel] = []
    @Published var portfolioCoin: [CoinModel] = []
    @Published var statistic : [StatisticModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        
        //updated all coins
        $searchText
            .combineLatest(coinDataService.$allCoin)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text, coins) -> [CoinModel] in
                guard !text.isEmpty else {
                    return coins
                }
                let lowercaseText = text.lowercased()
                
                return coins.filter { coin in
                    return coin.name.lowercased().contains(lowercaseText) || coin.symbol.lowercased().contains(lowercaseText) || coin.id.lowercased().contains(lowercaseText)
                }
            }
            .sink { [weak self] (retunedCoins) in
                self?.allCoin = retunedCoins
            }
            .store(in: &cancellables)
        
        //updated market data
        marketDataService.$marketData
            .map({ (MarketData) -> [StatisticModel] in
                var stat: [StatisticModel] = []
                
                guard let data = MarketData else { return stat }
                
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                
                let volume = StatisticModel(title: "24h volume", value: data.marketCap)
                
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
                
                let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00",percentageChange: 0)
                
                
                stat.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])
                
                return stat
            })
            .sink { [weak self] returnMarketData in
                self?.statistic = returnMarketData
            }
            .store(in: &cancellables)
        
        //update portfolio coins
        $allCoin
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities ) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id})else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnPortfolio) in
                self?.portfolioCoin = returnPortfolio
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
}
