//
//  RandomVinGeneratorViewController.swift
//  VINGenerator
//
//  Created by Daian Aziatov on 2019-12-03.
//  Copyright © 2019 Daian Aziatov. All rights reserved.
//

import UIKit

class RandomVinGeneratorViewController: UIViewController, RandomVinLoader {

    private var qrCodeImageView: UIImageView!
    private var reloadButton: UIButton!
    private var vinDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeImageView = UIImageView(image: UIImage(named: "placeholder"))
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qrCodeImageView)
        reloadButton = UIButton(type: .system)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reloadButton)
        vinDescriptionLabel = UILabel()
        vinDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vinDescriptionLabel)
        view.backgroundColor = .white
        setupImageView()
        setupLabel()
        setupButton()
        loadRandomVin()
    }

    @objc
    func didTapReloadButton() {
        loadRandomVin()
    }

    private func setupLabel() {
        vinDescriptionLabel.numberOfLines = 0
        vinDescriptionLabel.textAlignment = .center
        let trailingLabelConstraint = NSLayoutConstraint(item: vinDescriptionLabel as Any,
                                                         attribute: .trailing,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .trailing,
                                                         multiplier: 1,
                                                         constant: 15)
        let leadingLabelConstraint = NSLayoutConstraint(item: vinDescriptionLabel as Any,
                                                         attribute: .leading,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .leading,
                                                         multiplier: 1,
                                                         constant: -15)
        let topLabelConstraint = NSLayoutConstraint(item: vinDescriptionLabel as Any,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: qrCodeImageView,
                                                     attribute: .bottom,
                                                     multiplier: 1,
                                                     constant: 15)
        view.addConstraints([trailingLabelConstraint, leadingLabelConstraint, topLabelConstraint])
    }

    private func setupButton() {
        reloadButton.setTitle("Reload", for: .normal)
        reloadButton.addTarget(self, action: #selector(didTapReloadButton), for: .touchUpInside)
        let centerXButtonConstraint = NSLayoutConstraint(item: reloadButton as Any,
                                                         attribute: .centerX,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .centerX,
                                                         multiplier: 1,
                                                         constant: 0)
        let topButtonConstraint = NSLayoutConstraint(item: reloadButton as Any,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: vinDescriptionLabel,
                                                     attribute: .bottom,
                                                     multiplier: 1,
                                                     constant: 15)
        view.addConstraints([centerXButtonConstraint, topButtonConstraint])
    }

    private func setupImageView() {
        let centerXImageViewConstraint = NSLayoutConstraint(item: qrCodeImageView as Any,
                                                            attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .centerX,
                                                            multiplier: 1,
                                                            constant: 0)
        let centerYImageViewConstraint = NSLayoutConstraint(item: qrCodeImageView as Any,
                                                            attribute: .centerY,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .centerY,
                                                            multiplier: 1,
                                                            constant: 0)
        let widthImageViewConstraint = NSLayoutConstraint(item: qrCodeImageView as Any,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1,
                                                            constant: 200)
        let heightImageViewConstraint = NSLayoutConstraint(item: qrCodeImageView as Any,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .notAnAttribute,
                                                            multiplier: 1,
                                                            constant: 200)
        view.addConstraints([centerXImageViewConstraint, centerYImageViewConstraint, widthImageViewConstraint, heightImageViewConstraint])
    }
}

extension RandomVinGeneratorViewController: FromVinDecodeResponseUISetuping {
    func setupUI(with vinDecodeResponse: VINDecodeResponse, vin: String) {
        let qrCodeImage = QRCodeGenerator().generateQRCode(from: vin)
        UIPasteboard.general.string = vin
        DispatchQueue.main.async {
            self.vinDescriptionLabel.text = "\(vin)\n\(vinDecodeResponse.carDetails)"
            self.qrCodeImageView.image = qrCodeImage
        }
    }
}

extension RandomVinGeneratorViewController: GenericErrorShowable {
    func showError() {
        let alertController = UIAlertController(title: nil, message: "Something went wrong", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
