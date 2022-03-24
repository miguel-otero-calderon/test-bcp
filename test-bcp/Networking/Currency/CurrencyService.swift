//
//  HomeService.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import Foundation
import Alamofire

protocol CurrencyServiceType {
    func getCurrrencies(completion: @escaping ([GetCurrenciesResponse]? ,Error? ) -> Void)
}

class CurrencyService: CurrencyServiceType {
    func getCurrrencies(completion: @escaping ([GetCurrenciesResponse]? ,Error? ) -> Void) {
        let endpoint = HomeEndPoint.getCurrencies
        
        AF.request( endpoint.toURL(), method: endpoint.metohd)
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        return
                    }
                    do {
                        let response = try JSONDecoder().decode([GetCurrenciesResponse].self, from: data)
                        completion(response, nil)
                    } catch {
                        completion(nil,error)
                    }
                case .failure(let error):
                    completion(nil,error)
                }
            }
    }
}
