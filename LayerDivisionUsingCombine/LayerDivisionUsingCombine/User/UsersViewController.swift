//
//  UsersViewController.swift
//  LayerDivisionUsingCombine
//
//  Created by 古賀貴伍社用 on 2023/09/01.
//

import Foundation
import UIKit
import Combine

class UserViewController: UIViewController {
    
    let viewModel = UsersViewModel(api: UserService())
    private var cancellable: [AnyCancellable] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.fetchUsersTrigger.send()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.output.users
            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                
                
                
                }
            )
            .store(in: &cancellable)
    }
    
    
}
