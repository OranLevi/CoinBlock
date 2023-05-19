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
    private let fileManager = LocalFileManager.instance
    private let folderImage = "coin_images"
    private let imageName: String
    
    init(coin: Coin){
        self.coin = coin
        self.imageName = coin.id
        self.getCoinImage()
        
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderImage) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
        
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription =
        NetworkingManger.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink { completion in
                NetworkingManger.handleCompletion(completion: completion)
            } receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderImage)
                
            }
    }
}
