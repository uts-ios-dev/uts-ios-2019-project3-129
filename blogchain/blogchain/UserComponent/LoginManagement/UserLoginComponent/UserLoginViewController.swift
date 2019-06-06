//
//  UserLoginViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 20/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit
import LocalAuthentication

class UserLoginViewController: UIViewController {

    let noteLabel = UILabel()
    let keysBoard = keyBoardComponent()
    let passwordBoard = passwordComponent()
    var context = LAContext()
    var callbackSuccess: (() -> ())?
    var callback4C: (() -> ())?
    var pinCode: String = "" {
        didSet {
            passwordBoard.updateLabel(content: pinCode)
            if (pinCode.count == 4) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.08) {
                    if(self.callback4C == nil){self.validation(sample: self.truePinCode!)}
                    else {self.callback4C!()}
                }
            }
        }
    }
    var rePinCode: String?
    var truePinCode: String?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .lightGray
        self.view.backgroundColor?.withAlphaComponent(0.2)
        truePinCode = keyChainExtension.pinCode
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialView()
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }

    func initialView() {
        addNoteLabel()
        addPasswordBoard()
        addKeyboard()
        bioAutho()
    }

    func addNoteLabel() {
        self.view.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { make -> Void in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        noteLabel.text = "Please enter your pin code"
        noteLabel.textColor = .blue
//        noteLabel.backgroundColor = .blue
        noteLabel.textAlignment = .center
    }

    func addPasswordBoard() {
        self.view.addSubview(passwordBoard)
        passwordBoard.snp.makeConstraints { make -> Void in
            make.top.equalTo(noteLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
//        passwordBoard.backgroundColor = .lightGray
        passwordBoard.initialView()
    }

    func addKeyboard() {
        self.view.addSubview(keysBoard)
        keysBoard.snp.makeConstraints { make -> Void in
            make.top.equalTo(passwordBoard.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(self.view.frame.width * 0.15)
            make.trailing.equalToSuperview().offset(-self.view.frame.width * 0.15)
            make.bottom.equalToSuperview()
        }
//        keysBoard.backgroundColor = .orange
        keysBoard.initialKeys()
        for arrOut in keysBoard.keysArray {
            for but in arrOut {
                but.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
            }
        }
    }

    func validation(sample: String) {
        if(self.pinCode == sample){
            if (self.callbackSuccess != nil){ self.callbackSuccess!() }
        } else {
            invalied()
        }
    }

    func invalied() {
        self.noteLabel.text = "Please try again"
        let shake = CAKeyframeAnimation(keyPath: "position.x")
        shake.values = [0, -10, 0, 10, 0]
        shake.isAdditive = true
        shake.duration = 0.3
        self.noteLabel.layer.add(shake, forKey: "shake")
        self.pinCode = ""
    }

    func selfDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    func onButtonPress(input: String) {
        self.pinCode = "\(self.pinCode)\(input)"
    }
    
    func changePinCode() {
        self.pinCode = ""
        self.noteLabel.text = "Enter your new pin code"
        self.callback4C = {
            self.rePinCode = self.pinCode
            self.pinCode = ""
            self.noteLabel.text = "Conform your pin code"
            self.callback4C = {
                self.callbackSuccess = {
                    _ = keyChainExtension.updateKeyChainItem(account: keyChainExtension.account.pinCode.rawValue, newKey: self.rePinCode!)
                    self.selfDismiss()
                }
                self.validation(sample: self.rePinCode!)
            }
        }
    }
    
    func bioAutho() {
        // Get a fresh context for each login. If you use the same context on multiple attempts
        //  (by commenting out the next line), then a previously successful authentication
        //  causes the next policy evaluation to succeed without testing biometry again.
        //  That's usually not what you want.
        context = LAContext()
        context.localizedCancelTitle = "Enter Username/Password"
        // First check if we have the needed hardware support.
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    // Move to the main thread because a state update triggers UI changes.
                    DispatchQueue.main.async { [unowned self] in
                        self.pinCode = self.truePinCode!
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    // Fall back to a asking for username and password.
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            // Fall back to a asking for username and password.
            // ...
        }
    }

    @objc func buttonPress(_ sender: UIButton?) {
        sender?.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.08) {
            sender?.backgroundColor = .clear
            self.onButtonPress(input: sender?.titleLabel?.text ?? "")
        }
    }
}
