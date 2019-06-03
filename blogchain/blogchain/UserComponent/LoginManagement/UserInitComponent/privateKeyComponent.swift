//
//  privateKeyComponent.swift
//  blogchain
//
//  Created by 李宇沛 on 30/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class privateKeysPage: UIView {
    
    public let noteLabel = UILabel();
    public let usernameLabel = UITextField();
    public let generatePrivateKeyButton = UIButton();
    
    init() {
        super.init(frame: CGRect.zero);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialView(){
        self.snp.makeConstraints{ make -> Void in
            make.width.height.centerY.equalToSuperview();
            make.centerX.equalToSuperview();
//            .offset(-UIScreen.main.bounds.width)
        }
        addNameLabel();
        addButton();
    }
    
    func addNameLabel() {
        self.addSubview(noteLabel);
        noteLabel.snp.makeConstraints{make -> Void in
            make.top.equalToSuperview();
            make.leading.trailing.equalToSuperview();
            make.height.equalToSuperview().multipliedBy(0.3);
        }
        noteLabel.text = "Enter your user name";
        noteLabel.textColor = .black;
        noteLabel.textAlignment = .center;
        
        self.addSubview(usernameLabel);
        usernameLabel.snp.makeConstraints{ make -> Void in
            make.top.equalTo(noteLabel.snp.bottom).offset(10);
            make.leading.trailing.equalToSuperview();
            make.height.equalToSuperview().multipliedBy(0.2);
        }
        usernameLabel.placeholder = "User name";
        usernameLabel.textAlignment = .center;
        usernameLabel.borderStyle = .roundedRect;
        usernameLabel.returnKeyType = .done;
        usernameLabel.layer.borderWidth = 1;
        usernameLabel.layer.cornerRadius = 10;
    }
    
    func addButton() {
        self.addSubview(generatePrivateKeyButton);
        generatePrivateKeyButton.snp.makeConstraints{make -> Void in
            make.top.equalTo(usernameLabel.snp.bottom).offset(20);
            make.leading.trailing.equalToSuperview();
        }
        generatePrivateKeyButton.setTitle("Generate Private Key", for: .normal);
        generatePrivateKeyButton.setTitleColor(.black, for: .normal);
    }
}
