//
//  QRCodeGenerator.swift
//  VINGenerator-mac
//
//  Created by Daian Aziatov on 2020-01-13.
//  Copyright © 2020 Daian Aziatov. All rights reserved.
//
import AppKit

struct BarcodeGenerator {
    func generateBarcode(from string: String, isQRCode: Bool) -> NSImage? {
        guard let data = string.data(using: isQRCode ? .utf8 : .ascii),
            let filter = getCIFilter(from: data, isQRcode: isQRCode),
            let ciimage = filter.outputImage else {
                return nil
        }
        let transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
        let ciImage = ciimage.transformed(by: transform)
        let imageRep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: imageRep.size)
        nsImage.addRepresentation(imageRep)
        return nsImage
    }

    private func getCIFilter(from data: Data, isQRcode: Bool) -> CIFilter? {
        return isQRcode ?
            CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage" : data, "inputCorrectionLevel": "L"]) :
            CIFilter(name: "CICode128BarcodeGenerator", parameters: ["inputMessage" : data])
    }
}
