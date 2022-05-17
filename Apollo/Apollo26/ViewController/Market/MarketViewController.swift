//
//  MarketViewController.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class MarketViewController: UIViewController {
    weak var mainVM: MainViewModel!
    var disposeBag = DisposeBag()
    
    var coinTableView = UITableView().then {
        $0.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.rowHeight = 80
    }
    var coinTableViewAdaptor = ProductTableViewAdaptor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Const.Color.white
        setNavigation()
        setView()
        setBind()
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ mainVM: MainViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.mainVM = mainVM
    }
}

extension MarketViewController {
    func updateCoinTableView(products: [Product]) {
        coinTableViewAdaptor.update(self, mainVM: mainVM, products: products)
        coinTableView.reloadData()
        for coinTableViewCell in coinTableView.visibleCells {
            let cell = coinTableViewCell as! ProductTableViewCell
            if let product = products.first(where: { $0.name == cell.product.name }) {
                cell.update(product: product)
            }
        }
        
    }
    
    func setTableView() {
        coinTableView.delegate = coinTableViewAdaptor
        coinTableView.dataSource = coinTableViewAdaptor
    }
    
    func setNavigation() {
        navigationItem.title = "거래소"
    }
    
    func setView() {
        view.addSubview(coinTableView)
        
        coinTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coinTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            coinTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            coinTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            coinTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension MarketViewController {
    func setBind() {
        mainVM.output.products
            .withUnretained(self)
            .bind { owner, coins in
                owner.updateCoinTableView(products: coins)
                
            }
            .disposed(by: disposeBag)
    }
}
