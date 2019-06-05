//
//  ChainRootViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 20/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.
//

import SnapKit

class ChainRootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private var blockchain: Blockchain = Blockchain(blocks: [], nodes: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Blockchain"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(NoteRootTableViewCell.self, forCellReuseIdentifier: "NoteRootTableViewCell")
        settingTable()
        selfStyleSetting()
        APIUtils.getBlockchain() { chain in
            self.blockchain = chain
            self.tableView.reloadData()
        }
    }

    func settingTable() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make -> Void in
            make.top.equalTo(view.safeAreaInsets.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // ignore the first block
        return blockchain.blocks.count - 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let block = blockchain.blocks[section + 1]
        return block.transactions.count

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.blockchain.blocks[section + 1].transactions.last?.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteRootTableViewCell",
            for: indexPath) as! NoteRootTableViewCell;
        let data = self.blockchain.blocks[indexPath.section + 1].transactions[indexPath.row]
        let hash = data.hash.prefix(6)
        cell.titleLabel.text = "\(data.title) #\(hash)"
        cell.contentLabel.text = data.content
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        dateformatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateformatter.locale = NSLocale.current
        let date = Date(timeIntervalSince1970: data.dateCreated)
        cell.lastModifiedTime.text = dateformatter.string(from: date)
        cell.statusLabel.isHidden = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailed = NoteDetailedViewController()
        let data = self.blockchain.blocks[indexPath.section + 1].transactions[indexPath.row]
        noteDetailed.transaction = data
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(noteDetailed, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("disapper")
    }

    override func viewWillAppear(_ animated: Bool) {
        print("appear")
        self.tableView.reloadData();
    }

    func selfStyleSetting() {
        // self view
        self.view.backgroundColor = .white

        // self table
        self.tableView.rowHeight = 70
        self.tableView.tableFooterView = UIView()
    }
}
