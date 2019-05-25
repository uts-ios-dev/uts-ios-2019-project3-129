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
            make.width.equalToSuperview().multipliedBy(0.7);
            make.height.equalToSuperview().multipliedBy(0.7);
        }
//        titleLable.backgroundColor = .black;
        
        contentLable.snp.makeConstraints{ (make) -> Void in
            make.bottom.trailing.equalToSuperview();
            make.leading.equalTo(lastModifiedTime.snp.trailing).offset(5);
            make.top.equalTo(statusLabel.snp.bottom);
        }
        
        statusLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview();
            make.trailing.equalToSuperview();
            make.leading.equalTo(titleLable.snp.trailing);
            make.height.equalTo(titleLable);
        }
        
        lastModifiedTime.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalToSuperview();
            make.leading.equalToSuperview().offset(10);
            make.width.equalToSuperview().multipliedBy(0.4);
            make.top.equalTo(titleLable.snp.bottom);
        }
        
        contentLable.lineBreakMode = .byTruncatingTail;
        contentLable.textColor = .gray;
        lastModifiedTime.font = .systemFont(ofSize: 14);
        lastModifiedTime.textAlignment = .left;
        statusLabel.textAlignment = .right;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
