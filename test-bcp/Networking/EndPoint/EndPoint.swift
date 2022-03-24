//
//  EndPoint.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import Foundation
import Alamofire

protocol EndPoint {
    var baseURL: String { get }
    var path: String { get }
    var metohd: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}
extension EndPoint {
    func toURL() -> URLConvertible {
        return baseURL + path
    }
}
