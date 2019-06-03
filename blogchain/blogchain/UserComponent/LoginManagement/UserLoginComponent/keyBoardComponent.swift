//
//  keyBoardComponent.swift
//  blogchain
//
//  Created by 李宇沛 on 2/6/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class keyBoardComponent: UIView {
    
    var keysArray: [[UIButton]] = [];

    init() {
        super.init(frame: CGRect.zero);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialKeys() {
        self.layoutIfNeeded();
        let width = (self.frame.width / 3) - 10;
        for i in 0...2{
            keysArray.append([]);
            for j in 0...2{
                let keyB = UIButton();
                self.addSubview(keyB);
                keyB.snp.makeConstraints{ make -> Void in
                    make.leading.equalToSuperview().offset(5 + CGFloat(j) * (10 + width));
                    make.top.equalToSuperview().offset(5 + CGFloat(i) * (10 + width));
                    make.width.equalToSuperview().dividedBy(3).offset(-10);
                    make.height.equalTo(self.snp.width).dividedBy(3).offset(-10);
                }
                keyB.setTitle("\(i * 3 + j + 1)", for: .normal);
                keyB.setTitleColor(.blue, for: .normal);
                keyB.layer.borderWidth = 1;
                keyB.layer.borderColor = UIColor.blue.cgColor;
                keyB.layer.cornerRadius = width / 2;
                keysArray[i].append(keyB);
            }
        }
        let key0 = UIButton();
        self.addSubview(key0);
        key0.snp.makeConstraints{ make -> Void in
            make.leading.equalToSuperview().offset(5 + 1 * (10 + width));
            make.top.equalToSuperview().offset(5 + CGFloat(3) * (10 + width));
            make.width.equalToSuperview().dividedBy(3).offset(-10);
            make.height.equalTo(self.snp.width).dividedBy(3).offset(-10);
        }
        key0.setTitle("0", for: .normal);
        key0.setTitleColor(.blue, for: .normal);
        key0.layer.borderWidth = 1;
        key0.layer.borderColor = UIColor.blue.cgColor;
        key0.layer.cornerRadius = width / 2;
        keysArray.append([key0]);
    }
}
