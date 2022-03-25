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
    let symbol2: String
    let description2: String

    enum CodingKeys: String, CodingKey {
        case country
        case description
        case description2
        case image, symbol, rate, sell, buy
        case symbol2
    }
}
