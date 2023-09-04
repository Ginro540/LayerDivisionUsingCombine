//
//  UserEndpoint.swift
//  LayerDivisionUsingCombine
//
//  Created by 古賀貴伍社用 on 2023/08/30.
//

import Foundation

enum UserEndpoint: APIEndpoint {
    case getUsers(page:Int)
    var baseURL: URL {
        return URL(string: "https://example.com/api")!
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUsers:
            return ["Authorization": "Bearer TOKEN"]
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .getUsers(let page):
            return ["page": page, "limit": 10]
        }
    }
}
