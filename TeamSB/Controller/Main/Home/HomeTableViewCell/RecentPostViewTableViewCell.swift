//
//  RecentPostViewTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

protocol TBCellDelegate {
    func selectedTBCell(postNumber: Int, title: String, category: String, time: String, userID: String, nickname: String, contents: String, showCount: Int)
}

class RecentPostViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var showMoreBottomView: UIView!
    @IBOutlet weak var recentPostTableView: UITableView!
    
    lazy var dataManager: MainDataManager = MainDataManager(view: self)
    var recentPost: [RecentPost] = []
    var delegate: TBCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTableView()
        configureDesign()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

//MARK: -기본 UI 함수 정리
extension RecentPostViewTableViewCell {
    
    func setTableView() {
        recentPostTableView.delegate = self
        recentPostTableView.dataSource = self
        recentPostTableView.rowHeight = 35
        
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
}

//MARK: -스토리보드 연동 Action 함수 정리
extension RecentPostViewTableViewCell {
    @IBAction func showMoreButtonAction(_ sender: Any) {
        print(">> 최근 올라온 게시글 화면으로 넘어갑니다.")

    }
}

//MARK: - 테이블뷰 세팅
extension RecentPostViewTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recentPost.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentPostContentsTableViewCell", for: indexPath) as! RecentPostContentsTableViewCell
        cell.selectionStyle = .none
        
        
        let data = recentPost[indexPath.row]

        let category = data.category
        var setCategory = ""
        if category == "delivery" {
            setCategory = "배달"
        } else if category == "parcel" {
            setCategory = "택배"
        } else if category == "taxi" {
            setCategory = "택시"
        } else if category == "laundry" {
            setCategory = "빨래"
        } else {
            setCategory = "에러"
        }

        cell.category.text = setCategory
        cell.title.text = data.title

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            
            let data = recentPost[indexPath.row]
            let sendPostNumber = data.no
            let sendTitle = data.title
            let sendCategory = data.category
            let sendTime = data.timeStamp
            let sendUserID = data.userId
            let sendNickname = data.userNickname
            let sendContents = data.text
            let sendShowCount = data.viewCount
            
            delegate.selectedTBCell(postNumber: sendPostNumber, title: sendTitle, category: sendCategory, time: sendTime, userID: sendUserID, nickname: sendNickname, contents: sendContents, showCount: sendShowCount)
        }
    }
}

//MARK: -UpdateData 프로토콜
extension RecentPostViewTableViewCell: UpdateData {
    func update() {
        recentPost.removeAll()
        dataManager.getRecentPost(view: self)
    }
}

//MARK: -필요 없음
extension RecentPostViewTableViewCell: MainView {
    func setUserNickname(nickname: String) {}
    func setTodayMenu() {}
}
