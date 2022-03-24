//
//  HomeResponse.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import Foundation

// MARK: - ExchangeResponse
struct GetCurrenciesResponse: Codable {
    let country: String
    let description: String
    let image: String
    let symbol: String
    let rate: Double
    let sell: Double
    let buy: Double

    enum CodingKeys: String, CodingKey {
        case country
        case description
        case image, symbol, rate, sell, buy
    }
}
