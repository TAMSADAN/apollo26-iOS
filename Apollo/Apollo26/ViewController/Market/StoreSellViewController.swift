//
//  StoreSellViewController.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import UIKit

class StoreSellViewController: UIViewController {
    weak var superViewController: UIViewController!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ superViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.superViewController = superViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Const.Color.mint
    }
}
