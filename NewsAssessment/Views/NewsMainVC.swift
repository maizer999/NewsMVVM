//
//  NewsMainVC.swift
//  NewsAssessment
//
//  Created by Mohammad Abu Maizer on 6/14/20.
//  Copyright © 2020 Mohammad Abu Maizer. All rights reserved.
//

import UIKit
import PKHUD

class NewsMainVC: UITableViewController {
    
    var viewModel: NewsMainViewModel?
    var newsDetailVC: NewsDetailVC? = nil
    var objects = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()

        let addButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchObject(_:)))
        navigationItem.rightBarButtonItem = addButton
      
    }
    
    
    func bindViewModel(){
        
        viewModel = NewsMainViewModel()
        viewModel?.showLoadingHud    = Bindable(false)
        viewModel?.newsData          = Bindable([])
        
        viewModel?.showLoadingHud?.bind { [weak self] visible in
            if let `self` = self {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        }
        
        viewModel?.newsData?.bind { [weak self] appointments in
            if let `self` = self {
                self.tableView.reloadData()
            }
        }

        viewModel?.loadInitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc
    func searchObject(_ sender: Any) {

    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! NewsDetailVC
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                newsDetailVC = controller
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 160
      }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.newsData?.value.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath as IndexPath) as! NewsCell
        if let newsFeed = self.viewModel?.newsData?.value[indexPath.row] {
            cell.viewModel = NewsCellViewModel (withModel  : newsFeed)
        }
        return cell

    }
    
}

