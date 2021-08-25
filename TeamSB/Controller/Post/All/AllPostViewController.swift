//
//  ShowMoreViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ShowMoreViewController: UIViewController {

    @IBOutlet weak var noPostImageView: UIImageView!
    @IBOutlet weak var allPostCollectionView: UICollectionView!
    @IBOutlet weak var topGuideLineView: UIView!
    var writeButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    var loading: NVActivityIndicatorView!
    
    lazy var dataManager: AllPostDataManager = AllPostDataManager(view: self)
    var allPost: [AllPost] = []
    var currentPage = 0
    var isLoadedAllData = false
    
    var cellIdx: Int?
    let deviceType = UIDevice().type
    
//MARK: -생명주기
    override func loadView() {
        super.loadView()
        setLoading()
        print(deviceType)
        
        switch deviceType {
        case .iPhone4, .iPhone5, .iPhone6, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneSE, .iPhoneSE2 :
            NSLayoutConstraint.activate([
                allPostCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ])
            break
            
        default :
            NSLayoutConstraint.activate([
                allPostCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 17)
            ])
            break
        }
        
        topGuideLineView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topGuideLineView.layer.shadowOpacity = 0.15
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
        navigationItemUse()
    }

}

//MARK: -기본 UI 함수
extension ShowMoreViewController {
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
        allPostCollectionView.delegate = self
        allPostCollectionView.dataSource = self
        allPostCollectionView.register(UINib(nibName: "AllPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllPostCollectionViewCell")
        allPostCollectionView.refreshControl = UIRefreshControl()
        allPostCollectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func setNavigationBarItem() {
        self.navigationItem.title = "게시글"
        self.tabBarController?.tabBar.isHidden = true
        writeButton = UIBarButtonItem(image: UIImage(named: "write_icon"), style: .plain, target: self, action: #selector(goWriteView))
        writeButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        writeButton.tintColor = .black
        searchButton = UIBarButtonItem(image: UIImage(named: "search_icon"), style: .plain, target: self, action: #selector(goSearchView))
        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
        searchButton.tintColor = .black
        backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.rightBarButtonItems = [writeButton, searchButton]
        
    }
    
    func navigationItemUse() {
        writeButton.isEnabled = true
        searchButton.isEnabled = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

//MARK: -스토리보드 Action 함수
extension ShowMoreViewController {
    
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        allPost.removeAll()
        allPostCollectionView.reloadData()
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
    
    @objc func goWriteView() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        vc.delegate = self
        
        writeButton.isEnabled = false
        searchButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goSearchView() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        writeButton.isEnabled = false
        searchButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
        
}

//MARK: -tableView 세팅
extension ShowMoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allPost.count == 0 {
            noPostImageView.isHidden = false
             
        } else {
            noPostImageView.isHidden = true
        }
        return allPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllPostCollectionViewCell", for: indexPath) as! AllPostCollectionViewCell
        
        if allPost.count != 0 {
            let data = allPost[indexPath.row]
            
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
            
            
            if data.imageSource == "" || data.imageSource == nil {
                cell.profileImageView.image = UIImage(named: "default_profileImage")
            } else {
                let profileImage = data.imageSource ?? ""
                let userImage = profileImage.toImage()
                cell.profileImageView.image = userImage
            }
            
            
            
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
        
        if indexPath.row == allPost.count - 1 {
            dataManager.getAllPost(viewController: self, page: currentPage)
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

        let data = allPost[indexPath.row]
        let param = ExistsArticleRequest(no: data.no)

        dataManager.postExist(param, viewController: self)
    }
}


extension ShowMoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

     
        return CGSize(width: self.allPostCollectionView.frame.width * 0.43, height: self.allPostCollectionView.frame.width * 0.39)
       
        
    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}


//MARK: -UpdateData 프로토콜
extension ShowMoreViewController: UpdateData {
    func update() {
        allPostCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        currentPage = 0
        isLoadedAllData = false
        allPost.removeAll()
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
}

//MARK: -삭제 했을 경우 새로 고침
extension ShowMoreViewController: WhenDismissDetailView {
    func reloadView() {
        currentPage = 0
        isLoadedAllData = false
        allPost.removeAll()
        
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
    
    
    
}

//MARK: -DataManager 연결 함수
extension ShowMoreViewController: AllPostView {
    func stopRefreshControl() {
        self.allPostCollectionView.refreshControl?.endRefreshing()
    }
    
    func startLoading() {
        //self.loading.startAnimating()
        CustomLoader.instance.showLoader()
    }
    func stopLoading() {
        //self.loading.stopAnimating()
        CustomLoader.instance.hideLoader()
    }
    
    func goArticle() {
        let storyBoard = UIStoryboard(name: "In_Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        let data = allPost[cellIdx!]
        
        vc.getPostNumber = data.no
        vc.getTitle = data.title
        vc.getCategory = data.category
        vc.getTime = data.timeStamp
        vc.getNickname = data.userNickname
        vc.getContents = data.text
        vc.getShowCount = data.viewCount
        vc.getUserID = data.userId
        vc.delegate = self
        vc.getHash = data.hash
        vc.getImage = data.imageSource ?? ""
        vc.getMainTitle = data.category
        vc.getReplyCount = data.replyCount
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

