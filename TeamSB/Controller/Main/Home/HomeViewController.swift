//
//  HomeViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/04.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var deliveryButton: UIButton!
    @IBOutlet weak var packageButton: UIButton!
    @IBOutlet weak var taxiButton: UIButton!
    @IBOutlet weak var laundryButton: UIButton!
    
    
    @IBOutlet weak var recentPostTableView: UITableView!
    @IBOutlet weak var todayMenuTableView: UITableView!
    
    
    @IBOutlet weak var showMoreRecentButton: UIButton!
    @IBOutlet weak var recentPostBaseView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesign()
        
        recentPostTableView.delegate = self
        recentPostTableView.dataSource = self
        recentPostTableView.rowHeight = 35
        recentPostTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let recentPostTableViewNib = UINib(nibName: "RecentPostTableViewCell", bundle: nil)
        recentPostTableView.register(recentPostTableViewNib, forCellReuseIdentifier: "RecentPostTableViewCell")
        
        
        todayMenuTableView.delegate = self
        todayMenuTableView.dataSource = self
        todayMenuTableView.estimatedRowHeight = 200
        todayMenuTableView.rowHeight = UITableView.automaticDimension
    
        todayMenuTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let todayMenuTableViewNib = UINib(nibName: "TodayMenuTableViewCell", bundle: nil)
        todayMenuTableView.register(todayMenuTableViewNib, forCellReuseIdentifier: "TodayMenuTableViewCell")
        
        
        
       
    }
    

    func configureDesign() {
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        
        recentPostBaseView.layer.cornerRadius = 10
        recentPostBaseView.layer.borderWidth = 0.5
        recentPostBaseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
        
    }
    

    @IBAction func searchButtonAction(_ sender: Any) {
        print("검색")
        
        
    }
    
    @IBAction func deliveryButtonAction(_ sender: Any) {
        print("배달")
    }
    
    @IBAction func packageButtonAction(_ sender: Any) {
        print("택배")
    }
    
    
    @IBAction func taxiButtonAction(_ sender: Any) {
        print("택시")
        
    }
    
    
    @IBAction func laundryButtonAction(_ sender: Any) {
        print("빨래")
    }
    
    
    @IBAction func showMoreRecentButtonAction(_ sender: Any) {
        print(123123)
        
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentPostTableView {
            return 6
        } else {
            return 1
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == recentPostTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentPostTableViewCell", for: indexPath) as! RecentPostTableViewCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodayMenuTableViewCell", for: indexPath) as! TodayMenuTableViewCell
            
            return cell
        }
        
        
        
        
        
    }
    
    
}
