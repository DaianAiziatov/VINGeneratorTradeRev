//
//  RandomVinGeneratorNSViewController.swift
//  VINGenerator-mac
//
//  Created by Daian Aziatov on 2020-01-13.
//  Copyright © 2020 Daian Aziatov. All rights reserved.
//

import Cocoa

class RandomVinGeneratorNSViewController: NSViewController, RandomVinLoader {

    @IBOutlet weak var barcodeTypeSegmentedControl: NSSegmentedControl!
    @IBOutlet weak var qrCodeImageView: NSImageView!
    @IBOutlet weak var vinDetailsLabel: NSTextField! {
        didSet {
            vinDetailsLabel.isSelectable = true
        }
    }

    @IBOutlet weak var barcodeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var barcodeHeightConstraint: NSLayoutConstraint!

    struct Sizes {
        struct QRCode {
            static let width: CGFloat = 200
        }

        struct Barcode {
            static let width: CGFloat = 400
        }
    }
    
    private var isQRCode: Bool {
        return barcodeTypeSegmentedControl.selectedSegment == 0
    }
    private var currentVin: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRandomVin()
    }
    
    @IBAction func didTapReloadButton(_ sender: NSButton) {
        loadRandomVin()
    }
    
    @IBAction func didChangeBarcodeType(_ sender: NSSegmentedControl) {
        guard let currentVin = currentVin else { return }
        setBarcode(for: currentVin)
    }

    private func copyToClipBoard(textToCopy: String) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(textToCopy, forType: .string)
    }

    private func setBarcode(for vin: String) {
        let qrCodeImage = BarcodeGenerator().generateBarcode(from: vin, isQRCode: isQRCode)
        qrCodeImageView.image = qrCodeImage
        barcodeWidthConstraint.constant = isQRCode ? Sizes.QRCode.width : Sizes.Barcode.width
    }
}

extension RandomVinGeneratorNSViewController: FromVinDecodeResponseUISetuping {
    func setupUI(with vinDecodeResponse: VINDecodeResponse, vin: String) {
        currentVin = vin
        DispatchQueue.main.async {
            self.copyToClipBoard(textToCopy: vin)
            self.vinDetailsLabel.stringValue = "\(vin)\n\(vinDecodeResponse.carDetails)"
            self.setBarcode(for: vin)
        }
    }
}

extension RandomVinGeneratorNSViewController: GenericErrorShowable {
    func showError() {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Something went wrong"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
