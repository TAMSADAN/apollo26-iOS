//
//  StoreViewModel.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import Foundation
import RxSwift
import RxCocoa

class MarketViewModel: ViewModel {
    let coinService = ProductService()
    var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    struct Input {
        
    }
    
    struct Output {
        let coins = PublishRelay<[Product]>()
    }
    
    init() {
        setBind()
        updateCoins()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] (timer) in
            self?.updateCoins()
            //            if someCondition {
            //                timer.invalidate()
            //            }
        }
    }
}

extension MarketViewModel {
    func updateCoins() {
        coinService.getProducts {
            [weak self] coins in
            self?.output.coins.accept(coins)
            
        }
    }
    
    func refresh() {
        setBind()
    }
    
    func setBind() {
        output.coins.accept([Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product(), Product()])
    }
}
