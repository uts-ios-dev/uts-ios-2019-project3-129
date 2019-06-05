//
//  pinComponent.swift
//  blogchain
//
//  Created by 李宇沛 on 30/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class PinPage: UIView {
    public let notionLabel = UILabel()
    public let hidedLabel = UITextField()
    public let code1 = UILabel()
    public let code2 = UILabel()
    public let code3 = UILabel()
    public let code4 = UILabel()

    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialView() {
        self.snp.makeConstraints { make -> Void in
            make.centerY.width.height.equalToSuperview()
            make.centerX.equalToSuperview().offset(-UIScreen.main.bounds.width)
//            make.centerX.equalToSuperview()
        }
        addNotionLabel()
        addPinLabel()
    }

    func addNotionLabel() {
        self.addSubview(notionLabel)
        notionLabel.snp.makeConstraints { make -> Void in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        notionLabel.textColor = .black
        notionLabel.textAlignment = .center
        notionLabel.text = "Please enter your pin code"
    }

    func addPinLabel() {
        self.addSubview(hidedLabel)
        hidedLabel.tintColor = .clear
        hidedLabel.textColor = .clear
        hidedLabel.snp.makeConstraints { make -> Void in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(notionLabel.snp.bottom)
            make.bottom.equalToSuperview().multipliedBy(0.5)
        }
        hidedLabel.keyboardType = .numberPad

        self.layoutIfNeeded()
        self.addSubview(code1)
        self.addSubview(code2)
        self.addSubview(code3)
        self.addSubview(code4)
        code1.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(hidedLabel.snp.centerY)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.leading.equalToSuperview().offset(self.frame.width * 0.04)
        }
        code2.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(hidedLabel.snp.centerY)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.leading.equalToSuperview().offset(self.frame.width * 0.28)
        }
        code3.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(hidedLabel.snp.centerY)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.leading.equalToSuperview().offset(self.frame.width * 0.52)
        }
        code4.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(hidedLabel.snp.centerY)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.leading.equalToSuperview().offset(self.frame.width * 0.76)
        }
        code1.layer.borderColor = UIColor.lightGray.cgColor
        code1.layer.borderWidth = 1
        code1.textAlignment = .center
        code2.layer.borderColor = UIColor.lightGray.cgColor
        code2.layer.borderWidth = 1
        code2.textAlignment = .center
        code3.layer.borderColor = UIColor.lightGray.cgColor
        code3.layer.borderWidth = 1
        code3.textAlignment = .center
        code4.layer.borderColor = UIColor.lightGray.cgColor
        code4.layer.borderWidth = 1
        code4.textAlignment = .center
    }
}

