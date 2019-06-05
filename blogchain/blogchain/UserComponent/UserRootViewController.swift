//
//  UserRootViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 18/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class UserRootViewController: UIViewController {
    
    private let keyLable = UILabel();
    private let keyHashLable = UILabel();
    let authorNameLabel = UILabel();
    private var key: String?;
    
    override func loadView() {
        super.loadView();
        self.title = "User Info";
        self.view.backgroundColor = .groupTableViewBackground;
        key = keyChainExtension.keyAddress;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addAuthorNameLabel();
        addHashKeyLabel();
        addResetPinCodeButton();
        if(key == nil) {
            let v = UserInitialViewController();
            v.modalPresentationStyle = .overCurrentContext;
            v.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3);
            v.finishAllCallBack = {self.authorNameLabel.text = Author;}
            self.parent?.present(v, animated: true, completion: nil);
        } else {
            //validation key code
            let v = UserLoginViewController()
            v.modalPresentationStyle = .overCurrentContext
            v.view.backgroundColor = UIColor(red: 100, green: 100, blue: 100, alpha: 0.4)
            v.callbackSuccess = {
                v.selfDismiss()
            }
            self.tabBarController?.present(v, animated: true, completion: nil)
        }
    }
    
    func addAuthorNameLabel() {
        let noteLabel = UILabel();
        let background = UIView();
        self.view.addSubview(background);
        background.snp.makeConstraints{ make -> Void in
            make.leading.trailing.equalToSuperview();
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(50);
            make.height.equalToSuperview().multipliedBy(0.1);
        }
        background.backgroundColor = .white;
        
        background.addSubview(noteLabel);
        noteLabel.snp.makeConstraints{ make -> Void in
            make.leading.equalToSuperview().offset(20);
            make.top.bottom.equalToSuperview();
            make.width.equalToSuperview().multipliedBy(0.3);
        }
        noteLabel.text = "Author Name";
        noteLabel.textColor = .black;
        
        background.addSubview(authorNameLabel);
        authorNameLabel.snp.makeConstraints{ make -> Void in
            make.leading.equalTo(noteLabel);
            make.trailing.equalToSuperview().offset(-20);
            make.top.bottom.equalToSuperview();
        }
        authorNameLabel.textAlignment = .right;
        authorNameLabel.text = Author;
        authorNameLabel.textColor = .black;
        print("sssssssssss+++++++++++++++++++++++++",Author);
    }
    
    func addHashKeyLabel() {
        let background = UIButton();
        self.view.addSubview(background);
        background.snp.makeConstraints{ make -> Void in
            make.leading.trailing.equalToSuperview();
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(200);
            make.height.equalToSuperview().multipliedBy(0.1);
        }
        background.backgroundColor = .white;
        background.setTitle("Check your private key", for: .normal);
        background.setTitleColor(.black, for: .normal);
        background.addTarget(self, action: #selector(showPrivateKeyButton), for: .touchUpInside);
    }
    
    func addResetPinCodeButton() {
        let background = UIButton();
        self.view.addSubview(background);
        background.snp.makeConstraints{ make -> Void in
            make.leading.trailing.equalToSuperview();
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(350);
            make.height.equalToSuperview().multipliedBy(0.1);
        }
        background.backgroundColor = .white;
        background.setTitle("Change pin code", for: .normal);
        background.setTitleColor(.black, for: .normal);
        background.addTarget(self, action: #selector(showChangePinCodeButton), for: .touchUpInside);
    }
    
    @objc func showPrivateKeyButton(){
        let alertController = UIAlertController(title: "Your Private Key", message: self.key, preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil));
        self.present(alertController, animated: true, completion: nil);
    }
    
    @objc func showChangePinCodeButton(){
        let v = UserLoginViewController();
        v.modalPresentationStyle = .overCurrentContext;
        v.view.backgroundColor = UIColor(red: 100, green: 100, blue: 100, alpha: 0.4);
        v.callbackSuccess = {v.changePinCode()};
        self.tabBarController?.present(v, animated: true, completion: nil);
    }
    
}

