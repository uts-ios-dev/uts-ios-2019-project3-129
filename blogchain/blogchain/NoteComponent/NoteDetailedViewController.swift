//
//  NoteDetailedViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 21/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class NoteDetailedViewController: UIViewController, UIGestureRecognizerDelegate {

    var articalData: Artical?
    let tx = TextFileEditor(showButton: true)
    var transaction: Transaction?

    override func loadView() {
        super.loadView()
        addTextEditor()
        self.navigationController?.title = "Articles"
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func addTextEditor() {
        self.view.addSubview(tx)
        tx.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        tx.addLeftButton(title: "BACK")
        tx.viewInitial()
        tx.addRightButton(title: "EDIT")
        if let transaction = self.transaction {
            tx.titleView.text = transaction.title
//            tx.contentView.text = transaction.content
            tx.mdEditor?.text = transaction.content
            tx.rightButton.isHidden = true
        } else {
            tx.titleView.text = articalData?.title
//            tx.contentView.text = articalData?.content
            tx.mdEditor?.text = articalData?.content
        }
        tx.titleView.isEnabled = false
//        tx.contentView.isEditable = false
        tx.mdEditor?.isEditable = false
        tx.leftButton.addTarget(self, action: #selector(backButtonSelector), for: .touchUpInside)
        tx.rightButton.addTarget(self, action: #selector(editArtical), for: .touchUpInside)
    }

    @objc func editArtical() {
        tx.titleView.isEnabled = true
//        tx.contentView.isEditable = true
        tx.mdEditor?.isEditable = true
        self.tabBarController?.tabBar.isHidden = true
        tx.rightButton.removeTarget(nil, action: nil, for: .allEvents)
        tx.rightButton.setTitle("SAVE", for: .normal)
        tx.rightButton.addTarget(self, action: #selector(saveArticle), for: .touchUpInside)
    }

    // TODO: share the save article btw new note and edit note
    @objc func saveArticle() {
        // TODO: Refactor (same with new note
        // local saving
        ArticleInstance.instance()
            .saveArticle(instance: articalData!, title: tx.titleView.text, content: tx.mdEditor?.text)
        self.tabBarController?.tabBar.isHidden = false
        tx.titleView.isEnabled = false
        tx.contentView.isEditable = false
        tx.mdEditor?.isEditable = false
        tx.rightButton.removeTarget(nil, action: nil, for: .allEvents)
        tx.rightButton.setTitle("EDIT", for: .normal)
        tx.rightButton.addTarget(self, action: #selector(editArtical), for: .touchUpInside)
    }

    @objc func backButtonSelector() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}
