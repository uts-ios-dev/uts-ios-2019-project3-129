//
//  NewNoteViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 20/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class NewNoteViewController: UIViewController {
    let tx = TextFileEdutior(showButton: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        addTextEditor()
    }

    func addTextEditor() {
        self.view.addSubview(tx)
        tx.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        tx.addLeftButton(title: "CLEAR")
        tx.viewInitial()
        tx.addRightButton(title: "SAVE")
        tx.rightButton.addTarget(self, action: #selector(savaArtical), for: .touchUpInside)
        tx.leftButton.addTarget(self, action: #selector(cleanAll), for: .touchUpInside)
    }

    @objc func savaArtical() {
        // TODO: Refactor
        let author = "ANONYMOUS"
        let privateKey = "sender-hash-test"
        let category = "Dafault"

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
        ArticleInstance.instance().saveArticle(title: tx.titleView.text, content: tx.contentView.text)
        let article = Article(title: title,
            author: author,
            sender: privateKey,
            category: category,
            content: content,
            isHide: false)
        // chain saving
        APIUtils.postArticle(article: article) { result in
            // TODO: save the address to CoreData
            print("Article address: \(result.articleAddress)")
        }
    }

    @objc func cleanAll() {
        tx.contentView.text = nil
        tx.titleView.text = nil
    }

}

