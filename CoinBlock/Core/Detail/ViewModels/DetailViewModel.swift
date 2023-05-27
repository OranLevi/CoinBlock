//
//  DetailViewModel.swift
//  CoinBlock
//
//  Created by Oran Levi on 20/05/2023.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteUrl: String? = nil
    @Published var redditUrl: String? = nil
    
    @Published var coin: CoinModel
    
    private let coinDetailService: CoinDetailDataService
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
    init(coin: CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailService.$coinsDetails
            .combineLatest($coin)
            .map({ (coinDetailModel, coinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) in
                
                
                // overview
                let price = coinModel.currentPrice.asCurrencyWith6Decimals()
                let pricePresentChange = coinModel.priceChangePercentage24H
                let priceStat = StatisticModel(title: "Current Price", value: price,percentageChange: pricePresentChange)
                
                let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
                let marketCapPresentChange = coinModel.marketCapChange24H
                let makrtCapsStat = StatisticModel(title: "Market Capitalization", value: marketCap,percentageChange: marketCapPresentChange)
                
                let rank = "\(coinModel.rank)"
                let rankStat = StatisticModel(title: "Rank", value: rank)
                
                let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
                let volumeStat = StatisticModel(title: "Volume", value: volume)
                
                let overviewArray: [StatisticModel] = [
                    priceStat, makrtCapsStat, rankStat, volumeStat
                ]
                
                // additional
                
                let high = coinModel.high24H?.asNumberString() ?? ""
                let hideStat = StatisticModel(title: "24h High", value: high)
                
                let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
                let lowStat = StatisticModel(title: "24h Low", value: low)
                
                let priceChange = coinModel.priceChange24H?.asCurrencyWith2Decimals() ?? "n/a"
                let pricePresentChange2 = coinModel.priceChangePercentage24H
                let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePresentChange2)
                
                let marketCapChange = "$" +  (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
                let marketCapChangeChange2 = coinModel.marketCapChange24H
                let marketCapChangeStat = StatisticModel(title: "24h Market cap change", value: marketCapChange, percentageChange: marketCapChangeChange2)
                
                let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
                let blockTimeStarting = blockTime == 0 ? "n/a" : "\(blockTime)"
                let blockStat = StatisticModel(title: "Block Time", value: blockTimeStarting)
                
                
                let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
                let hasingStat = StatisticModel(title: "Hasing Algorithm", value: hashing)
                
                
                let additionalArray: [StatisticModel] = [
                    hideStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hasingStat
                ]
                
                
                return(overviewArray,additionalArray)
            })
            .sink { [weak self] returnArrays in
                self?.overviewStatistics =  returnArrays.overview
                self?.additionalStatistics = returnArrays.additional
            }
            .store(in: &cancellables)
        
        
        coinDetailService.$coinsDetails
            .sink {[weak self] (returnCoinDetails) in
                self?.coinDescription = returnCoinDetails?.description?.en
                self?.websiteUrl = returnCoinDetails?.links?.homepage?.first
                self?.redditUrl = returnCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
}
