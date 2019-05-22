//
//  NoteDetailedViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 21/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class NoteDetailedViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var articalData: Artical?;
    let tx = textFileEdutior(showButton: true);
    
    override func viewDidLoad() {
        super.viewDidLoad();
        addTextEditor();
        self.view.backgroundColor = .white;
        self.navigationController?.isNavigationBarHidden = true;
        self.tabBarController?.tabBar.isHidden = true;
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }
    
    func addTextEditor(){
        self.view.addSubview(tx);
        tx.snp.makeConstraints{(make)->Void in
            make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide);
        }
        tx.viewInitial();
        tx.titleView.text = articalData?.title;
        tx.contentView.text = articalData?.content;
        tx.saveButton.addTarget(self, action: #selector(savaArtical), for: .touchUpInside);
        tx.backButton.addTarget(self, action: #selector(backButtonSelector), for: .touchUpInside);
    }
    
    @objc func savaArtical(){
        ArticalInstance.instance().saveArtical(instance: articalData!, title: tx.titleView.text, content: tx.contentView.text);
    }
    
    @objc func backButtonSelector(){
        self.navigationController?.popViewController(animated: true);
        self.tabBarController?.tabBar.isHidden = false;
    }

}
