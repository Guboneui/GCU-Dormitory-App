//
//  RecentPostViewTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit

class RecentPostViewTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var showMoreBottomView: UIView!
    
    var getRecentData = [AnyObject]()
    

    @IBOutlet weak var recentPostTableView: UITableView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    
        
        setTableView()
        configureDesign()
    }
    
    
    func setTableView() {
        recentPostTableView.delegate = self
        recentPostTableView.dataSource = self
        
        recentPostTableView.rowHeight = 30
        
        
        
        let recentPostContentsTableViewCellNib = UINib(nibName: "RecentPostContentsTableViewCell", bundle: nil)
        recentPostTableView.register(recentPostContentsTableViewCellNib, forCellReuseIdentifier: "RecentPostContentsTableViewCell")
    }
    
    func configureDesign() {
        baseView.layer.cornerRadius = 10
        baseView.layer.borderWidth = 0.5
        baseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
        
        showMoreButton.tintColor = UIColor.SBColor.SB_LightGray
        showMoreBottomView.backgroundColor = UIColor.SBColor.SB_DarkGray
        
    }
    
    
    @IBAction func showMoreButtonAction(_ sender: Any) {
        print("최근 올라온 게시글 화면으로 넘어갑니다.")
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RecentPostViewTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(">> RecentPostViewTableViewCell getRecentDataCount: \(getRecentData.count)")
        return getRecentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentPostContentsTableViewCell", for: indexPath) as! RecentPostContentsTableViewCell
        cell.selectionStyle = .none
        
        
        let data = getRecentData[indexPath.row]
        
        
        cell.category.text = data["category"] as? String
        cell.title.text = data["title"] as? String
        
        
        
        return cell
    }
    
    
}
