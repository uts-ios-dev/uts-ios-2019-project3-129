//
//  NoteRootTableViewCell.swift
//  blogchain
//
//  Created by 李宇沛 on 21/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class NoteRootTableViewCell: UITableViewCell {
    
    let titleLable = UILabel();
    let contentLable = UILabel();
    let lastModifiedTime = UILabel();
    let statusLabel = UILabel();
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.accessoryType = .disclosureIndicator;
        initialAddViews();
    }
    
    func initialAddViews() {
        self.contentView.addSubview(titleLable);
        self.contentView.addSubview(contentLable);
        self.contentView.addSubview(lastModifiedTime);
        self.contentView.addSubview(statusLabel);
        
        titleLable.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview();
            make.leading.equalToSuperview().offset(10);
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
//        titleLable.textColor = .black;
        
        contentLable.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalToSuperview();
            make.leading.equalToSuperview().offset(10);
            make.top.equalTo(titleLable.snp.bottom);
            make.width.equalTo(titleLable);
        }
        
        statusLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview();
            make.trailing.equalToSuperview().offset(-5);
            make.leading.equalTo(titleLable.snp.trailing);
            make.height.equalTo(titleLable);
        }
        
        lastModifiedTime.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalToSuperview();
            make.trailing.equalToSuperview().offset(-5);
            make.leading.equalTo(contentLable.snp.trailing);
            make.top.equalTo(statusLabel.snp.bottom);
        }
        
        contentLable.lineBreakMode = .byTruncatingTail;
        contentLable.textColor = .gray;
//        lastModifiedTime.font = .systemFont(ofSize: 16);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
