//
//  UserInitialViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 20/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class UserInitialViewController: UIViewController, UITextFieldDelegate {

    let background = UIView()
    let keyView = privateKeysPage()
    let pinView = PinPage()
    private var pinCode: String?
    private var renderLabelsArray: [UILabel]?

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .lightGray
        self.view.backgroundColor?.withAlphaComponent(0.1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        addBackground()
        addKeyView()
        addPinView()
        renderLabelsArray = [pinView.code1, pinView.code2, pinView.code3, pinView.code4]
    }

    func addBackground() {
        self.view.addSubview(background)
        background.snp.makeConstraints { make -> Void in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        background.backgroundColor = .white
//        background.backgroundColor?.withAlphaComponent(0.5)

    }

    func addKeyView() {
        background.addSubview(keyView)
        keyView.initialView()
        keyView.usernameLabel.delegate = self
        keyView.generatePrivateKeyButton.addTarget(self, action: #selector(GenerateProvateKey), for: .touchUpInside)
    }

    func addPinView() {
        background.addSubview(pinView)
        pinView.initialView()
        pinView.hidedLabel.delegate = self
    }


    @objc func GenerateProvateKey() {
        let data = keyView.usernameLabel.text!.data(using: .utf8)!
        let secret = UIDevice.current.identifierForVendor!.uuidString.data(using: .utf8)!
        let hmac = data.authenticationCode(secretKey: secret).base64EncodedString()
        addHashKey(key: hmac)
    }

    func addHashKey(key: String) {
        if (keyChainExtension.addKeyChain(account: keyChainExtension.account.privateKey.rawValue, key: key) == 0) {
            alertMessage(title: "Success", message: "Generate private Key successful") { () -> Void in
                UIView.animate(withDuration: 0.5, animations: {
                    self.keyView.snp.updateConstraints { make -> Void in
                        make.centerX.equalToSuperview().offset(UIScreen.main.bounds.width)
                    }
                    self.pinView.snp.updateConstraints { make -> Void in
                        make.centerX.equalToSuperview().offset(0)
                    }
                    self.background.layoutIfNeeded()
                    self.pinView.hidedLabel.becomeFirstResponder()
                })
                self.pinView.hidedLabel.addTarget(self, action: #selector(self.inputGet), for: .editingChanged)
            }
        } else {
            alertMessage(title: "Faild", message: "Name exited") { () -> Void in

            }
        }
    }

    func setPinCode(code: String) {
        if (keyChainExtension.addKeyChain(account: keyChainExtension.account.pinCode.rawValue, key: code) == 0) {
            alertMessage(title: "Success", message: "Pin code creaction successful") { () -> Void in
                self.finishAll()
            }

        }
    }

    func conformPinCode() {
        self.pinCode = pinView.hidedLabel.text
        pinView.hidedLabel.text = ""
        pinView.notionLabel.text = "Comform your pin code"
    }

    func alertMessage(title: String, message: String, callback: @escaping () -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.view.window?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
            callback()
        }
    }

    func renderLabels() {
        let str: String = self.pinView.hidedLabel.text!
        for i in 0...3 {
            if (i <= str.count - 1) {
                self.renderLabelsArray![i].text = String(str[str.index(str.startIndex, offsetBy: i)])
            } else {
                self.renderLabelsArray![i].text = ""
            }
        }
    }

    func finishAll() {
        self.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.pinView.hidedLabel) {
            return textField.text!.count < 4
        }
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if (textField == self.pinView.hidedLabel) {
            let currentLength = textField.text!.count - range.length + string.count
            return (currentLength <= 4)
        }
        return true
    }

    @objc func inputGet() {
        renderLabels()
        print("value change", self.pinView.hidedLabel.text!)
        if (self.pinView.hidedLabel.text!.count == 4) {
            if (self.pinCode == nil) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    self.conformPinCode()
                    self.renderLabels()
                }
            } else {
                if (self.pinView.hidedLabel.text! == self.pinCode!) {
                    self.setPinCode(code: pinCode!)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        self.pinView.hidedLabel.text = ""
                        let shake = CAKeyframeAnimation(keyPath: "position.x")
                        shake.values = [0, -10, 0, 10, 0]
                        shake.isAdditive = true
                        shake.duration = 0.3
                        self.pinView.notionLabel.layer.add(shake, forKey: "shake")
                        self.renderLabels()
                    }
                }
            }
        }
    }
}

