//
//  StoreTableViewAdaptor.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import UIKit

class ProductTableViewAdaptor: NSObject, UITableViewDelegate, UITableViewDataSource {
    weak var superViewController: UIViewController!
    weak var mainVM: MainViewModel!
    var products: [Product] = []
    
    func update(_ superViewController: UIViewController, mainVM: MainViewModel, products: [Product]) {
        self.superViewController = superViewController
        self.mainVM = mainVM
        self.products = products
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        
        cell.update(product: products[indexPath.section])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log(indexPath)
        let cell = tableView.cellForRow(at: indexPath) as! ProductTableViewCell
        let storeDetailVC = MarketDetailViewController(mainVM, product: cell.product)
        superViewController.navigationController?.pushViewController(storeDetailVC, animated: true)
    }
}
