//
//  StoreDetailViewModel.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import Foundation
import RxSwift
import RxCocoa

class MarketDetailViewModel: ViewModel {
    let productService = ProductService()
    let tradeService = TradeService()
    var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    var product: Product!
    
    struct Input {
        let segmentIndex = PublishSubject<Int>()
    }
    
    struct Output {
        let coinCharts = PublishRelay<[ProductOhlc]>()
        let canSell = BehaviorRelay(value: false)
    }
    
    init(product: Product) {
        self.product = product
        setBind()
        if let _ = tradeService.getTrade(productType: product.type, name: product.name) {
            output.canSell.accept(true)
        }
    }
}

extension MarketDetailViewModel {
    func refresh() {
        setBind()
    }
    
    func setBind() {
        input.segmentIndex
            .withUnretained(self)
            .bind { owner, index in
                if index == 0 {
                    owner.productService.getCoinCharts(id: owner.product.id, days: "1") {
                        coinCharts in
                        owner.output.coinCharts.accept(coinCharts)
                    }
                } else if index == 1 {
                    owner.productService.getCoinCharts(id: owner.product.id, days: "30") {
                        coinCharts in
                        owner.output.coinCharts.accept(coinCharts)
                    }
                } else if index == 2 {
                    owner.productService.getCoinCharts(id: owner.product.id, days: "max") {
                        coinCharts in
                        owner.output.coinCharts.accept(coinCharts)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
