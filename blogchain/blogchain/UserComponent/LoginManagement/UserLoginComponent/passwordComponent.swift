//
//  passwordComponent.swift
//  blogchain
//
//  Created by 李宇沛 on 2/6/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class passwordComponent: UIView {

    var charactersArray: [UIView] = []

    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialView() {
        addCharacters()
    }

    func addCharacters() {
        self.layoutIfNeeded()
        let heigh = self.frame.height
        for i in 0...3 {
            let sign = UIView()
            self.addSubview(sign)
            sign.snp.makeConstraints { make -> Void in
                make.width.height.equalTo(self.snp.height).multipliedBy(0.5)
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(CGFloat(i - 2) * (heigh * 0.5 + 20) + 10 + 0.25 * heigh)
                print(CGFloat(i - 2) * heigh + 0.25 * heigh)
//                make.centerX.equalToSuperview().offset(-(heigh * 0.5 + 20) + 10 + 0.5 * heigh)
            }
            sign.layer.borderWidth = 1
            sign.layer.borderColor = UIColor.blue.cgColor
            sign.backgroundColor = .clear
            sign.layer.cornerRadius = heigh / 4
            charactersArray.append(sign)
        }
    }

    func updateLabel(content: String) {
        print(content)
        for (k, v) in charactersArray.enumerated() {
            if (k <= content.count - 1) {
                v.backgroundColor = .blue
            } else {
                v.backgroundColor = .clear
            }
        }
    }
}

