//
//  CoinDetailDataService.swift
//  CoinBlock
//
//  Created by Oran Levi on 20/05/2023.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinsDetails: CoinDetailModel? = nil
    var coinDetailSubscription: AnyCancellable?
    
    let coin: CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinsDetails()
    }
    
    func getCoinsDetails() {
        
        let urlString = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        
        guard let url = URL(string: urlString) else { return }
        
        coinDetailSubscription =
        NetworkingManger.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                NetworkingManger.handleCompletion(completion: completion)
            } receiveValue: { [weak self] returnedCoinsDetail in
                self?.coinsDetails = returnedCoinsDetail
                self?.coinDetailSubscription?.cancel()
            }
    }
}
