//
//  NewNoteViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 20/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class NewNoteViewController: UIViewController {
    let tx = textFileEdutior(showButton: false);
    
    override func viewDidLoad() {
        super.viewDidLoad();
        addTextEditor();
    }
    
    func addTextEditor(){
        self.view.addSubview(tx);
        tx.snp.makeConstraints{(make)->Void in
            make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide);
        }
        tx.viewInitial();
        tx.saveButton.addTarget(self, action: #selector(savaArtical), for: .touchUpInside);

    }
    
    @objc func savaArtical(){
        ArticalInstance.instance().saveArtical(title: tx.titleView.text, content: tx.contentView.text);
    }
    
}

