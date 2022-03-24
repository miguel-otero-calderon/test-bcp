//
//  HomeVidewModel.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import Foundation
import UIKit

protocol HomeVidewModelType: AnyObject {
    func getCurrrencies()
}

protocol BookViewModelDelegate: AnyObject {
    func getCurrrencies(currencies: [GetCurrenciesResponse]? , error: Error?)
}

class HomeVidewModel: HomeVidewModelType {
    var currencyService: CurrencyServiceType
    var delegate: BookViewModelDelegate?
    
    init(currrencyService: CurrencyServiceType) {
        self.currencyService = currrencyService
    }
    
    func getCurrrencies() {
        self.currencyService.getCurrrencies(completion: { response, error in
            
            if let error = error {
                self.delegate?.getCurrrencies(currencies: nil, error: error)
                return
            }
            
            if let response = response {
                self.delegate?.getCurrrencies(currencies: response, error: nil)
            }
        })
    }
}
