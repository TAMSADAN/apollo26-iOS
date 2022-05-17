//
//  TradeViewController.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class HistoryViewController: UIViewController {
    var mainVM: MainViewModel!
    var viewModel = HistoryViewModel()
    var disposeBag = DisposeBag()
    
    var titleLabel = UILabel().then {
        $0.text = "현재 자산"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.body
    }
    var priceLabel = UILabel().then {
        $0.text = "0원"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.largeTitle
    }
    var historyTableView = UITableView().then {
        $0.register(TradeTableViewCell.self, forCellReuseIdentifier: TradeTableViewCell.identifier)
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.rowHeight = 80
    }
    var historyTableViewAdaptor = TradeTableViewAdaptor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setView()
        setTableView()
        setBind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.refresh()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ mainVM: MainViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.mainVM = mainVM
    }
}

extension HistoryViewController {
    func updateHistoryTableView(trades: [Trade]) {
        historyTableViewAdaptor.update(self, mainVM: mainVM, trades: trades)
        historyTableView.reloadData()
    }
    
    func updateTradeTableViewProduct(products: [Product]) {
        historyTableViewAdaptor.updateProducts(products: products)
        historyTableView.reloadData()
    }
    
    func setNavigation() {
        navigationItem.title = "내역"
    }
    
    func setTableView() {
        historyTableView.delegate = historyTableViewAdaptor
        historyTableView.dataSource = historyTableViewAdaptor
    }
    
    func setView() {
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(historyTableView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            historyTableView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setBind() {
        viewModel.output.krwPrice
            .withUnretained(self)
            .bind { owner, price in
                Log(price)
                owner.priceLabel.text =  String(price.round2()).insertComma + "원"
            }
            .disposed(by: disposeBag)
        
        viewModel.output.trades
            .withUnretained(self)
            .bind { owner, trades in
                owner.updateHistoryTableView(trades: trades)
            }
            .disposed(by: disposeBag)
        
        mainVM.output.products
            .withUnretained(self)
            .bind { owner, products in
                owner.updateTradeTableViewProduct(products: products)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(mainVM.output.products, viewModel.output.trades, viewModel.output.krwPrice)
            .withUnretained(self)
            .bind { owner, data in
                let products = data.0
                let trades = data.1
                let krwPrice = data.2
                
                var sum = krwPrice
                
                for trade in trades {
                    if let product = products.first(where: { $0.type == trade.productType && $0.name == trade.name }) {
                        sum += product.price * trade.count
                    }
                }
                owner.priceLabel.text = String(ceil(sum * 100) / 100).insertComma + "원"
            }
            .disposed(by: disposeBag)
        
//        viewModel.output.trades
//            .withUnretained(self)
//            .bind { owner, trades in
//                owner.updateHistoryTableView(trades: trades)
//            }
//            .disposed(by: disposeBag)
        
//        mainVM.output.coins
//            .withUnretained(self)
//            .bind { owner, coins in
//                owner.updateHistoryTableView(products: coins)
//            }
//            .disposed(by: disposeBag)
    }
}
