//
//  ViewController.swift
//  URLSession1111
//
//  Created by Айгерим on 26.08.2024.
//

import UIKit

class ViewController: UIViewController {
    private var label = UILabel()
    private var networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        label.frame = CGRect(x: 20, y: 300, width: UIScreen.main.bounds.width - 40, height: 40)
        view.addSubview(label)
        networkManager.request { result in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let joke):
                    self.label.text = joke
                case .failure(let error):
                    self.label.text = error.description
                }
                
            }
        }
        
    }
}
