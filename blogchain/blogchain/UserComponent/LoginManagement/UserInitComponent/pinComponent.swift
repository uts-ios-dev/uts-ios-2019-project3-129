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
    public let label1 = UILabel()
    public let label2 = UILabel()
    public let label3 = UILabel()
    public let label4 = UILabel()

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
        self.addSubview(label1)
        self.addSubview(label2)
        self.addSubview(label3)
        self.addSubview(label4)
        label1.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(hidedLabel.snp.centerY)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.leading.equalToSuperview().offset(self.frame.width * 0.04)
        }
        label2.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(hidedLabel.snp.centerY)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.leading.equalToSuperview().offset(self.frame.width * 0.28)
        }
        label3.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(hidedLabel.snp.centerY)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.leading.equalToSuperview().offset(self.frame.width * 0.52)
        }
        label4.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(hidedLabel.snp.centerY)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.leading.equalToSuperview().offset(self.frame.width * 0.76)
        }
        label1.layer.borderColor = UIColor.lightGray.cgColor
        label1.layer.borderWidth = 1
        label1.textAlignment = .center
        label2.layer.borderColor = UIColor.lightGray.cgColor
        label2.layer.borderWidth = 1
        label2.textAlignment = .center
        label3.layer.borderColor = UIColor.lightGray.cgColor
        label3.layer.borderWidth = 1
        label3.textAlignment = .center
        label4.layer.borderColor = UIColor.lightGray.cgColor
        label4.layer.borderWidth = 1
        label4.textAlignment = .center
    }
}

