//
//  CoinDataService.swift
//  CoinBlock
//
//  Created by Oran Levi on 16/05/2023.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoin: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init(){
        getCoins()
    }
    
    func getCoins() {
        
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        
        guard let url = URL(string: urlString) else { return }
        
        coinSubscription =
        NetworkingManger.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                NetworkingManger.handleCompletion(completion: completion)
            } receiveValue: { [weak self] returnedCoins in
                self?.allCoin = returnedCoins
                self?.coinSubscription?.cancel()
            }
    }
}
