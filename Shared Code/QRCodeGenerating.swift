//
//  QRCodeGenerating.swift
//  VINGenerator
//
//  Created by Daian Aziatov on 2019-12-03.
//  Copyright © 2019 Daian Aziatov. All rights reserved.
//

import Foundation

protocol QRCodeGenerating {
    associatedtype Image
    func generateQRCode(from string: String) -> Image?
}
