//
//  UserServiceProtocol.swift
//  LayerDivisionUsingCombine
//
//  Created by 古賀貴伍社用 on 2023/08/31.
//

import Foundation
import Combine

protocol userServiceProtocol {
    func getUsers(page:Int?) -> AnyPublisher<[User], Error>
}

class UserService: userServiceProtocol {
    let apiclient = URLSessionAPIClinet<UserEndpoint>()
    
    func getUsers(page:Int?) -> AnyPublisher<[User], Error> {
        return apiclient.request(endpoint: .getUsers(page: page ?? 0))
    }
}
