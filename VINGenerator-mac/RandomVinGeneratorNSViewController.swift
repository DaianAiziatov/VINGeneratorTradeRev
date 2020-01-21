//
//  RandomVinGeneratorNSViewController.swift
//  VINGenerator-mac
//
//  Created by Daian Aziatov on 2020-01-13.
//  Copyright © 2020 Daian Aziatov. All rights reserved.
//

import Cocoa

class RandomVinGeneratorNSViewController: NSViewController {

    @IBOutlet weak var barcodeTypeSegmentedControl: NSSegmentedControl!
    @IBOutlet weak var barcodeImageView: NSImageView!
    @IBOutlet weak var vinDetailsLabel: NSTextField!
    @IBOutlet weak var barcodeWidthConstraint: NSLayoutConstraint!

    private var isQRCode: Bool {
        return barcodeTypeSegmentedControl.selectedSegment == 0
    }

    var helper: RandomVinGeneratorNSViewControllerHelper = RandomVinGeneratorNSViewControllerHelper()

    struct Sizes {
        struct QRCode {
            static let width: CGFloat = 200
        }

        struct Barcode {
            static let width: CGFloat = 400
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vinDetailsLabel.isSelectable = true
        helper.delegate = self
        helper.loadRandomVin()
    }
    
    @IBAction func didTapReloadButton(_ sender: NSButton) {
        helper.loadRandomVin()
    }
    
    @IBAction func didChangeBarcodeType(_ sender: NSSegmentedControl) {
        helper.didChangeBarcodeType(to: isQRCode ? .qr : .bar)
    }

    private func setBarcode(with image: NSImage?) {
        barcodeImageView.image = image
        barcodeWidthConstraint.constant = isQRCode ? Sizes.QRCode.width : Sizes.Barcode.width
    }
}

extension RandomVinGeneratorNSViewController: RandomVinGeneratorNSViewControllerHelperDelegate {
    func setupUI(with vinDecodeResponse: VINDecodeResponse, vin: String, image: NSImage?) {
        DispatchQueue.main.async {
            self.vinDetailsLabel.stringValue = "\(vin)\n\(vinDecodeResponse.carDetails)"
            self.setBarcode(with: image)
        }
    }

    func updateBarcode(with image: NSImage?) {
        setBarcode(with: image)
    }

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
