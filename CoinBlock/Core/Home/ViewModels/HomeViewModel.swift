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
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers(){
        dataService.$allCoin
            .sink { [weak self] returnedCoins in
                self?.allCoin = returnedCoins
            }
            .store(in: &cancellables)
    }
}
