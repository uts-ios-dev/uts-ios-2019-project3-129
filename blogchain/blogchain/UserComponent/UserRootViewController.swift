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
    private var key: String?;
    
    override func loadView() {
        super.loadView();
        key = keyChainExtension.keyAddress;
        addButton();
        addKeyLable();
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if(key == nil){
            let v = UserInitialViewController();
            v.modalPresentationStyle = .overCurrentContext;
            v.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3);
            self.parent?.present(v, animated: true, completion: nil);
        }
        else{
            //validation key code
            let v = UserLoginViewController();
            v.modalPresentationStyle = .overCurrentContext;
            v.view.backgroundColor = UIColor(red: 100, green: 100, blue: 100, alpha: 0.4);
            v.callbackSuccess = {v.selfDismiss()};
            self.tabBarController?.present(v, animated: true, completion: nil);
        }
    }
    
    func addButton() {
        let button = UIButton();
        self.view.addSubview(button);
        button.snp.makeConstraints{make -> Void in
            make.leading.trailing.top.bottom.equalToSuperview();
        }
        button.setTitle("add", for: .normal);
        button.setTitleColor(.blue, for: .normal);
        button.addTarget(self, action: #selector(genert), for: .touchUpInside);
    }
    
    func addKeyLable(){
        self.view.addSubview(keyLable);
        self.view.addSubview(keyHashLable);
        keyLable.text = "key";
        keyHashLable.text = "Hash";
        keyLable.textColor = .red;
        keyHashLable.textColor = .blue;
        keyLable.snp.makeConstraints{make -> Void in
            make.top.equalToSuperview().offset(100);
            make.leading.trailing.equalToSuperview();
            make.height.equalToSuperview().dividedBy(5);
        }
        keyHashLable.snp.makeConstraints{make -> Void in
            make.top.equalTo(keyLable.snp.bottom);
            make.leading.trailing.bottom.equalToSuperview();
        }
    }
    
    @objc func genert(){
        let secret = UIDevice.current.identifierForVendor!.uuidString.data(using: .utf8)!;
        let hash = "pei".data(using: .utf8)?.authenticationCode(secretKey: secret).base64EncodedString();
        self.keyHashLable.text = hash;
    }

}

