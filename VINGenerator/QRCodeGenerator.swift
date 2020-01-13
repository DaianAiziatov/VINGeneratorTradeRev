//
//  QRCodeGenerator.swift
//  VINGenerator
//
//  Created by Daian Aziatov on 2020-01-13.
//  Copyright © 2020 Daian Aziatov. All rights reserved.
//

import UIKit

struct QRCodeGenerator: QRCodeGenerating {
    func generateQRCode(from string: String) -> UIImage? {
        guard let data = string.data(using: .utf8),
            let filter = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage" : data, "inputCorrectionLevel": "L"]),
            let ciimage = filter.outputImage else {
                return nil
        }
        let transform = CGAffineTransform(scaleX: 20.0, y: 20.0)
        let image = ciimage.transformed(by: transform)
        return UIImage(ciImage: image)
    }
}
