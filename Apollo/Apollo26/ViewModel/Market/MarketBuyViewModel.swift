//
//  TradeViewModel.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/12.
//

import Foundation
import RxSwift
import RxCocoa

class MarketBuyViewModel: ViewModel {
    let tradeService = TradeService()
    var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    struct Input {
        let numberPadText = BehaviorSubject(value: "0")
        let selectedRate = PublishSubject<Double>()
        let isConfirmButtonClick = PublishSubject<Bool>()
    }
    
    struct Output {
        let product = BehaviorRelay(value: Product())
        let numberPadText = BehaviorRelay(value: "")
        let inputPrice = BehaviorRelay(value: 0.0)
        let outputCount = BehaviorRelay(value: 0.0)
        let laterKrwPrice = BehaviorRelay(value: 0.0)
        let krwPrice = BehaviorRelay(value: 0.0)
        let message = BehaviorRelay(value: "거래 가능합니다.")
        let canConfirmButtonClick = BehaviorRelay(value: false)
        let isBuied = BehaviorRelay(value: false)
    }
    
    init() {
        setBind()
    }
}

extension MarketBuyViewModel {
    func update(coin: Product) {
        output.product.accept(coin)
    }
    
    func setBind() {
        if let krwTrade = tradeService.getTrade(productType: ProductType.krw.rawValue, name: ProductType.krw.rawValue) {
            output.krwPrice.accept(krwTrade.price * krwTrade.count)
        }
        
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
        
        input.selectedRate
            .bind { rate in
                Log(rate)
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
                                                              price: product.price,
                                                              count: owner.output.outputCount.value,
                                                              favorite: false,
                                                              imageSrc: product.imageUrl))
                    
                    owner.tradeService.postTrade(trade: Trade(id: -1,
                                                              productType: ProductType.krw.rawValue,
                                                              name: ProductType.krw.rawValue,
                                                              symbol: "원",
                                                              price: 1,
                                                              count: -(product.price * owner.output.outputCount.value),
                                                              favorite: false,
                                                              imageSrc: ""))
                    owner.output.isBuied.accept(true)
                    Log("거래를 성공하였습니다.")
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.selectedRate, output.krwPrice)
            .withUnretained(self)
            .bind { owner, data in
                let rate = data.0
                let krwPrice = data.1
                
                owner.output.numberPadText.accept(String(krwPrice * rate))
//                Log(String(krwPrice * rate))
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.krwPrice, output.numberPadText, output.product)
            .withUnretained(self)
            .bind { owner, data in
                let krwPrice = data.0
                let inputPrice = Double(data.1) ?? 0.0
                let productPrice = data.2.price
                let inputCount = inputPrice / productPrice
                
                owner.output.laterKrwPrice.accept(krwPrice - inputPrice)
                owner.output.outputCount.accept(inputCount)
                Log(krwPrice - inputPrice)
                Log(data.1)
                
                if krwPrice - inputPrice < 0.0 {
                    owner.output.message.accept("KRW가 부족합니다.")
                    owner.output.numberPadText.accept(String(krwPrice))
                } else if inputPrice == 0.0 {
                    owner.output.message.accept("금액을 입력하세요.")
                } else {
                    owner.output.message.accept("거래 가능합니다.")
                }
            }
            .disposed(by: disposeBag)
    }
}
