//
//  TradeTableViewAdaptor.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/14.
//

import UIKit

class TradeTableViewAdaptor: NSObject, UITableViewDelegate, UITableViewDataSource {
    weak var superViewController: UIViewController!
    weak var mainVM: MainViewModel!
    var trades: [Trade] = []
    var products: [Product] = []
    
    func update(_ superViewController: UIViewController, mainVM: MainViewModel, trades: [Trade]) {
        self.superViewController = superViewController
        self.mainVM = mainVM
        self.trades = trades
    }
    
    func updateProducts(products: [Product]) {
        self.products = products
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return trades.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TradeTableViewCell.identifier, for: indexPath) as! TradeTableViewCell
        
        cell.updateTrade(trade: trades[indexPath.section])
        if let product = products.first(where: { $0.type == trades[indexPath.section].productType && $0.name == trades[indexPath.section].name }) {
            cell.updateProduct(product: product)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TradeTableViewCell
        let storeDetailVC = MarketDetailViewController(mainVM, product: cell.product)
        superViewController.navigationController?.pushViewController(storeDetailVC, animated: true)
    }
}
