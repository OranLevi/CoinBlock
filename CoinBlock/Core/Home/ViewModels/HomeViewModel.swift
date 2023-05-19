//
//  HomeViewModel.swift
//  CoinBlock
//
//  Created by Oran Levi on 16/05/2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoin: [Coin] = []
    @Published var portfolioCoin: [Coin] = []
    @Published var statistic : [Statistic] = [
        Statistic(title: "tiel", value: "vak", percentageChange: 1),
        Statistic(title: "tiel", value: "vak"),
        Statistic(title: "tiel", value: "vak"),
        Statistic(title: "tiel", value: "vak", percentageChange: -7)]
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        //        dataService.$allCoin
        //            .sink { [weak self] returnedCoins in
        //                self?.allCoin = returnedCoins
        //            }
        //            .store(in: &cancellables)
        
        // updates all coin
        $searchText
            .combineLatest(dataService.$allCoin)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text, coins) -> [Coin] in
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
        
    }
}
