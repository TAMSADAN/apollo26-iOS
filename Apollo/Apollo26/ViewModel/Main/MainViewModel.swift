//
//  MainViewModel.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/15.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModel {
    let tradeService = TradeService()
    let coinService = ProductService()
    let goldRepository = GoldRepository()
    var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    struct Input {
        
    }
    
    struct Output {
        let products = PublishRelay<[Product]>()
        let krwPrice = BehaviorRelay(value: 0.0)
    }
    
    init() {
        setBind()
        updateCoins()
        goldRepository.getGold()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] (timer) in
            self?.updateCoins()
        }
        if let _ = tradeService.getTrade(productType: ProductType.krw.rawValue, name: ProductType.krw.rawValue) {
            
        } else {
            tradeService.postKRW(count: 100000)
        }
    }
}

extension MainViewModel {
    func updateCoins() {
        coinService.getProducts {
            [weak self] coins in
            self?.output.products.accept(coins)
        }
    }
    
    func refresh() {
        setBind()
    }
    
    func setBind() {
        output.products.accept([Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product()])
    }
}
