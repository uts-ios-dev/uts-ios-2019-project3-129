//
//  NoteRootViewController.swift
//  blogchain
//
//  Created by 李宇沛 on 20/5/19.
//  Copyright © 2019 uts-ios-2019-project3-129. All rights reserved.ss
//

import SnapKit

class NoteRootViewController: UITableViewController, UISearchBarDelegate {
    
    private var cellData: [Artical]? = [];
    private var headerView = UIView();
    private let searchBar = UISearchBar();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self;
        cellData = ArticalInstance.instance().fetchAllArtical();
        self.tableView.register(NoteRootTableViewCell.self, forCellReuseIdentifier: "NoteRootTableViewCell");
        selfStyleSetting();
        settingHeader();
        addButton();
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("disappera");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("appear");
        cellData = ArticalInstance.instance().fetchAllArtical();
        self.tableView.reloadData();
    }
    
    func selfStyleSetting() {
        //self view
        self.view.backgroundColor = .white;
        
        // self table
        self.tableView.rowHeight = 60;
        self.tableView.separatorStyle = .none;
//        self.tableView.backgroundColor = .red;
    }
    
    func settingHeader() {
        searchBar.searchBarStyle = .minimal;
        searchBar.placeholder = "Keywords here";
        searchBar.backgroundColor = .white;
    }
    
    // do something here;
    func addButton() {
        let functionButton = UIBarButtonItem(title: "\u{2022}\u{2022}\u{2022}", style: .plain, target: self, action: nil);
        functionButton.tintColor = .black;
        self.navigationItem.rightBarButtonItem = functionButton;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData!.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteRootTableViewCell", for: indexPath) as! NoteRootTableViewCell;
        
        cell.titleLable.text = cellData?[indexPath.row].title;
        cell.contentLable.text = cellData?[indexPath.row].content;
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short;
        dateformatter.timeStyle = .none;
        cell.lastModifiedTime.text = dateformatter.string(from: (cellData?[indexPath.row].modified!)!);        
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailed = NoteDetailedViewController();
        noteDetailed.articalData = cellData?[indexPath.row];
        self.navigationController?.pushViewController(noteDetailed, animated: true);
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.searchBar;
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
}
