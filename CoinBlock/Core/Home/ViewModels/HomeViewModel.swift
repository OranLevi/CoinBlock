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
    
    @Published var isLoading: Bool = false
    
    @Published var sortOption: SortOptions = .holding
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOptions {
        case rank, rankReversed, holding, holdingReversed, price, priceReversed
    }
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        
        //updated all coins
        $searchText
            .combineLatest(coinDataService.$allCoin, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterAndSortCoins)
            .sink { [weak self] (retunedCoins) in
                self?.allCoin = retunedCoins
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
                guard let self = self else { return }
                self.portfolioCoin = self.sortPortfolioCoinsIfNeeded(coins: returnPortfolio)
            }
            .store(in: &cancellables)
        
        //updated market data
        marketDataService.$marketData
            .combineLatest($portfolioCoin)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnMarketData in
                self?.statistic = returnMarketData
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func sortCoins(sort: SortOptions, coins: inout [CoinModel])  {
        switch sort {
        case .rank, .holding: coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingReversed: coins.sort(by: {$0.rank > $1.rank})
        case .price: coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed: coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel]{
        // sort only holding and reversedholding
        switch sortOption {
        case .holding: return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingReversed: return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default: return coins
        }
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel],sort: SortOptions) -> [CoinModel]{
        var flitteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &flitteredCoins)
        return flitteredCoins
    }
    
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercaseText = text.lowercased()
        
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercaseText) || coin.symbol.lowercased().contains(lowercaseText) || coin.id.lowercased().contains(lowercaseText)
        }
    }
    
    
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins:[ CoinModel]) -> [StatisticModel] {
        var stat: [StatisticModel] = []
        
        guard let data = marketDataModel else { return stat }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h volume", value: data.marketCap)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map{($0.currentHoldingsValue)}
            .reduce(0, +)
        
        let previousValue = portfolioCoin
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(),percentageChange: percentageChange)
        
        
        stat.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stat
    }
    
    
}
