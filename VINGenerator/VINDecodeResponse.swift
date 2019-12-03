//
//  VINDecodeResponse.swift
//  VINGenerator
//
//  Created by Daian Aziatov on 2019-12-03.
//  Copyright © 2019 Daian Aziatov. All rights reserved.
//

import Foundation

struct VINDecodeResponse: Decodable {
    let modelYear: Int
    let division: String
    let modelName: String

    enum ContainerCodingKey: String, CodingKey {
        case vinDescription
    }

    enum CodingKeys: String, CodingKey {
        case modelYear
        case division
        case modelName
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ContainerCodingKey.self)
        let vinDescriptionValues = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .vinDescription)
        modelYear = try vinDescriptionValues.decode(Int.self, forKey: .modelYear)
        division = try vinDescriptionValues.decode(String.self, forKey: .division)
        modelName = try vinDescriptionValues.decode(String.self, forKey: .modelName)
    }
}
