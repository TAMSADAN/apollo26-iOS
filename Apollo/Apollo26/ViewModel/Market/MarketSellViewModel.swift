//
//  MarketSellViewModel.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/17.
//

import Foundation
import RxSwift
import RxCocoa

class MarketSellViewModel: ViewModel {
    let tradeService = TradeService()
    var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    var product: Product!
    
    struct Input {
        let numberPadText = BehaviorSubject(value: "0")
        let selectedRate = PublishSubject<Double>()
        let isConfirmButtonClick = PublishSubject<Bool>()
    }
    
    struct Output {
        let product = BehaviorRelay(value: Product())
        let trade = BehaviorRelay(value: Trade())
        let numberPadText = BehaviorRelay(value: "")
        let inputTradeCount = BehaviorRelay(value: 0.0)
        let outputPrice = BehaviorRelay(value: 0.0)
        let laterTradeCount = BehaviorRelay(value: 0.0)
        let message = BehaviorRelay(value: "거래 가능합니다.")
        let canConfirmButtonClick = BehaviorRelay(value: false)
        let isSelled = BehaviorRelay(value: false)
    }
    
    init(product: Product) {
        self.product = product
        setBind()
        if let trade = tradeService.getTrade(productType: product.type, name: product.name) {
            output.trade.accept(trade)
        }
    }
}

extension MarketSellViewModel {
    func update(product: Product) {
        output.product.accept(product)
    }
    
    func setBind() {
        
        
        input.numberPadText
            .withUnretained(self)
            .bind { owner, text in
                let outputNumberPadText = owner.output.numberPadText.value
                
                if text == "." {
                    if outputNumberPadText.contains(text) == false {
                        owner.output.numberPadText.accept(outputNumberPadText + text)
                    }
                } else if text == "C" {
                    owner.output.numberPadText.accept("0")
                } else {
                    owner.output.numberPadText.accept(outputNumberPadText + text)
                }
            }
            .disposed(by: disposeBag)
        
        output.numberPadText
            .map {
                Double($0) ?? 0.0
            }
            .bind(to: output.inputTradeCount)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.selectedRate, output.trade)
            .withUnretained(self)
            .bind { owner, data in
                let rate = data.0
                let trade = data.1
                
                owner.output.numberPadText.accept(String(trade.count * rate))
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.trade, output.inputTradeCount, output.product)
            .withUnretained(self)
            .bind { owner, data in
                let trade = data.0
                let inputTradeCount = data.1
                let productPrice = data.2.price
              
                owner.output.outputPrice.accept(productPrice * inputTradeCount)
                owner.output.laterTradeCount.accept(trade.count - inputTradeCount)
                
                if trade.count - inputTradeCount < 0.0 {
                    owner.output.numberPadText.accept(String(trade.count))
                } else if inputTradeCount == 0.0 {
                    owner.output.message.accept("수량을 입력하세요.")
                } else {
                    owner.output.message.accept("거래 가능합니다.")
                }
            }
            .disposed(by: disposeBag)
        
        input.isConfirmButtonClick
            .withUnretained(self)
            .bind { owner, bool in
                let product = owner.output.product.value
                if owner.output.message.value == "거래 가능합니다." {
                    owner.tradeService.postTrade(trade: Trade(id: -1,
                                                              productType: product.type,
                                                              name: product.name,
                                                              symbol: product.symbol,
                                                              price: owner.output.trade.value.price,
                                                              count: -owner.output.inputTradeCount.value,
                                                              favorite: false,
                                                              imageSrc: product.imageUrl))

                    owner.tradeService.postTrade(trade: Trade(id: -1,
                                                              productType: ProductType.krw.rawValue,
                                                              name: ProductType.krw.rawValue,
                                                              symbol: "원",
                                                              price: 1,
                                                              count: (product.price * owner.output.inputTradeCount.value),
                                                              favorite: false,
                                                              imageSrc: ""))
                    owner.output.isSelled.accept(true)
                    Log("거래를 성공하였습니다.")
                }
            }
            .disposed(by: disposeBag)
        
    }
}
