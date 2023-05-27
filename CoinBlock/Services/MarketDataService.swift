//
//  MarketDataService.swift
//  CoinBlock
//
//  Created by Oran Levi on 19/05/2023.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init(){
        getData()
    }
    
    func getData() {
        
        let urlString = "https://api.coingecko.com/api/v3/global"
        
        guard let url = URL(string: urlString) else { return }
        
        marketDataSubscription =
        NetworkingManger.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                NetworkingManger.handleCompletion(completion: completion)
            } receiveValue: { [weak self] returnedData in
                self?.marketData = returnedData.data
                self?.marketDataSubscription?.cancel()
            }
    }
    
}
