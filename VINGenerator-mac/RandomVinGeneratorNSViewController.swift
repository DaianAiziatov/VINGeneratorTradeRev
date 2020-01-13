//
//  RandomVinGeneratorNSViewController.swift
//  VINGenerator-mac
//
//  Created by Daian Aziatov on 2020-01-13.
//  Copyright © 2020 Daian Aziatov. All rights reserved.
//

import Cocoa

class RandomVinGeneratorNSViewController: NSViewController, RandomVinLoader {

    @IBOutlet weak var qrCodeImageView: NSImageView!
    @IBOutlet weak var vinDetailsLabel: NSTextField! {
        didSet {
            vinDetailsLabel.isSelectable = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRandomVin()
    }
    
    @IBAction func didTapReloadButton(_ sender: NSButton) {
        loadRandomVin()
    }

    private func copyToClipBoard(textToCopy: String) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(textToCopy, forType: .string)
    }
}

extension RandomVinGeneratorNSViewController: FromVinDecodeResponseUISetuping {
    func setupUI(with vinDecodeResponse: VINDecodeResponse, vin: String) {
        let qrCodeImage = QRCodeGenerator().generateQRCode(from: vin)
        DispatchQueue.main.async {
            self.copyToClipBoard(textToCopy: vin)
            self.vinDetailsLabel.stringValue = "\(vin)\n\(vinDecodeResponse.carDetails)"
            self.qrCodeImageView.image = qrCodeImage
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
