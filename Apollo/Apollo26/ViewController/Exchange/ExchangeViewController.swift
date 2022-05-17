//
//  ExchangeViewController.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import GoogleMobileAds

class ExchangeViewController: UIViewController, GADFullScreenContentDelegate {
    var mainVM: MainViewModel!
    let viewModel = ExchangeViewModel()
    var disposeBag = DisposeBag()
    
    var titleLabel = UILabel().then {
        $0.text = "현재 KRW"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.body
    }
    var priceLabel = UILabel().then {
        $0.text = "0원"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.largeTitle
    }
    var adTitleLabel = UILabel().then {
        $0.text = "오늘의 광고"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.body
    }
    var adCountLabel = UILabel().then {
        $0.text = "1/5"
        $0.textColor = Const.Color.black
        $0.font = Const.Font.largeTitle
    }
    
    var adButton1 = ConfirmButton(text: "광고보고 +10%")
    var adButton2 = ConfirmButton(text: "광고보고 +100,000원")
    
    var buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Const.Color.white
        setNavigation()
        setView()
        setBind()
        
        GADRewardedAd.load(
            withAdUnitID: Secret.Key.fullAdmobId, request: GADRequest()
        ) { (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            print("Loading Succeeded")
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.refresh()
    }
}

extension ExchangeViewController {
    func setNavigation() {
        navigationItem.title = "환전소"
    }
    
    func setView() {
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(adTitleLabel)
        view.addSubview(adCountLabel)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(adButton1)
        buttonStackView.addArrangedSubview(adButton2)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        adTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        adCountLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            adTitleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            adTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            adTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            adCountLabel.topAnchor.constraint(equalTo: adTitleLabel.bottomAnchor),
            adCountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            adCountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    func setBind() {
        adButton1.rx.tap
            .map { true }
            .withUnretained(self)
            .bind { owner, bool in
                owner.viewModel.input.isClickAdButton.onNext(bool)
                if owner.viewModel.output.canAd.value {
                    if let ad = owner.rewardedAd {
                          ad.present(fromRootViewController: self) {
                            let reward = ad.adReward
                            print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                              owner.viewModel.input.watchedAd1.onNext(true)
                              owner.viewModel.refresh()
                          }
                        }
                }
            }
            .disposed(by: disposeBag)
        adButton2.rx.tap
            .map { true }
            .withUnretained(self)
            .bind { owner, bool in
                owner.viewModel.input.isClickAdButton.onNext(bool)
                if owner.viewModel.output.canAd.value {
                    if let ad = owner.rewardedAd {
                          ad.present(fromRootViewController: self) {
                            let reward = ad.adReward
                            print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                              owner.viewModel.input.watchedAd2.onNext(true)
                              owner.viewModel.refresh()
                          }
                        }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.krwPrice
            .withUnretained(self)
            .bind { owner, price in
                owner.priceLabel.text = String(price.round2()).insertComma + "원"
            }
            .disposed(by: disposeBag)
        
        viewModel.output.adCount
            .withUnretained(self)
            .bind { owner, count in
                owner.adCountLabel.text = "\(count)/5"
            }
            .disposed(by: disposeBag)
    }
}

extension ExchangeViewController {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}
