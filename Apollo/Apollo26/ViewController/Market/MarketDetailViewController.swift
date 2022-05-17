//
//  MarketDetailViewController.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import LightweightCharts

class MarketDetailViewController: UIViewController {
    weak var mainVM: MainViewModel!
    var disposeBag = DisposeBag()
    var product: Product!
    var viewModel: MarketDetailViewModel!
    
    var chartView: LightweightCharts!
    var series: BarSeries!
    var candleSeries: CandlestickSeries!
    
    var productImageBackgroundView = UIView().then {
        $0.backgroundColor = Const.Color.systemGray6
        $0.layer.cornerRadius = 18
    }
    var productImageView = UIImageView()
    var buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    var segmentView = UISegmentedControl(items: ["1일", "30일", "전체"]).then {
        $0.selectedSegmentIndex = 0
    }
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.textColor = Const.Color.black
        $0.font = Const.Font.footnote
    }
    var priceLabel = UILabel().then {
        $0.text = "124,509원"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.largeTitle2
        $0.textAlignment = .right
    }
    var sellButton = CancelButton(text: "판매하기")
    var buyButton = ConfirmButton(text: "구매하기")
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ mainVM:  MainViewModel, product: Product) {
        super.init(nibName: nil, bundle: nil)
        self.mainVM = mainVM
        self.viewModel = MarketDetailViewModel(product: product)
        update(product: product)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Const.Color.white
        setNavigation()
        setView()
        setBind()
    }
}

extension MarketDetailViewController {
    func update(product: Product) {
        self.product = product
        priceLabel.text = String(ceil(product.price * 100) / 100.0).insertComma + "원"
        productImageView.downloaded(from: product.imageUrl)
    }
    
    func setNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = product.name
    }
    
    func setView() {
        chartView = LightweightCharts()
        candleSeries = chartView.addCandlestickSeries(options: nil)
        
        view.addSubview(productImageBackgroundView)
        view.addSubview(productImageView)
        view.addSubview(chartView)
        view.addSubview(segmentView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(buttonStackView)
//        buttonStackView.addArrangedSubview(sellButton)
//        buttonStackView.addArrangedSubview(buyButton)
        
        productImageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            productImageBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            productImageBackgroundView.heightAnchor.constraint(equalToConstant: 36),
            productImageBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            
            productImageView.topAnchor.constraint(equalTo: productImageBackgroundView.topAnchor, constant: 3),
            productImageView.leadingAnchor.constraint(equalTo: productImageBackgroundView.leadingAnchor, constant: 3),
            productImageView.trailingAnchor.constraint(equalTo: productImageBackgroundView.trailingAnchor, constant: -3),
            productImageView.bottomAnchor.constraint(equalTo: productImageBackgroundView.bottomAnchor, constant: -3),
            
            titleLabel.topAnchor.constraint(equalTo: productImageBackgroundView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: productImageBackgroundView.trailingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            priceLabel.centerYAnchor.constraint(equalTo: productImageBackgroundView.centerYAnchor),
            
            chartView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 300),
            
            segmentView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 10),
            segmentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            segmentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            segmentView.heightAnchor.constraint(equalToConstant: 30),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}

extension MarketDetailViewController {
    func setBind() {
        mainVM.output.products
            .withUnretained(self)
            .bind { owner, coins in
                let newCoin = coins.first(where: { $0.id == owner.product.id }) ?? Product()
                owner.update(product: newCoin)
            }
            .disposed(by: disposeBag)
        
        segmentView.rx.selectedSegmentIndex
            .bind(to: viewModel.input.segmentIndex)
            .disposed(by: disposeBag)
        
        buyButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let marketTradeVC = MarketBuyViewController(owner.mainVM, product: owner.product)
                marketTradeVC.modalPresentationStyle = .formSheet
                owner.navigationController?.present(marketTradeVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        sellButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let marketTradeVC = MarketSellViewController(owner.mainVM, product: owner.product)
                marketTradeVC.modalPresentationStyle = .formSheet
                owner.navigationController?.present(marketTradeVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.canSell
            .withUnretained(self)
            .bind { owner, bool in
                if bool {
                    owner.buttonStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
                    owner.buttonStackView.addArrangedSubview(owner.sellButton)
                    owner.buttonStackView.addArrangedSubview(owner.buyButton)
                } else {
                    owner.buttonStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
                    owner.buttonStackView.addArrangedSubview(owner.buyButton)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.coinCharts
            .withUnretained(self)
            .bind { owner, coinCharts in
                var data: [CandlestickData] = []
                for (_, coinChart) in coinCharts.enumerated() {
                    let barData = CandlestickData(time: .utc(timestamp: coinChart.timestamp),
                                                  open: coinChart.open,
                                                  high: coinChart.high,
                                                  low: coinChart.low,
                                                  close: coinChart.close,
                                                  color: nil,
                                                  borderColor: nil,
                                                  wickColor: nil)
                    
                    data.append(barData)
                }
                owner.candleSeries.setData(data: data)
            }
            .disposed(by: disposeBag)
    }
}
