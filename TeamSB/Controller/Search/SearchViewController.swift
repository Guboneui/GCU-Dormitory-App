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
    
   
    @IBOutlet weak var textFieldBaseView: UIView!
    @IBOutlet weak var fileterButton: UIButton!
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var cellIdx: Int?
    
    var writeButton: UIBarButtonItem!
    
    
    lazy var dataManager: SearchDataManager = SearchDataManager(view: self)
    var searchArray: [Search] = []
    var currentPage = 0
    var isLoadedAllData = false
    var mainCategory: String = ""
    var mainKeyword: String = ""
    
    var filter = ""
    
    let dropDown = DropDown()
    let categoryArray = ["전체", "배달", "택배", "택시", "룸메"]
    
    var loading: NVActivityIndicatorView!

//MARK: -생명주기
    
    override func loadView() {
        super.loadView()
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBarItem()
        configDesign()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemUse()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func filterButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "카테고리", message: "", preferredStyle: .alert)
        let all = UIAlertAction(title: "전체", style: .default, handler: { [self] _ in
            fileterButton.backgroundColor = UIColor.SBColor.SB_BaseYellow
            filterImage.image = UIImage(named: "filter")
            fileterButton.layer.borderWidth = 0
            filter = "전체"
        })
        let delivery = UIAlertAction(title: "배달", style: .default, handler: { [self] _ in
            fileterButton.backgroundColor = .white
            fileterButton.layer.borderWidth = 0.8
            fileterButton.layer.borderColor = #colorLiteral(red: 0.5032311678, green: 0.731662035, blue: 0.2278972864, alpha: 1)
            filterImage.image = UIImage(named: "A")
            filter = "배달"
            
        })
       
        let post = UIAlertAction(title: "택배", style: .default, handler: { [self] _ in
            fileterButton.backgroundColor = .white
            fileterButton.layer.borderWidth = 0.8
            fileterButton.layer.borderColor = #colorLiteral(red: 0.9967921376, green: 0.6303713918, blue: 0.1839940846, alpha: 1)
            filterImage.image = UIImage(named: "B")
            filter = "택배"
            
        })
        let taxi = UIAlertAction(title: "택시", style: .default, handler: { [self] _ in
            fileterButton.backgroundColor = .white
            fileterButton.layer.borderWidth = 0.8
            fileterButton.layer.borderColor = #colorLiteral(red: 0.1688935161, green: 0.2733621895, blue: 0.489726305, alpha: 1)
            filterImage.image = UIImage(named: "C")
            filter = "택시"
            
        })
        let roomMate = UIAlertAction(title: "룸메", style: .default, handler: { [self] _ in
            fileterButton.backgroundColor = .white
            fileterButton.layer.borderWidth = 0.8
            fileterButton.layer.borderColor = #colorLiteral(red: 0.006499502808, green: 0.692831099, blue: 0.8687831163, alpha: 1)
            filterImage.image = UIImage(named: "D")
            filter = "룸메"
            
        })
        
        
        
        all.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        delivery.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        post.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        taxi.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        roomMate.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        
        
        
        
        
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(all)
        alert.addAction(delivery)
        alert.addAction(post)
        alert.addAction(taxi)
        alert.addAction(roomMate)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}

//MARK: -기본 UI 함수 정리
extension SearchViewController {
    
