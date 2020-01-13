//
//  RandomVinLoading.swift
//  VINGenerator
//
//  Created by Daian Aziatov on 2020-01-13.
//  Copyright © 2020 Daian Aziatov. All rights reserved.
//

import Foundation

protocol RandomVinLoader {
    func loadRandomVin()
}

extension RandomVinLoader where Self: GenericErrorShowable & FromVinDecodeResponseUISetuping {
    func loadRandomVin() {
        RandomVinProvider().getRandomVIN { vin in
            if let vin = vin {
                self.decode(vin: vin)
            } else {
                self.showError()
            }
        }
    }

    private func decode(vin: String) {
        VINDecoder().decode(vin: vin) { vinDecodeResponse in
            if let vinDecodeResponse = vinDecodeResponse {
                self.setupUI(with: vinDecodeResponse, vin: vin)
            } else {
                self.showError()
            }
        }
    }
}
