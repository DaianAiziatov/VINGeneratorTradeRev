//
//  RandomVinProvider.swift
//  VINGenerator
//
//  Created by Daian Aziatov on 2019-12-03.
//  Copyright © 2019 Daian Aziatov. All rights reserved.
//

import Foundation

protocol RandomVinProviding {
    func getRandomVIN(completion: @escaping(_ VIN: String?) -> Void)
}

struct RandomVinProvider: RandomVinProviding {
    private let randomCachedVinURLString = "https://tr-chrome.npa.traderev.com/chrome/vehicle/description/randomVin"
    func getRandomVIN(completion: @escaping(_ VIN: String?) -> Void) {
        guard let randomCachedVinURL = URL(string: randomCachedVinURLString) else {
            completion(nil)
            return
        }
        let session = URLSession.shared
        session.dataTask(with: randomCachedVinURL, completionHandler: { data, response, error in
            if let data = data,
                let vin = String(data: data, encoding: .utf8) {
                completion(vin)
            } else {
                completion(nil)
            }
        }).resume()
    }
}
