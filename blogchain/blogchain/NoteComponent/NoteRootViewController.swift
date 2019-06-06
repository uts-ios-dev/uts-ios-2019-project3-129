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

    private let dataInstance = ArticleInstance.instance()
    private var allArticlesInBlockchain: [Block] = []
    private var headerView = UIView()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let bottomBar = UIView()
    private let segments = UISegmentedControl(items: ["Personal", "All"])
//    private var inSearchMode = false
    private var serverSearchResults = [Transaction]()
    private var localSearchResults = [Artical]()
    private var renderedCellData: [Artical] {
        get {
            if(!searchBar.text!.isEmpty){ return localSearchResults; }
            return dataInstance.allArticles!;
        }
    }
    private var searchType = SearchType.none

    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(NoteRootTableViewCell.self, forCellReuseIdentifier: "NoteRootTableViewCell")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Articles"
        settingSearchBar()
        settingSegment()
        settingTable()
        selfStyleSetting()
        addButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllArticles()
        fetchData();
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("disapper")
    }

    override func viewWillAppear(_ animated: Bool) {
        print("appear")
        self.tableView.reloadData()
    }

    func fetchData() {
        // TODO: fill in the user private key
        APIUtils.getArticlesFromUser(hash: keyChainExtension.keyAddress!) { transactions in
            self.reconciliation(localArticles: self.renderedCellData, onlineArticles: transactions)
        }
    }

    func selfStyleSetting() {
        // self view
        self.view.backgroundColor = .white

        // self table
        self.tableView.rowHeight = 70
        self.tableView.tableFooterView = UIView()
    }

    func settingSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Keywords here"
        searchBar.snp.makeConstraints { make -> Void in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.borderStyle = .line
            textFieldInsideSearchBar.backgroundColor = .white
            textFieldInsideSearchBar.layer.cornerRadius = 14
            textFieldInsideSearchBar.layer.borderWidth = 1
            textFieldInsideSearchBar.layer.masksToBounds = true
            textFieldInsideSearchBar.layer.borderColor = UIColor.lightGray.cgColor
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
        self.view.addSubview(segments)
        segments.snp.makeConstraints { make -> Void in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        segments.selectedSegmentIndex = 0
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.tintColor = .clear
        segments.backgroundColor = .clear
        segments.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ], for: .normal)
        segments.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .selected)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = UIColor.lightGray
        segments.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make -> Void in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(segments.frame.width / 2 * CGFloat(segments.selectedSegmentIndex))
            make.width.equalToSuperview().dividedBy(2)
        }
        bottomBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        segments.addTarget(self, action: #selector(segmentedControlChange(_:)), for: .valueChanged)
    }

    func inAllTab() -> Bool {
        return Bool(truncating: self.segments.selectedSegmentIndex as NSNumber)
    }

    func settingTable() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make -> Void in
            make.top.equalTo(segments.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    func addButton() {
        let rightButton = UIBarButtonItem(title: "\u{2022}\u{2022}\u{2022}", style: .plain, target: self, action: nil)
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
        let leftButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: nil)
        leftButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftButton
    }

    func loadAllArticles() {
        APIUtils.getBlockchain { blockchan in
            self.allArticlesInBlockchain = blockchan.blocks
            if self.inAllTab() {
                self.tableView.reloadData()
            }
        }
    }

    func getTableCellOfAllTab(cell: NoteRootTableViewCell, data: Transaction) -> NoteRootTableViewCell {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        cell.titleLabel.text = data.title
        cell.contentLabel.text = data.content
        let date = Date(timeIntervalSince1970: data.dateCreated)
        cell.lastModifiedTime.text = dateformatter.string(from: date)
        cell.statusLabel.text = "via: \(data.author)"
        cell.statusLabel.textColor = .lightGray
        return cell
    }

    func getTableCellOfPersonalTab(cell: NoteRootTableViewCell, data: Artical) -> NoteRootTableViewCell {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        cell.titleLabel.text = data.title
        cell.contentLabel.text = data.content
        cell.lastModifiedTime.text = dateformatter.string(from: data.modified!)
        if (data.addressKey == nil) {
            cell.statusLabel.text = "private"
            cell.statusLabel.textColor = .lightGray
        } else {
            if (data.dirty) {
                cell.statusLabel.text = "modified"
                cell.statusLabel.textColor = .yellow
            } else {
                cell.statusLabel.text = "publish"
                cell.statusLabel.textColor = .green
            }
        }
        return cell
    }
    
    func deleteArticleOnline(title: String, content: String, address: String) {
        // chain deleting
        let article = Article(title: title,
                              author: Author,
                              sender: keyChainExtension.keyAddress!,
                              category: "Default",
                              content: content,
                              isHide: true)
        let articleAddress = address;
        let updateArticle = UpdateArticle(address: articleAddress, article: article)
        APIUtils.updateArticle(article: updateArticle) { success in
            // TODO: HUD
        }
        self.tableView.reloadData();
    }
    
    func uploadArtical(instance: Artical) {
        let category = "Dafault"
        let privateKey = keyChainExtension.keyAddress
        
        let article = Article(title: instance.title!,
                              author: Author,
                              sender: privateKey!,
                              category: category,
                              content: instance.content!,
                              isHide: false)
        // chain saving
        APIUtils.postArticle(article: article) { result in
            // TODO: save the address to CoreData
            print(result);
            ArticleInstance.instance().saveArticle(instance: instance, addressKey: result.articleAddress, modified: Date(timeIntervalSince1970: Double(result.createdDate)!));
        }
        self.loadViewIfNeeded();
        self.tableView.reloadData();
    }
    
    func uploadArtical(articleAddress: String, title: String, content: String, instance: Artical) {
        
        let privateKey = keyChainExtension.keyAddress
        let category = "Dafault"
        // chain saving
        let article = Article(title: title,
                              author: Author,
                              sender: privateKey!,
                              category: category,
                              content: content,
                              isHide: false)
        
        let updateArticle = UpdateArticle(address: articleAddress, article: article)
        
        APIUtils.updateArticle(article: updateArticle) { date in
            // TODO: HUD
            ArticleInstance.instance().saveArticle(instance: instance, modified: Date(timeIntervalSince1970: Double(date)!));
        }
        self.loadViewIfNeeded();
        self.tableView.reloadData();
    }
    
    func reconciliation(localArticles: [Artical], onlineArticles: [TransactionWithAddr]) {
        var mid: Artical?;
        for onlineArticle in onlineArticles {
            mid = articleContentedInLocal(localArticles: localArticles, address: onlineArticle.articleAddress);
            if(mid != nil){
                if(onlineArticle.dateCreated > mid!.modified!.timeIntervalSince1970){
                    ArticleInstance.instance().saveArticle(instance: mid!, title: mid!.title!, content: mid!.content!, modified: Date(timeIntervalSince1970: onlineArticle.dateCreated));
                }
            } else {
                ArticleInstance.instance().saveArticle(title: onlineArticle.title, content: onlineArticle.content, modified: Date(timeIntervalSince1970: onlineArticle.dateCreated), keyaddress: onlineArticle.articleAddress);
            }
        }
        self.tableView.reloadData();
    }
    
    func articleContentedInLocal(localArticles: [Artical], address: String) -> Artical? {
        for article in localArticles{
            if(article.addressKey == address){ return article }
        }
        return nil;
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
            return self.renderedCellData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NoteRootTableViewCell",
                                                 for: indexPath) as! NoteRootTableViewCell
        
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailed = NoteDetailedViewController()
        if inAllTab() {
            noteDetailed.transaction = self.allArticlesInBlockchain[indexPath.row + 1].transactions.last
        } else {
            noteDetailed.articalData = self.renderedCellData[indexPath.row]
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(noteDetailed, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if inAllTab() || searchType == .local {
            return []
        }
        let data = self.renderedCellData[indexPath.row];
        let more = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print(action)
            print(index)
            ArticleInstance.instance().deleteArtical(artical: data)
            if(data.addressKey != nil){self.deleteArticleOnline(title: data.title!, content: data.content!, address: data.addressKey!)}
            self.tableView.reloadData()
        }
        more.backgroundColor = .red
        return [more]
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if inAllTab() || searchType == .local {
            return nil
        }
        let data = self.renderedCellData[indexPath.row];
        let closeAction = UIContextualAction(style: .normal,
            title: "Upload",
            handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                if(data.dirty == true || data.addressKey == nil){
                    if(data.addressKey != nil){
                        self.uploadArtical(articleAddress: data.addressKey!, title: data.title!, content: data.content!, instance: data)
                    } else {
                        self.uploadArtical(instance: data)
                    }
                    print("OK, marked as Closed")
                    self.alertMessage(title: "Success", message: "Article uploaded")
                    self.tableView.reloadData();
                }
                success(true)
            })
        closeAction.backgroundColor = (data.dirty || data.addressKey == nil) ? .purple : .gray
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder();
    }
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.view.window?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @objc func segmentedControlChange(_ segmented: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.bottomBar.frame.origin.x = self.segments.frame.width / 2 * CGFloat(self.segments.selectedSegmentIndex)
        }
        self.tableView.reloadData()
    }
}
