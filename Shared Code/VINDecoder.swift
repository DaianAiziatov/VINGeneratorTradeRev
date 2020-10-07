//
//  VINDecoder.swift
//  VINGenerator
//
//  Created by Daian Aziatov on 2019-12-03.
//  Copyright © 2019 Daian Aziatov. All rights reserved.
//

import Foundation

protocol VINDecoding {
    func decode(vin: String, completion: @escaping((VINDecodeResponse?) -> Void))
}

struct VINDecoder: VINDecoding {

    struct CallerCredentials: Encodable {
        let accountNumber = "string"
        let accountSecret = "string"
        let region = "CA"
        let service = "string"
    }

    private let vinDescriptionURLString = "https://tr-chrome.npa.traderev.com/chrome/vehicle/description?vin="

    func decode(vin: String, completion: @escaping((VINDecodeResponse?) -> Void)) {
        guard let vinDescriptionURL = URL(string: vinDescriptionURLString + vin) else {
            completion(nil)
            return
        }
        var urlRequest = URLRequest(url: vinDescriptionURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(CallerCredentials())
        let session = URLSession.shared
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let data = data,
                let decodedResponse = try? JSONDecoder().decode(VINDecodeResponse.self, from: data) {
                completion(decodedResponse)
            } else {
                completion(nil)
            }
        }).resume()
    }
}
