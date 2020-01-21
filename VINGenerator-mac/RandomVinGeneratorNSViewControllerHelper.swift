//
//  RandomVinGeneratorNSViewControllerHelper.swift
//  VINGenerator-mac
//
//  Created by Daian Aziatov on 2020-01-21.
//  Copyright © 2020 Daian Aziatov. All rights reserved.
//

import Cocoa

protocol RandomVinGeneratorNSViewControllerHelperDelegate: AnyObject {
    func showError()
    func setupUI(with: VINDecodeResponse, vin: String, image: NSImage?)
    func updateBarcode(with image: NSImage?)
}

class RandomVinGeneratorNSViewControllerHelper: RandomVinLoadable {
    weak var delegate: RandomVinGeneratorNSViewControllerHelperDelegate?

    private var randomVinProvider: RandomVinProviding
    private var vinDecoder: VINDecoding
    private var barcodeGenerator: BarcodeGenerating

    private var currentVin: String?
    private var selectedBarcodeType: Barcodetype = .qr

    init(randomVinProvider: RandomVinProviding = RandomVinProvider(),
         vinDecoder: VINDecoding = VINDecoder(),
         barcodeGenerator: BarcodeGenerating = BarcodeGenerator()) {
        self.randomVinProvider = randomVinProvider
        self.vinDecoder = vinDecoder
        self.barcodeGenerator = barcodeGenerator
    }

    func loadRandomVin() {
        randomVinProvider.getRandomVIN { vin in
            if let vin = vin {
                self.currentVin = vin
                self.copyToClipBoard(textToCopy: vin)
                self.decode(vin: vin)
            } else {
                self.delegate?.showError()
            }
        }
    }

    private func decode(vin: String) {
        vinDecoder.decode(vin: vin) { vinDecodeResponse in
            if let vinDecodeResponse = vinDecodeResponse {
                let barcodeImage = self.getBarcodeImage(from: vin)
                self.delegate?.setupUI(with: vinDecodeResponse, vin: vin, image: barcodeImage)
            } else {
                self.delegate?.showError()
            }
        }
    }

    private func getBarcodeImage(from vin: String) -> NSImage? {
        let isQRCode = selectedBarcodeType == .qr
        return barcodeGenerator.generateBarcode(from: vin, isQRCode: isQRCode)
    }

    func copyToClipBoard(textToCopy: String) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(textToCopy, forType: .string)
    }

    func didChangeBarcodeType(to type: Barcodetype) {
        guard let currentVin = currentVin else { return }
        selectedBarcodeType = type
        let barcodeImage = getBarcodeImage(from: currentVin)
        delegate?.updateBarcode(with: barcodeImage)
    }
}

enum Barcodetype {
    case qr, bar
}
