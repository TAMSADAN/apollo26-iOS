//
//  HistoryViewModel.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/12.
//

import Foundation
import RxSwift
import RxCocoa

class HistoryViewModel: ViewModel {
    let tradeService = TradeService()
    var disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    struct Input {
        
    }
    
    struct Output {
        let trades = BehaviorRelay(value: [Trade()])
        let krwTrade = BehaviorRelay(value: Trade())
        let krwPrice = BehaviorRelay(value: 0.0)
    }
    
    init() {
        setBind()
        Log(tradeService.getTrades())
    }
}

extension HistoryViewModel {
    func refresh() {
        setBind()
        Log(tradeService.getTrades())
    }
    
    func setBind() {
        if let krwTrade = tradeService.getTrade(productType: ProductType.krw.rawValue, name: ProductType.krw.rawValue) {
            output.krwTrade.accept(krwTrade)
        }
        
        output.trades.accept(tradeService.getTrades().filter({ $0.productType != ProductType.krw.rawValue && $0.count != 0.0 }))
        
        output.krwTrade
            .map {
                $0.price * $0.count
            }
            .bind(to: output.krwPrice)
            .disposed(by: disposeBag)
    }
}
