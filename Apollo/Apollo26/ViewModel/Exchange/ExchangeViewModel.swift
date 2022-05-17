//
//  ExchangeViewModel.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/15.
//

import Foundation
import RxSwift
import RxCocoa

class ExchangeViewModel: ViewModel {
    let tradeService = TradeService()
    let adService = AdService()
    var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    struct Input {
        let isClickAdButton = PublishSubject<Bool>()
        let watchedAd1 = PublishSubject<Bool>()
        let watchedAd2 = PublishSubject<Bool>()
    }
    
    struct Output {
        let krwPrice = BehaviorRelay(value: 0.0)
        let ad = BehaviorRelay(value: Ad())
        let adCount = BehaviorRelay(value: 0)
        let canAd = BehaviorRelay(value: false)
    }
    
    init() {
        setBind()
    }
    
    func refresh() {
        if let krwTrade = tradeService.getTrade(productType: ProductType.krw.rawValue, name: ProductType.krw.rawValue) {
            output.krwPrice.accept(krwTrade.price * krwTrade.count)
        }
        if let ad = adService.getAd(date: Date()) {
            output.ad.accept(ad)
        }
    }
}

extension ExchangeViewModel {
    func setBind() {
        if let krwTrade = tradeService.getTrade(productType: ProductType.krw.rawValue, name: ProductType.krw.rawValue) {
            output.krwPrice.accept(krwTrade.price * krwTrade.count)
        }
        if let ad = adService.getAd(date: Date()) {
            output.ad.accept(ad)
        }
        
        output.ad
            .map { $0.count }
            .bind(to: output.adCount)
            .disposed(by: disposeBag)
        
        input.watchedAd1
            .withUnretained(self)
            .bind { owner, bool in
                if bool {
                    owner.adService.postAd(ad: Ad(id: -1, count: 1, date: Date()))
                    owner.tradeService.postKRW(count: owner.output.krwPrice.value * 0.1)
                }
            }
            .disposed(by: disposeBag)
        
        input.watchedAd2
            .withUnretained(self)
            .bind { owner, bool in
                if bool {
                    owner.adService.postAd(ad: Ad(id: -1, count: 1, date: Date()))
                    owner.tradeService.postKRW(count: 100000)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.isClickAdButton, output.adCount)
            .withUnretained(self)
            .bind { owner, data in
                let bool = data.0
                let adCount = data.1
                
                if bool && adCount < 5 {
                    owner.output.canAd.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
    }
}
