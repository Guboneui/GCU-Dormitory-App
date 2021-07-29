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
    
    var recentData = [AnyObject]()
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var showMoreBottomView: UIView!
    @IBOutlet weak var recentPostTableView: UITableView!
    
    var delegate: TBCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTableView()
        configureDesign()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
//MARK: -기본 UI 함수 정리
    
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

//MARK: -스토리보드 연동 Action 함수 정리
    
    @IBAction func showMoreButtonAction(_ sender: Any) {
        print("최근 올라온 게시글 화면으로 넘어갑니다.")
        
    }
    

//MARK: -API 함수
    
    func getRecentPost() {
        
        recentData.removeAll()
        
        let URL = "http://13.209.10.30:3000/home/recentPost"
        let alamo = AF.request(URL, method: .get, parameters: nil).validate(statusCode: 200...500)
        
        alamo.responseJSON{ [self](response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 최근 게시글 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        for i in 0..<content.count {
                            recentData.append(content[i] as! NSDictionary)
                        }
                        
                        recentPostTableView.reloadData()
                        
                        
                    } else {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(message)
                    }
                }
            case .failure(let error) :
                if let jsonObj = error as? NSDictionary {
                    print("서버통신 실패")
                    print(jsonObj)
                    
                }
            }
        }
    }
}

extension RecentPostViewTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(">> RecentPostViewTableViewCell getRecentDataCount: \(recentData.count)")
        return recentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentPostContentsTableViewCell", for: indexPath) as! RecentPostContentsTableViewCell
        cell.selectionStyle = .none
        
        
        let data = recentData[indexPath.row]
        
        let category = data["category"] as? String
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
        cell.title.text = data["title"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            
            let data = recentData[indexPath.row]
            let sendPostNumber = data["no"] as! Int
            let sendTitle = data["title"] as! String
            let sendCategory = data["category"] as! String
            let sendTime = data["timeStamp"] as! String
            let sendUserID = data["userId"] as! String
            let sendNickname = data["userNickname"] as! String
            let sendContents = data["text"] as! String
            let sendShowCount = data["viewCount"] as! Int
            
            delegate.selectedTBCell(postNumber: sendPostNumber, title: sendTitle, category: sendCategory, time: sendTime, userID: sendUserID, nickname: sendNickname, contents: sendContents, showCount: sendShowCount)
        }
    }
}

extension RecentPostViewTableViewCell: UpdateData {
    func update() {
        recentData = []
        getRecentPost()
    }
}

