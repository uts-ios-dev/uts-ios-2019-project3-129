//
//  textFileEditor.swift
//  blogchain
//
//  Created by 李宇沛 on 20/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit
import Notepad

class TextFileEdutior: UIView, UITextFieldDelegate, UITextViewDelegate {
    let titleView = UITextField();
    let leftButton = UIButton();
    let contentView = UITextView();
    let rightButton = UIButton();
    var titleText: String?;
    var contentText: String?;
    var showButton: Bool;
    var mdEditor: Notepad?
    
    init(showButton: Bool) {
        self.showButton = showButton;
        super.init(frame: CGRect());
        //        self.backgroundColor = .red;
    }
    
    init(title: String, content: String, showButton: Bool, frame: CGRect) {
        self.titleText = title;
        self.contentText = content;
        self.showButton = showButton;
        super.init(frame: frame);
        viewInitial();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Order can not change;
    // back button is optional, setting in the init() with the parameter of showButton
    func viewInitial() {
        addTitle();
//        addSaveButton();
//        addContent();
        addMarkDownContent()
    }
    
    // you should bind action on view controller if the button is back button
    func addLeftButton(title: String) {
        self.addSubview(leftButton);
        leftButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview();
            make.leading.equalToSuperview();
            make.width.equalToSuperview().multipliedBy(0.2);
            make.height.equalToSuperview().multipliedBy(0.1);
        }
        leftButton.setTitleColor(.black, for: .normal);
        leftButton.setTitle(title, for: .normal);
    }
    
    func addTitle() {
        self.addSubview(titleView);
        if(showButton){
            titleView.snp.makeConstraints{ (make) -> Void in
                make.top.equalToSuperview();
                make.leading.equalTo(leftButton.snp.trailing);
                make.height.equalToSuperview().multipliedBy(0.1);
                make.width.equalToSuperview().multipliedBy(0.6);
            }
        } else {
            titleView.snp.makeConstraints{ (make)->Void in
                make.top.equalToSuperview();
                make.centerX.equalToSuperview();
                make.width.equalToSuperview().multipliedBy(0.6);
                make.height.equalToSuperview().multipliedBy(0.1);
            }
        }
        titleView.delegate = self;
        titleView.placeholder = "Title";
        titleView.borderStyle = .none;
        titleView.textAlignment = .center;
        layoutIfNeeded();
        let baseline = titleView.font!.ascender + titleView.font!.lineHeight + titleView.font!.capHeight ;
        let border = CAShapeLayer();
        border.fillColor = UIColor.clear.cgColor;
        border.strokeColor = UIColor.lightGray.cgColor;
        border.lineWidth = 2;
        border.lineDashPattern = [2, 5];
        let path = UIBezierPath();
        path.move(to: CGPoint(x: titleView.bounds.minX, y: baseline));
        path.addLine(to: CGPoint(x: titleView.bounds.maxX, y: baseline));
        border.path = path.cgPath;
        titleView.layer.addSublayer(border);
    }
    
    // you should bind action on view controller
    func addRightButton(title: String) {
        self.addSubview(rightButton);
        rightButton.setTitle(title, for: .normal);
        rightButton.setTitleColor(.black, for: .normal);
        rightButton.snp.makeConstraints{(make)-> Void in
            make.leading.equalTo(titleView.snp.trailing);
            make.top.equalToSuperview();
            make.trailing.equalToSuperview();
            make.height.equalToSuperview().multipliedBy(0.1);
        }
        //        rightButton.backgroundColor = .white;
    }
    
    func addContent() {
        self.addSubview(contentView);
        contentView.snp.makeConstraints{ (make) -> Void in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20));
            make.top.equalTo(titleView.snp.bottom);
        }
        contentView.delegate = self;
        contentView.text = contentText;
        contentView.isEditable = true;
        contentView.allowsEditingTextAttributes = true;
        contentView.font = .systemFont(ofSize: 16);
        //        contentView.backgroundColor = .green;
    }
    
    func addMarkDownContent() {
        let frame = CGRect(x: 20, y: titleView.frame.maxY, width: self.frame.size.width-40, height: self.frame.size.height-30)
        mdEditor = Notepad(frame: frame, themeFile: "solarized-light")
        mdEditor?.isEditable = true
        mdEditor?.textContainerInset = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
        self.addSubview(mdEditor!)
    }
}
