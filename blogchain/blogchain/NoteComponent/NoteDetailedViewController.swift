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
    let tx = TextFileEdutior(showButton: true);
    var transaction : Transaction?
    
    override func loadView() {
        super.loadView();
        addTextEditor();
        self.navigationController?.title = "Articles";
        self.view.backgroundColor = .white;
        self.navigationController?.isNavigationBarHidden = true;
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func addTextEditor(){
        self.view.addSubview(tx);
        tx.snp.makeConstraints{(make)->Void in
            make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide);
        }
        tx.addLeftButton(title: "BACK");
        tx.viewInitial();
        tx.addRightButton(title: "EDIT");
        if let transaction = self.transaction {
            tx.titleView.text = transaction.title
//            tx.contentView.text = transaction.content
            tx.mdEditor?.text = transaction.content
            tx.rightButton.isHidden = true
        } else {
            tx.titleView.text = articalData?.title;
//            tx.contentView.text = articalData?.content;
            tx.mdEditor?.text = articalData?.content
        }
        tx.titleView.isEnabled = false;
//        tx.contentView.isEditable = false;
        tx.mdEditor?.isEditable = false
        tx.leftButton.addTarget(self, action: #selector(backButtonSelector), for: .touchUpInside);
        tx.rightButton.addTarget(self, action: #selector(editArtical), for: .touchUpInside);
    }
    
    @objc func editArtical() {
        tx.titleView.isEnabled = true;
//        tx.contentView.isEditable = true;
        tx.mdEditor?.isEditable = true
        self.tabBarController?.tabBar.isHidden = true;
        tx.rightButton.removeTarget(nil, action: nil, for: .allEvents);
        tx.rightButton.setTitle("SAVE", for: .normal);
        tx.rightButton.addTarget(self, action: #selector(saveArticle), for: .touchUpInside);
    }
    // TODO: share the save article btw new note and edit note
    @objc func saveArticle() {
        // TODO: Refactor (same with new note
        let author = "ANONYMOUS"
        let privateKey = "sender-hash-test"
        let category = "Dafault"
        let articleAddress = "d754daeebb51bb4bb17f1ac39e47297e4b18c2291b77c95b3e1793e5de656720"
        
        guard let title = tx.titleView.text else {
            // TODO: HUD
            #if DEBUG
            print("Missing the title")
            #endif
            return
        }
        guard let content = tx.contentView.text else {
            // TODO: HUD
            #if DEBUG
            print("Missing the content")
            #endif
            return
        }
        // local saving
//        ArticalInstance.instance().saveArtical(instance: articalData!, title: tx.titleView.text, content: tx.contentView.text);
        ArticalInstance.instance().saveArtical(instance: articalData!, title: tx.titleView.text, content: tx.mdEditor?.text);
        self.tabBarController?.tabBar.isHidden = false;
        tx.titleView.isEnabled = false;
//        tx.contentView.isEditable = false;
        tx.mdEditor?.isEditable = false
        tx.rightButton.removeTarget(nil, action: nil, for: .allEvents);
        tx.rightButton.setTitle("EDIT", for: .normal);
        tx.rightButton.addTarget(self, action: #selector(editArtical), for: .touchUpInside);
        // chain saving
        let article = Article(title: title, author: author, sender: privateKey, category: category, content: content, isHide: false)
        let updateArticle = UpdateArticle(address: articleAddress, article: article)
        APIUtils.updateArticle(article: updateArticle){ success in
            // TODO: HUD
        }
    }
    
    @objc func backButtonSelector(){
        self.navigationController?.popViewController(animated: true);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.tabBarController?.tabBar.isHidden = false;
    }

}
