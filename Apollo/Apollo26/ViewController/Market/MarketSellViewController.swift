//
//  MarketSellViewController.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/17.
//

import UIKit
import RxSwift
import RxRelay
import Then

class MarketSellViewController: UIViewController {
    weak var mainVM: MainViewModel!
    var disposeBag = DisposeBag()
    var viewModel: MarketSellViewModel!
    var product: Product!
    var tradeType: TradeType!
    
    var productImageBackgroundView = UIView().then {
        $0.backgroundColor = Const.Color.systemGray6
        $0.layer.cornerRadius = 18
    }
    var productImageView = UIImageView()
    var inputCountLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = Const.Color.black
        $0.font = Const.Font.largeTitle
    }
    var outputPriceLabel = UILabel().then {
        $0.text = "0원"
        $0.textAlignment = .center
        $0.textColor = Const.Color.darkGray
        $0.font = Const.Font.subheadline
    }
    var laterTitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = Const.Color.black
        $0.font = Const.Font.footnote
    }
    var laterTradeCountLabel = UILabel().then {
        $0.text = "194,596,999원"
        $0.textAlignment = .center
        $0.textColor = Const.Color.black
        $0.font = Const.Font.subheadline
    }
    var messageLabel = UILabel().then {
        $0.text = "거래 가능합니다."
        $0.textAlignment = .center
        $0.textColor = Const.Color.black
        $0.font = Const.Font.caption1
    }
    var numberPad = NumberPadView()
    var rateSelectorView = RateSelectorView()
    var confirmButton = ConfirmButton(text: "판매할래요")
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ mainVM: MainViewModel, product: Product) {
        super.init(nibName: nil, bundle: nil)
        self.mainVM = mainVM
        self.viewModel = MarketSellViewModel(product: product)
        update(product: product)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Const.Color.white
        setView()
        setBind()
    }
}

extension MarketSellViewController {
    func update(product: Product) {
        self.product = product
        self.productImageView.downloaded(from: product.imageUrl)
        viewModel.update(product: product)
    }
    
    func setView() {
        laterTitleLabel.text = "거래후 \(product.symbol.uppercased()) 수량"
        
        view.addSubview(productImageBackgroundView)
        view.addSubview(productImageView)
        view.addSubview(inputCountLabel)
        view.addSubview(outputPriceLabel)
        view.addSubview(laterTitleLabel)
        view.addSubview(laterTradeCountLabel)
        view.addSubview(messageLabel)
        view.addSubview(rateSelectorView)
        view.addSubview(numberPad)
        view.addSubview(confirmButton)
        
        productImageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        inputCountLabel.translatesAutoresizingMaskIntoConstraints = false
        outputPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        laterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        laterTradeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        rateSelectorView.translatesAutoresizingMaskIntoConstraints = false
        numberPad.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            productImageBackgroundView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            productImageBackgroundView.heightAnchor.constraint(equalToConstant: 36),
            productImageBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            
            productImageView.topAnchor.constraint(equalTo: productImageBackgroundView.topAnchor, constant: 3),
            productImageView.leadingAnchor.constraint(equalTo: productImageBackgroundView.leadingAnchor, constant: 3),
            productImageView.trailingAnchor.constraint(equalTo: productImageBackgroundView.trailingAnchor, constant: -3),
            productImageView.bottomAnchor.constraint(equalTo: productImageBackgroundView.bottomAnchor, constant: -3),
            
            inputCountLabel.topAnchor.constraint(equalTo: productImageBackgroundView.bottomAnchor, constant: 15),
            inputCountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            inputCountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            outputPriceLabel.topAnchor.constraint(equalTo: inputCountLabel.bottomAnchor, constant: 5),
            outputPriceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            outputPriceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            laterTitleLabel.topAnchor.constraint(equalTo: outputPriceLabel.bottomAnchor, constant: 80),
            laterTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            laterTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            laterTradeCountLabel.topAnchor.constraint(equalTo: laterTitleLabel.bottomAnchor, constant: 5),
            laterTradeCountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            laterTradeCountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: rateSelectorView.topAnchor, constant: -10),
            
            rateSelectorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            rateSelectorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            rateSelectorView.bottomAnchor.constraint(equalTo: numberPad.topAnchor, constant: -10),
            rateSelectorView.heightAnchor.constraint(equalToConstant: 30),
            
            numberPad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            numberPad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            numberPad.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -30),
            numberPad.heightAnchor.constraint(equalToConstant: 250),
            
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            confirmButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    func setBind() {
        mainVM.output.products
            .withUnretained(self)
            .bind { owner, coins in
                let coin = coins.first(where: { $0.id == owner.product.id }) ?? Product()
                owner.update(product: coin)
            }
            .disposed(by: disposeBag)
        
        let numberPadTexts = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "C"]
        
        for i in 0..<12 {
            numberPad.numberPadButtons[i].rx.tap
                .map { numberPadTexts[i] }
                .bind(to: viewModel.input.numberPadText)
                .disposed(by: disposeBag)
        }
        
        rateSelectorView.rateSelectorButton1.rx.tap
            .map { 0.25 }
            .bind(to: viewModel.input.selectedRate)
            .disposed(by: disposeBag)
        
        rateSelectorView.rateSelectorButton2.rx.tap
            .map { 0.5 }
            .bind(to: viewModel.input.selectedRate)
            .disposed(by: disposeBag)
        
        rateSelectorView.rateSelectorButton3.rx.tap
            .map { 0.75 }
            .bind(to: viewModel.input.selectedRate)
            .disposed(by: disposeBag)
        
        rateSelectorView.rateSelectorButton4.rx.tap
            .map { 1.0 }
            .bind(to: viewModel.input.selectedRate)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map {
                true
            }
            .bind(to: viewModel.input.isConfirmButtonClick)
            .disposed(by: disposeBag)
        
        viewModel.output.numberPadText
            .withUnretained(self)
            .bind { owner, text in
                owner.inputCountLabel.text = text.insertComma + "개"
            }
            .disposed(by: disposeBag)
        
        viewModel.output.outputPrice
            .withUnretained(self)
            .bind { owner, price in
                owner.outputPriceLabel.text = String(price.round4()).insertComma + "원"
            }
            .disposed(by: disposeBag)
        
        viewModel.output.laterTradeCount
            .withUnretained(self)
            .bind { owner, count in
                owner.laterTradeCountLabel.text = String(count.round4()).insertComma + "개"
            }
            .disposed(by: disposeBag)
        
        viewModel.output.message
            .withUnretained(self)
            .bind { owner, message in
                if message == "거래 가능합니다." {
                    owner.messageLabel.textColor = Const.Color.green
                } else if message == "수량이 부족합니다." {
                    owner.messageLabel.textColor = Const.Color.red
                } else {
                    owner.messageLabel.textColor = Const.Color.black
                }
                owner.messageLabel.text = message
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isSelled
            .withUnretained(self)
            .bind { owner, bool in
                if bool {
                    Log("isSelled bool == true")
                    owner.dismiss(animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }
}
