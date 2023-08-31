//
//  ArticlesViewModel.swift
//  LayerDivisionUsingCombine
//
//  Created by 古賀貴伍社用 on 2023/08/23.
//

import Foundation
import Combine

protocol UsersViewModelInputs {
    var fetchUsersTrigger: PassthroughSubject <Void, Never> { get }
}
protocol UsersViewModelOutputs {
    var users: AnyPublisher<[User], Never> { get }
}

protocol UsersViewModelType {
    var input:  UsersViewModelInputs { get }
    var output: UsersViewModelOutputs { get }
}

final class UsersViewModel: UsersViewModelType, UsersViewModelInputs, UsersViewModelOutputs {
    
    var input: UsersViewModelInputs { return self }
    var output: UsersViewModelOutputs { return self }
    
    let fetchUsersTrigger = PassthroughSubject<Void, Never> ()
    var users: AnyPublisher<[User], Never> {
        return $_users.eraseToAnyPublisher()
    }
    
    private let api: userServiceProtocol
    private var cancellable: [AnyCancellable] = []

    @Published private var _users: [User] = []
    
    init(api: userServiceProtocol){
        self.api = api
        fetchUsersTrigger
            .sink(
                receiveValue: { [weak self] in
                    self?.fetchUsers()
                }
            ).store(in: &cancellable)
    }
    
    private func fetchUsers() {
        self.api.getUsers()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion:  { completion in
                switch completion {
                case .finished:
                    // APIからの取得処理が「成功」した際に呼び出される処理
                    break
                case .failure(_): break
                    // APIからの取得処理が「失敗」した際に呼び出される処理
                }
                
            }, receiveValue: { [weak self] data in
                self?._users = data
            }).store(in: &cancellable)
    }
}
