//
//  CoinImageService.swift
//  CoinBlock
//
//  Created by Oran Levi on 17/05/2023.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    var imageSubscription: AnyCancellable?
    
    private let coin: Coin
    init(coin: Coin){
        self.coin = coin
        self.getCoinImage()
        
    }
    
    private func getCoinImage(){
        
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription =
        NetworkingManger.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink { completion in
                NetworkingManger.handleCompletion(completion: completion)
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            }
    }
}
