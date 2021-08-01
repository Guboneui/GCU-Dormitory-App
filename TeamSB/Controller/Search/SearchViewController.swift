//
//  SearchViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import DropDown
import Alamofire
import NVActivityIndicatorView

class SearchViewController: UIViewController {
    
    @IBOutlet weak var dropdownBaseView: UIView!
    @IBOutlet weak var dropdownLabel: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var writeButton: UIBarButtonItem!
    
    
    lazy var dataManager: SearchDataManager = SearchDataManager(view: self)
    var searchArray: [Search] = []
    var currentPage = 0
    var isLoadedAllData = false
    var mainCategory: String = ""
    var mainKeyword: String = ""
    
    let dropDown = DropDown()
    let categoryArray = ["전체", "배달", "택배", "택시", "빨래"]
    
    var loading: NVActivityIndicatorView!

//MARK: -생명주기
    
    override func loadView() {
        super.loadView()
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setDropdown()
        setNavigationBarItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemUse()
    }
    
}

//MARK: -기본 UI 함수 정리
extension SearchViewController {
   
    func setLoading() {
        loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: UIColor.SBColor.SB_BaseYellow, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 60),
            loading.heightAnchor.constraint(equalToConstant: 60),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        let allPostTableViewNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        mainTableView.register(allPostTableViewNib, forCellReuseIdentifier: "SearchTableViewCell")
        mainTableView.rowHeight = 150
        mainTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setDropdown() {
        dropdownLabel.text = "선택"
        dropDown.anchorView = dropdownBaseView
        dropDown.dataSource = categoryArray
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            self.dropdownLabel.text = categoryArray[index]
        }
    }
    
    func setNavigationBarItem() {
        self.navigationItem.title = "검색"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
        writeButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = writeButton
        
    }
    
    func navigationItemUse() {
        writeButton.isEnabled = true
        searchButton.isEnabled = true
    }
}

//MARK: -스토리보드 Action 함수 정리
extension SearchViewController {
    
    @IBAction func searchButtonAction(_ sender: Any) {
        self.mainTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        
        
        view.endEditing(true)
        
        
        guard var category = dropdownLabel.text, category != "선택" else {
            self.presentAlert(title: "카테고리를 선택 해주세요.")
            return
        }
        
        guard let searchKeyWord = searchTextField.text?.trim, searchKeyWord.isExists else {
            self.presentAlert(title: "검색어를 입력 해주세요")
            return
        }
        
        loading.startAnimating()
        currentPage = 0
        isLoadedAllData = false
        searchArray.removeAll()
        
        if category == "전체" {
            mainCategory = "전체"
            mainKeyword = searchKeyWord
            let param = SearchRequestNoCategory(keyword: mainKeyword)
            dataManager.postSearchNoCategory(param, viewController: self, page: currentPage)
        } else {

            mainCategory = category
            mainKeyword = searchKeyWord
            let param = SearchRequest(category: mainCategory, keyword: mainKeyword)
            
            dataManager.postSearch(param, viewController: self, page: currentPage)
        }
    }
    
    @IBAction func dropdownAction(_ sender: Any) {
        dropDown.show()
    }
    
    @objc func goWriteView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        //vc.delegate = self
        
        writeButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
}

//MARK: -table view setting
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        let data = searchArray[indexPath.row]
        let category = data.category
    
        cell.categoryLabel.text = category
        cell.titleLabel.text = data.title
        cell.timeLabel.text = data.timeStamp
        cell.contentsLabel.text = data.text
        cell.selectionStyle = .none
        
        if indexPath.row == searchArray.count - 1{
            if mainCategory == "전체" {
                let param = SearchRequestNoCategory(keyword: mainKeyword)
                dataManager.postSearchNoCategory(param, viewController: self, page: currentPage)
            } else {
                let param = SearchRequest(category: mainCategory, keyword: mainKeyword)
                dataManager.postSearch(param, viewController: self, page: currentPage)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "In_Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        let data = searchArray[indexPath.row]
        
        vc.getPostNumber = data.no
        vc.getTitle = data.title
        vc.getCategory = data.category
        vc.getTime = data.timeStamp
        vc.getNickname = data.userNickname
        vc.getContents = data.text
        vc.getShowCount = data.viewCount
        vc.getUserID = data.userId
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -검색 -> 글쓰기 -> 글작성 완료 -> 화면 돌아왔을 때 기획 확인 (보류)
//extension SearchViewController: UpdateData {
//    func update() {
//        currentPage = 0
//        isLoadedAllData = false
//        saveData.removeAll()
//
//        if category == "선택" && searchKeyWord != ""{
//            print(">> 카테고리를 선택해 주세요 ")
//
//        } else if category == "선택" && searchKeyWord == "" {
//            print(">> 검색어를 입력하세요")
//
//        } else {
//            currentPage = 0
//            isLoadedAllData = false
//            saveData.removeAll()
//
//            if category == "전체" {
//                postSearch(keyword: searchKeyWord, page: currentPage)
//            } else {
//
//                if category == "배달" {
//                    category = "delevery"
//                } else if category == "택배" {
//                    category = "parcel"
//                } else if category == "택시" {
//                    category = "taxi"
//                } else if category == "빨래" {
//                    category = "laundry"
//                }
//
//                postSearchWithCategory(category: category, keyword: searchKeyWord,page: currentPage)
//            }
//        }
//
//    }
//}

//MARK: -DataManager 연결 함수
extension SearchViewController: SearchView {
    func stopRefreshControl() {
        self.mainTableView.refreshControl?.endRefreshing()
    }
    func startLoading() {
        self.loading.startAnimating()
    }
    func stopLoading() {
        self.loading.stopAnimating()
    }
    func noSearchResult() {
        self.presentAlert(title: "검색 결과가 없습니다.")
        mainTableView.reloadData()
    }
}
