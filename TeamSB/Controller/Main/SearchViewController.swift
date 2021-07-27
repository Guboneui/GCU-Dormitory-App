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
    
    
    var category = ""
    var searchKeyWord = ""
    
    
    let dropDown = DropDown()
    let categoryArray = ["전체", "배달", "택배", "택시", "빨래"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        
        
        dropdownLabel.text = "선택"
        
        dropDown.anchorView = dropdownBaseView
        dropDown.dataSource = categoryArray
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            print("selected item: \(item) at index: \(index)")
            self.dropdownLabel.text = categoryArray[index]
        }
        
        
        //다른 공간 클릭 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "검색"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        //getAllPost(page: currentPage)
    }
    
    
    func setTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        let allPostTableViewNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        mainTableView.register(allPostTableViewNib, forCellReuseIdentifier: "SearchTableViewCell")
        mainTableView.rowHeight = 150
        mainTableView.tableFooterView = UIView(frame: .zero)
        
        
    }
    
    
    
    
    
    
    func postSearch(title: String, text: String, page: Int) {
        
        print(">> 전체 데이터 검색")
        
        currentPage += 1
        
        guard
            isLoadedAllData == false
        else {
            return
        }
        
        let PARAM: Parameters = [
            "title": title,
            "text": text
        ]
        
        
        
        let URL = "http://13.209.10.30:3000/search?page=\(currentPage)"
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON { [self] (response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 검색 API 호출 성공")
                    
                    mainTableView.refreshControl?.endRefreshing()
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        
                        
                        if currentPage == 1 && content.count == 0 {
                            let alert = UIAlertController(title: "검색 결과가 없습니다", message: "", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
                        
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
    
    func postSearchWithCategory(category: String, title: String, text: String, page: Int) {
        
        print(">> \(category) 데이터 검색")
        
        currentPage += 1
        
        guard
            isLoadedAllData == false
        else {
            return
        }
        
        
        let PARAM: Parameters = [
            "category": category,
            "title": title,
            "text": text
            
        ]
        
        let URL = "http://13.209.10.30:3000/search?page=\(currentPage)"
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON { [self] (response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 검색 API 호출 성공")
                    
                    
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        
                        
                        if currentPage == 1 && content.count == 0 {
                            let alert = UIAlertController(title: "검색 결과가 없습니다", message: "", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        
                        
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
    
    
    @objc func dismissKeyboard() {  //키보드 숨김처리
        view.endEditing(true)
    }
    
    func resignForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = 0
        let bottom = view.frame.origin.y
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardReactangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardReactangle.height
            self.view.frame.origin.y = bottom - keyboardHeight / 2 + 50
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        category = dropdownLabel.text ?? "선택"
        searchKeyWord = searchTextField.text ?? ""
        view.endEditing(true)
        
        
        if category == "선택" && searchKeyWord != ""{
            let alert = UIAlertController(title: "카테고리를 선택 해주세요", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        } else if category == "선택" && searchKeyWord == "" {
            let alert = UIAlertController(title: "검색어를 입력 해주세요", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            currentPage = 0
            isLoadedAllData = false
            saveData.removeAll()
            
            
            
            
            
            if category == "전체" {
                postSearch(title: searchKeyWord, text: searchKeyWord, page: currentPage)
            } else {
                
                if category == "배달" {
                    category = "delevery"
                } else if category == "택배" {
                    category = "parcel"
                } else if category == "택시" {
                    category = "taxi"
                } else if category == "빨래" {
                    category = "laundry"
                }
                
                postSearchWithCategory(category: category, title: searchKeyWord, text: searchKeyWord, page: currentPage)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
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
            
            if category == "전체" {
                postSearch(title: searchKeyWord, text: searchKeyWord, page: currentPage)
            } else {
                postSearchWithCategory(category: category, title: searchKeyWord, text: searchKeyWord, page: currentPage)
            }
            
            
            
        }
        
        
        //스크롤 위치 확인해보기
        //allPostTableView.scrollToRow(at: IndexPath.init(row: 15, section: 0), at: .middle, animated: true)
    }
    
    
    
}
