//
//  PortfolioDataService.swift
//  CoinBlock
//
//  Created by Oran Levi on 19/05/2023.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("## Error loading Core data :\(error)")
            }
            self.getPortfolio()
        }
    }
    
    //MARK: - PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        // check if coin already in portfolio
        if let entity = savedEntities.first(where: {$0.coinID == coin.id }) {
            
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
        
    }
    
    //MARK: - PRIAVTE
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("## Error fetch: \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        appleChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        appleChanges()
    }
    
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        appleChanges()
    }
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("## Error saving to core data \(error)")
        }
    }
    
    private func appleChanges(){
        save()
        getPortfolio()
    }
}
