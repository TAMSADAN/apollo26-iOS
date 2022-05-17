//
//  MainViewController.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import UIKit

class MainViewController: UITabBarController {
    let mainVM = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        let tabStore = UINavigationController(rootViewController: MarketViewController(mainVM))
        let tabStoreBarItem = UITabBarItem(title: "거래소", image: UIImage(systemName: "bitcoinsign.circle.fill"), selectedImage: UIImage(named: "bitcoinsign.circle.fill"))
        let tabHistory = UINavigationController(rootViewController: HistoryViewController(mainVM))
        let tabHistoryBarItem = UITabBarItem(title: "내역", image: UIImage(systemName: "bag.fill"), selectedImage: UIImage(named: "bag.fill"))
        let tabExchange = UINavigationController(rootViewController: ExchangeViewController())
        let tabExchangeBarItem = UITabBarItem(title: "환전소", image: UIImage(systemName: "wonsign.circle.fill"), selectedImage: UIImage(named: "wonsign.circle.fill"))
        
        
        tabStore.tabBarItem = tabStoreBarItem
        tabHistory.tabBarItem = tabHistoryBarItem
        tabExchange.tabBarItem = tabExchangeBarItem
        
        self.viewControllers = [tabStore, tabHistory, tabExchange]
    }
}
