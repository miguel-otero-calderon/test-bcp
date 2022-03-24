//
//  HomeEndPoint.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import Foundation
import Alamofire

enum HomeEndPoint: EndPoint {
    
    case getCurrencies
    
    var baseURL: String {
        return "https://684c6a40-a629-4863-9b20-6d5cb8a1aba4.mock.pstmn.io" //my postman mock
    }
    
    var path: String {
        switch self {
        case .getCurrencies:
            return "/getCurrencies"
        }
    }
    
    var metohd: HTTPMethod {
        switch self {
        case .getCurrencies:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getCurrencies:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getCurrencies:
            return nil
        }
    }
}
