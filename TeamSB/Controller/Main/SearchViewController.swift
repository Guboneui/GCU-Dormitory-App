//
//  SearchViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import DropDown
import Alamofire

class SearchViewController: UIViewController {

    @IBOutlet weak var dropdownBaseView: UIView!
    @IBOutlet weak var dropdownLabel: UILabel!
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var saveData = [Any]()
    var requestPage = 0
    var currentPage = 0
    var isLoadedAllData = false
    
    
    let dropDown = DropDown()
    let categoryArray = ["전체", "배달", "택배", "택시", "빨래"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        
        
        dropdownLabel.text = "전체"
        
        dropDown.anchorView = dropdownBaseView
        dropDown.dataSource = categoryArray
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            print("selected item: \(item) at index: \(index)")
            self.dropdownLabel.text = categoryArray[index]
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "검색"
        //getAllPost(page: currentPage)
    }
    

    func setTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        let allPostTableViewNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        mainTableView.register(allPostTableViewNib, forCellReuseIdentifier: "SearchTableViewCell")
        mainTableView.rowHeight = 120
        
//        mainTableView.refreshControl = UIRefreshControl()
//        mainTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
//    @objc func refreshData() {
//        print(">> 상단 새로고침")
//        currentPage = 0
//        self.isLoadedAllData = false
//        saveData.removeAll()
//        mainTableView.reloadData()
//        getAllPost(page: currentPage)
//
//    }

    
    func postSearch(category: String, title: String, text: String, page: Int) {
        
        currentPage += 1
        
        guard
            isLoadedAllData == false
        else {
            return
        }
        
        
        
        let URL = "http://13.209.10.30:3000/home/all?page=\(currentPage)"
        let alamo = AF.request(URL, method: .get, parameters: nil).validate(statusCode: 200...500)
        
        alamo.responseJSON { [self] (response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 모든 게시글 API 호출 성공")
                    
                    mainTableView.refreshControl?.endRefreshing()
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        guard content.count > 0 else {
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(saveData.count)")
                            self.isLoadedAllData = true
                            return
                        }
                        
                        
                        for i in 0..<content.count {
                            saveData.append(content[i])
                        }
                        print(">> \(URL)")
                        print(">> 읽어온 게시글의 개수: \(content.count), 현재 페이지\(page+1)")
                        mainTableView.reloadData()
                    }
                  
                }
            case .failure(let error):
                if let jsonObj = error as? NSDictionary {
                    print("서버통신 실패")
                    print(error)
                }
                
            }
            
        }
    }
    
    
    @IBAction func dropdownAction(_ sender: Any) {
        dropDown.show()
    }
    
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return saveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPostTableViewCell", for: indexPath) as! AllPostTableViewCell
        
        let data = saveData[indexPath.row] as! NSDictionary
        
        
        let category = data["category"] as! String
        if category == "delivery" {
            cell.categoryLabel.text = "배달"
        } else if category == "parcel" {
            cell.categoryLabel.text = "택배"
        } else if category == "taxi" {
            cell.categoryLabel.text = "택시"
        } else if category == "laundry" {
            cell.categoryLabel.text = "빨래"
        } else {
            cell.categoryLabel.text = "error"
        }
        
        
        cell.titleLabel.text = data["title"] as? String
        cell.timeLabel.text = data["timeStamp"] as? String
        cell.contentsLabel.text = data["text"] as? String
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (mainTableView.contentSize.height - 100 - scrollView.frame.size.height) {
            getAllPost(page: currentPage)
        }
        
        
        //스크롤 위치 확인해보기
        //allPostTableView.scrollToRow(at: IndexPath.init(row: 15, section: 0), at: .middle, animated: true)
    }
    
    
    
}
