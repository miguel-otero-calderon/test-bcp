//
//  HomeVidewModel.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import Foundation
import UIKit

protocol HomeViewModelType: AnyObject {
    func getCurrrencies()
    var delegate: HomeViewModelDelegate? { get set }
}

protocol HomeViewModelDelegate: AnyObject {
    func getCurrrencies(currencies: [GetCurrenciesResponse]? , error: Error?)
}

class HomeViewModel: HomeViewModelType {
    var currencyService: CurrencyServiceType
    var delegate: HomeViewModelDelegate?
    
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
