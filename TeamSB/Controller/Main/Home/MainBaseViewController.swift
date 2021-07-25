//
//  MainBaseViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

class MainBaseViewController: UIViewController {

    @IBOutlet weak var baseTableView: UITableView!
    @IBOutlet weak var writeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var settingBarButtonItem: UIBarButtonItem!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "홈"
        self.tabBarController?.tabBar.isHidden = false
        
        baseTableView.reloadData()
        
    }
    
    func succNetWork(test: String) {
        baseTableView.reloadData()
    }
    
    
    func setTableView() {
        baseTableView.delegate = self
        baseTableView.dataSource = self
        baseTableView.rowHeight = UITableView.automaticDimension
        baseTableView.estimatedRowHeight = 100
        baseTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        baseTableView.allowsSelection = false
    
        
        let searchButtonTableViewCellNib = UINib(nibName: "SearchButtonTableViewCell", bundle: nil)
        baseTableView.register(searchButtonTableViewCellNib, forCellReuseIdentifier: "SearchButtonTableViewCell")
        
        let categoryButtonTableViewCellNib = UINib(nibName: "CategoryButtonTableViewCell", bundle: nil)
        baseTableView.register(categoryButtonTableViewCellNib, forCellReuseIdentifier: "CategoryButtonTableViewCell")
        
        let recentPostViewTableViewCellNib = UINib(nibName: "RecentPostViewTableViewCell", bundle: nil)
        baseTableView.register(recentPostViewTableViewCellNib, forCellReuseIdentifier: "RecentPostViewTableViewCell")
        
        let nowTimeMenuTableViewCellNib = UINib(nibName: "NowTimeMenuTableViewCell", bundle: nil)
        baseTableView.register(nowTimeMenuTableViewCellNib, forCellReuseIdentifier: "NowTimeMenuTableViewCell")
    }
    
    @IBAction func writeBarButtonAction(_ sender: Any) {
        print("글쓰기 화면으로 이동합니다.")
        let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settingBarButtonAction(_ sender: Any) {
        print("세팅 화면으로 이동합니다.")
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    


}

extension MainBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchButtonTableViewCell", for: indexPath) as! SearchButtonTableViewCell
            cell.searchButton.addTarget(self, action: #selector(goSearchView), for: .touchUpInside)
            

            return cell
            
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryButtonTableViewCell", for: indexPath) as! CategoryButtonTableViewCell
            cell.delevaryButton.addTarget(self, action: #selector(goDelevaryView), for: .touchUpInside)
            cell.postButton.addTarget(self, action: #selector(goPostView), for: .touchUpInside)
            cell.taxiButton.addTarget(self, action: #selector(goTaxiView), for: .touchUpInside)
            cell.laundaryButton.addTarget(self, action: #selector(goLaundayView), for: .touchUpInside)
            
            return cell
            
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentPostViewTableViewCell", for: indexPath) as! RecentPostViewTableViewCell
            
            cell.showMoreButton.addTarget(self, action: #selector(goShowMoreView), for: .touchUpInside)
            cell.getRecentPost()
            
            
            print(indexPath)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NowTimeMenuTableViewCell", for: indexPath) as! NowTimeMenuTableViewCell
            
           
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func goSearchView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goDelevaryView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeleveryViewController") as! DeleveryViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func goPostView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ParcelViewController") as! ParcelViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func goTaxiView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TaxiViewController") as! TaxiViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func goLaundayView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LaundryViewController") as! LaundryViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func goShowMoreView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowMoreViewController") as! ShowMoreViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