    func configDesign() {
        textFieldBaseView.layer.cornerRadius = textFieldBaseView.frame.height / 2
        textFieldBaseView.layer.borderWidth = 1
        textFieldBaseView.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        
        fileterButton.layer.cornerRadius = fileterButton.frame.height / 2
        fileterButton.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        
        
        searchButton.layer.cornerRadius = searchButton.frame.height / 2
        searchButton.layer.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.8549019608, blue: 0.4705882353, alpha: 1)
    }
    
   
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
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
    }
    
    
    
    func setNavigationBarItem() {
        self.navigationItem.title = "검색"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
        writeButton.tintColor = .black
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        
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
        self.mainCollectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        
        
        view.endEditing(true)
        
        guard filter != "" else {
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
        
        if filter == "전체" {
            mainCategory = "전체"
            mainKeyword = searchKeyWord
            let param = SearchRequestNoCategory(keyword: mainKeyword)
            dataManager.postSearchNoCategory(param, viewController: self, page: currentPage)
        } else {

            mainCategory = filter
            mainKeyword = searchKeyWord
            let param = SearchRequest(category: mainCategory, keyword: mainKeyword)

            dataManager.postSearch(param, viewController: self, page: currentPage)
        }
    }
    
 
    
    @objc func goWriteView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        //vc.delegate = self
        
        writeButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        
        if searchArray.count != 0 {
            let data = searchArray[indexPath.row]
            
            cell.nicknameLabel.text = data.userNickname
            cell.categoryLabel.text = data.category
            cell.titleLabel.text = data.title
                        
            if data.hash.count == 0 {
                cell.tagLabel0.text = " "
                cell.tagLabel1.text = " "
                cell.tagLabel2.text = " "
            } else if data.hash.count == 1 {
                
                let text0 = data.hash[0]
                cell.tagLabel0.text = "# \(text0)"
                let attributedString = NSMutableAttributedString(string: cell.tagLabel0.text!)
                attributedString.addAttribute(.foregroundColor, value: UIColor.SBColor.SB_BaseYellow, range: (cell.tagLabel0.text! as NSString).range(of: "#"))
                attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: (cell.tagLabel0.text! as NSString).range(of: "#"))
                
                
                cell.tagLabel0.attributedText = attributedString
                
                cell.tagLabel1.text = ""
                cell.tagLabel2.text = ""
                
            } else if data.hash.count == 2 {
                let text0 = data.hash[0]
                cell.tagLabel0.text = "# \(text0)"
                let attributedString0 = NSMutableAttributedString(string: cell.tagLabel0.text!)
                attributedString0.addAttribute(.foregroundColor, value: UIColor.SBColor.SB_BaseYellow, range: (cell.tagLabel0.text! as NSString).range(of: "#"))
                attributedString0.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: (cell.tagLabel0.text! as NSString).range(of: "#"))
                cell.tagLabel0.attributedText = attributedString0
                
                let text1 = data.hash[1]
                cell.tagLabel1.text = "# \(text1)"
                let attributedString1 = NSMutableAttributedString(string: cell.tagLabel1.text!)
                attributedString1.addAttribute(.foregroundColor, value: UIColor.SBColor.SB_BaseYellow, range: (cell.tagLabel1.text! as NSString).range(of: "#"))
                attributedString1.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: (cell.tagLabel1.text! as NSString).range(of: "#"))
                cell.tagLabel1.attributedText = attributedString1
                
                cell.tagLabel2.text = ""
                
            } else if data.hash.count == 3 {
                let text0 = data.hash[0]
                cell.tagLabel0.text = "# \(text0)"
                let attributedString0 = NSMutableAttributedString(string: cell.tagLabel0.text!)
                attributedString0.addAttribute(.foregroundColor, value: UIColor.SBColor.SB_BaseYellow, range: (cell.tagLabel0.text! as NSString).range(of: "#"))
                attributedString0.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: (cell.tagLabel0.text! as NSString).range(of: "#"))
                cell.tagLabel0.attributedText = attributedString0
                
                let text1 = data.hash[1]
                cell.tagLabel1.text = "# \(text1)"
                let attributedString1 = NSMutableAttributedString(string: cell.tagLabel1.text!)
                attributedString1.addAttribute(.foregroundColor, value: UIColor.SBColor.SB_BaseYellow, range: (cell.tagLabel1.text! as NSString).range(of: "#"))
                attributedString1.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: (cell.tagLabel1.text! as NSString).range(of: "#"))
                cell.tagLabel1.attributedText = attributedString1
                
                let text2 = data.hash[2]
                cell.tagLabel2.text = "# \(text2)"
                let attributedString2 = NSMutableAttributedString(string: cell.tagLabel2.text!)
                attributedString2.addAttribute(.foregroundColor, value: UIColor.SBColor.SB_BaseYellow, range: (cell.tagLabel2.text! as NSString).range(of: "#"))
                attributedString2.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: (cell.tagLabel2.text! as NSString).range(of: "#"))
                cell.tagLabel2.attributedText = attributedString2
                
                
            } else {
                cell.tagLabel0.text = " "
                cell.tagLabel1.text = " "
                cell.tagLabel2.text = " "
            }
 
            
            cell.commentCountLabel.text = String(data.replyCount)
            let profileImage = data.imageSource ?? ""
            let userImage = profileImage.toImage()
            cell.profileImageView.image = userImage
            
            let formatter        = DateFormatter()
            formatter.locale     = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var time = data.timeStamp
            //현재 시간 값을 받아옴
            let today: String = formatter.string(from: Date())
            
            let nowDay = today.substring(from: 0, to: 10)
            let nowHour = Int(today.substring(from: 11, to: 13))!
            let nowMinute = Int(today.substring(from: 14, to: 16))!
            
            let articleDay = time.substring(from: 0, to: 10)
            let articleHour = Int(time.substring(from: 11, to: 13))!
            let articleMinute = Int(time.substring(from: 14, to: 16))!
            
            let totalArticleTime = articleHour * 60 + articleMinute
            let totalNowTime = nowHour * 60 + nowMinute
            
            if nowDay == articleDay {
                if totalNowTime - totalArticleTime < 60 {
                    cell.timeLabel.text = String((totalNowTime - totalArticleTime) % 60)+"분 전"
                } else {
                    //cell.timeLabel.text = String((totalNowTime - totalArticleTime) / 60)+"시간 전"
                    cell.timeLabel.text = time.substring(from: 11, to: 16)
                }
            } else {
                cell.timeLabel.text = time.substring(from: 5, to: 10)
            }
            
        } else {
            cell.nicknameLabel.text = ""
            cell.categoryLabel.text = ""
            cell.titleLabel.text = ""
            cell.tagLabel0.text = ""
            cell.tagLabel1.text = ""
            cell.tagLabel2.text = ""
            //cell.contentsLabel.text = ""
            cell.commentCountLabel.text = String(0)
        }
        
        if indexPath.row == searchArray.count - 1 {
            
            if filter == "전체" {
                let param = SearchRequestNoCategory(keyword: mainKeyword)
                dataManager.postSearchNoCategory(param, viewController: self, page: currentPage)
            } else {
                let param = SearchRequest(category: filter, keyword: mainKeyword)
                dataManager.postSearch(param, viewController: self, page: currentPage)
            }
        }
     
        
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 6, height: 4)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.15
        cell.layer.masksToBounds = false //<-
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellIdx = indexPath.row

        let data = searchArray[indexPath.row]
        let param = ExistsArticleRequest(no: data.no)

        dataManager.postExist(param, viewController: self)
    }
}


extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

     
        return CGSize(width: self.mainCollectionView.frame.width * 0.43, height: self.mainCollectionView.frame.width * 0.39)
       
        
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
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
    func goArticle() {
        let storyBoard = UIStoryboard(name: "In_Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        let data = searchArray[cellIdx!]
        
        vc.getPostNumber = data.no
        vc.getTitle = data.title
        vc.getCategory = data.category
        vc.getTime = data.timeStamp
        vc.getNickname = data.userNickname
        vc.getContents = data.text
        vc.getShowCount = data.viewCount
        vc.getUserID = data.userId
        //vc.delegate = self
        vc.getHash = data.hash
        //vc.getImage = data.imageSource ?? ""
        vc.getMainTitle = data.category
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func stopRefreshControl() {
        self.mainCollectionView.refreshControl?.endRefreshing()
    }
    func startLoading() {
        self.loading.startAnimating()
    }
    func stopLoading() {
        self.loading.stopAnimating()
    }
    func noSearchResult() {
        self.presentAlert(title: "검색 결과가 없습니다.")
        mainCollectionView.reloadData()
    }
}
