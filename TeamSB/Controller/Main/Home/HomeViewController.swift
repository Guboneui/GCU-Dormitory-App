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
    @IBOutlet weak var todayMenuCollectionView: UICollectionView!
    
    
    @IBOutlet weak var recentPostTableView: UITableView!
    
    
    
    @IBOutlet weak var showMoreRecentButton: UIButton!
    @IBOutlet weak var recentPostBaseView: UIView!
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDesign()
        
        recentPostTableView.delegate = self
        recentPostTableView.dataSource = self
        recentPostTableView.rowHeight = 35
        recentPostTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let recentPostTableViewNib = UINib(nibName: "RecentPostTableViewCell", bundle: nil)
        recentPostTableView.register(recentPostTableViewNib, forCellReuseIdentifier: "RecentPostTableViewCell")
        
        todayMenuCollectionView.delegate = self
        todayMenuCollectionView.dataSource = self
        let todayMenuCollectionViewNib = UINib(nibName: "TodayMenuCollectionViewCell", bundle: nil)
        todayMenuCollectionView.register(todayMenuCollectionViewNib, forCellWithReuseIdentifier: "TodayMenuCollectionViewCell")
        
        
        
        
       
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


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recentPostTableView {
            return 6
        } else {
            return 1
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentPostTableViewCell", for: indexPath) as! RecentPostTableViewCell
            
            return cell
        }
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = todayMenuCollectionView.dequeueReusableCell(withReuseIdentifier: "TodayMenuCollectionViewCell", for: indexPath) as! TodayMenuCollectionViewCell
        return cell
    }
    
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell = todayMenuCollectionView.dequeueReusableCell(withReuseIdentifier: "TodayMenuCollectionViewCell", for: indexPath) as! TodayMenuCollectionViewCell
    
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        let itemsPerRow: CGFloat = 1    //가로 개수
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 4 //세로 개수
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = cell.menuTypeLabel.frame.height + cell.menuTableView.frame.height + 300
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
    }
    
    
    
}




