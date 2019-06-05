//
//  NoteRootViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 20/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.ss
//

import SnapKit

class NoteRootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    enum SearchType {
        case none
        case local
        case server
    }
    
    private let dataInstance = ArticalInstance.instance();
    private var allArticlesInBlockchain: [Block] = []
    private var headerView = UIView();
    private let searchBar = UISearchBar();
    private let tableView = UITableView();
    private let bottomBar = UIView();
    private let segments = UISegmentedControl(items:["Personal", "All"]);
//    private var inSearchMode = false;
    private var serverSearchResults = [Transaction]();
    private var localSearchResults = [Artical]();
    private var renderedCellData: [Artical] {
        get {
            if(!searchBar.text!.isEmpty){ return localSearchResults; }
            return dataInstance.allArticals!;
        }
    }
    private var searchType = SearchType.none
    
    override func loadView() {
        super.loadView();
        // Do any additional setup after loading the view.
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.register(NoteRootTableViewCell.self, forCellReuseIdentifier: "NoteRootTableViewCell");
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = false;
        self.title = "Articles";
        settingSearchBar();
        settingSegment();
        settingTable();
        selfStyleSetting();
        addButton();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        loadAllArticles()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("disapper");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("appear");
        self.tableView.reloadData();
    }
    
    func fetchData() {
        // TODO: fill in the user private key
        APIUtils.getArticlesFromUser(hash: "9e7cd9cb5a63a3591e16f4d835f32a1c4a84ab66e39ae27aa448c03b66bf63e7") { transactions in
            for transaction in transactions {
                #if DEBUG
                print(transaction.content)
                #endif
            }
        }
    }
    
    func selfStyleSetting() {
        // self view
        self.view.backgroundColor = .white;
        
        // self table
        self.tableView.rowHeight = 70;
        self.tableView.tableFooterView = UIView();
    }
    
    func settingSearchBar() {
        self.view.addSubview(searchBar);
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal;
        searchBar.placeholder = "Keywords here";
        searchBar.snp.makeConstraints{ make -> Void in
            make.leading.trailing.equalToSuperview();
            make.top.equalTo(self.view.safeAreaLayoutGuide);
        }
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.borderStyle = .line;
            textFieldInsideSearchBar.backgroundColor = .white;
            textFieldInsideSearchBar.layer.cornerRadius = 14;
            textFieldInsideSearchBar.layer.borderWidth = 1;
            textFieldInsideSearchBar.layer.masksToBounds = true;
            textFieldInsideSearchBar.layer.borderColor = UIColor.lightGray.cgColor;
            // bind revertSearchMode() with the clear button in the search bar
            if let clearButton = textFieldInsideSearchBar.value(forKey: "clearButton") as? UIButton {
                clearButton.addTarget(self, action: #selector(revertSearchMode), for: .touchUpInside)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            revertSearchMode()
            return
        }
        if inAllTab() {
            self.searchType = SearchType.server
            APIUtils.searchArticle(keywords: searchText) { (transactions) in
                self.serverSearchResults = transactions
                self.tableView.reloadData()
                #if DEBUG
                print("Find \(transactions.count) result(s)")
                #endif
            }
        } else {
            self.searchType = SearchType.local
            print("local")
            localSearchResults = dataInstance.searchArticles(keyword: searchText)
            self.tableView.reloadData()
            #if DEBUG
            print("Find \(localSearchResults.count) result(s)")
            #endif
        }
    }
    
    @objc func revertSearchMode() {
        searchType = .none
        serverSearchResults.removeAll()
        self.tableView.reloadData()
    }
    
    func settingSegment() {
        self.view.addSubview(segments);
        segments.snp.makeConstraints{ make -> Void in
            make.leading.trailing.equalToSuperview();
            make.top.equalTo(searchBar.snp.bottom);
        }
        segments.selectedSegmentIndex = 0;
        segments.translatesAutoresizingMaskIntoConstraints = false;
        segments.tintColor = .clear;
        segments.backgroundColor = .clear;
        segments.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal);
        segments.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected);
        bottomBar.translatesAutoresizingMaskIntoConstraints = false;
        bottomBar.backgroundColor = UIColor.lightGray;
        segments.addSubview(bottomBar);
        bottomBar.snp.makeConstraints{make -> Void in
            make.bottom.equalToSuperview();
            make.leading.equalToSuperview().offset(segments.frame.width / 2 * CGFloat(segments.selectedSegmentIndex));
            make.width.equalToSuperview().dividedBy(2);
        }
        bottomBar.heightAnchor.constraint(equalToConstant: 3).isActive = true;
        segments.addTarget(self, action: #selector(segmentedControlChange(_:)), for: .valueChanged);
    }
    
    func inAllTab() -> Bool {
        return Bool(truncating: self.segments.selectedSegmentIndex as NSNumber)
    }
    
    func settingTable() {
        self.view.addSubview(tableView);
        tableView.snp.makeConstraints{ make -> Void in
            make.top.equalTo(segments.snp.bottom).offset(10);
            make.leading.trailing.equalToSuperview();
            make.bottom.equalTo(self.view.safeAreaLayoutGuide);
        }
    }
    
    func addButton() {
        let rightButton = UIBarButtonItem(title: "\u{2022}\u{2022}\u{2022}", style: .plain, target: self, action: nil);
        rightButton.tintColor = .black;
        self.navigationItem.rightBarButtonItem = rightButton;
        let leftButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: nil);
        leftButton.tintColor = .black;
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    func loadAllArticles() {
        APIUtils.getBlockchain { blockchan in
            self.allArticlesInBlockchain = blockchan.blocks
            if self.inAllTab() {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType != .none {
            if searchType == .server {
                return serverSearchResults.count
            } else {
                return localSearchResults.count
            }
        } else if inAllTab() {
            return self.allArticlesInBlockchain.count - 1
        } else {
            return self.renderedCellData.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NoteRootTableViewCell", for: indexPath) as! NoteRootTableViewCell;
       
        if (searchType != .none) {
            if searchType == .server {
                if serverSearchResults.count > indexPath.row {
                    let data = serverSearchResults[indexPath.row]
                    cell = getTableCellOfAllTab(cell: cell, data: data)
                }
            } else {
                // local search
                if localSearchResults.count > indexPath.row {
                    let data = localSearchResults[indexPath.row]
                    cell = getTableCellOfPersonalTab(cell: cell, data: data)
                }
            }
        } else if inAllTab() {
            let data = self.allArticlesInBlockchain[indexPath.row + 1].transactions.last!
            cell = getTableCellOfAllTab(cell: cell, data: data)
        } else {
            let data = self.renderedCellData[indexPath.row]
            cell = getTableCellOfPersonalTab(cell: cell, data: data)
        }
       
        return cell
    }
    
    func getTableCellOfAllTab(cell: NoteRootTableViewCell , data : Transaction) -> NoteRootTableViewCell {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        cell.titleLable.text = data.title
        cell.contentLable.text = data.content
        let date = Date(timeIntervalSince1970: data.dateCreated)
        cell.lastModifiedTime.text = dateformatter.string(from: date)
        cell.statusLabel.text = "via: \(data.author)"
        cell.statusLabel.textColor = .lightGray
        return cell
    }
    
     func getTableCellOfPersonalTab(cell: NoteRootTableViewCell , data : Artical) -> NoteRootTableViewCell {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        cell.titleLable.text = data.title;
        cell.contentLable.text = data.content;
        cell.lastModifiedTime.text = dateformatter.string(from: data.modified!)
        if ( data.addressKey == nil ) {
            cell.statusLabel.text = "private";
            cell.statusLabel.textColor = .lightGray;
        } else {
            if (data.dirty) {
                cell.statusLabel.text = "modified";
                cell.statusLabel.textColor = .yellow;
            } else {
                cell.statusLabel.text = "publish";
                cell.statusLabel.textColor = .green;
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailed = NoteDetailedViewController();
        if inAllTab() {
            noteDetailed.transaction = self.allArticlesInBlockchain[indexPath.row + 1].transactions.last
        } else {
            noteDetailed.articalData = self.renderedCellData[indexPath.row];
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.navigationController?.pushViewController(noteDetailed, animated: true);
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if inAllTab() || searchType == .local {
            return []
        }
        let more = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print(action);
            print(index);
            ArticalInstance.instance().deleteArtical(artical: self.renderedCellData[indexPath.row]);
            self.tableView.reloadData();
            // chain deleting
            let article = Article(title: "111", author: "Frank", sender: "test", category: "IpHONE", content: "Make blog great again!", isHide: true)
            let articleAddress = "d754daeebb51bb4bb17f1ac39e47297e4b18c2291b77c95b3e1793e5de656720"
            let updateArticle = UpdateArticle(address: articleAddress, article: article)
            APIUtils.updateArticle(article: updateArticle){ success in
                // TODO: HUD
            }
        }
        more.backgroundColor = .red;
        
        return [more];
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if inAllTab() || searchType == .local {
            return nil
        }
        let closeAction = UIContextualAction(style: .normal, title:  "Upload", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        closeAction.backgroundColor = self.renderedCellData[indexPath.row].dirty ? .gray : .purple;
        
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    
    @objc func segmentedControlChange(_ segmented: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.bottomBar.frame.origin.x = self.segments.frame.width / 2 * CGFloat(self.segments.selectedSegmentIndex);
        }
        self.tableView.reloadData();
    }
}
