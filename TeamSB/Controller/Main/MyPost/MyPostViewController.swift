//
//  MyPostViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/10.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class MyPostViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var topGuideLineView: UIView!
    
    var writeButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    var loading: NVActivityIndicatorView!
    var myPost: [MyPost] = []
    var currentPage = 0
    var isLoadedAllData = false
    var cellIdx: Int?
    
    lazy var dataManager: MyPostDataManager = MyPostDataManager(view: self)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLoading()
        setTableView()
        configDesign()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
        
        loading.startAnimating()
        currentPage = 0
        self.isLoadedAllData = false
        myPost.removeAll()
        mainCollectionView.reloadData()
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = MyPostRequest(curUser: id)
        dataManager.postMyArticle(param, viewController: self, page: currentPage)
    }
    
    
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        myPost.removeAll()
    
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = MyPostRequest(curUser: id)
        dataManager.postMyArticle(param, viewController: self, page: currentPage)
        
    }


}
extension MyPostViewController {
    func configDesign() {
        topGuideLineView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topGuideLineView.layer.shadowOpacity = 0.15
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
        mainCollectionView.register(UINib(nibName: "MyPostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyPostCollectionViewCell")
        mainCollectionView.refreshControl = UIRefreshControl()
        mainCollectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func setNavigationBarItem() {
        self.navigationItem.title = "나의 글"
        self.tabBarController?.tabBar.isHidden = true
        writeButton = UIBarButtonItem(image: UIImage(named: "write_icon"), style: .plain, target: self, action: #selector(goWriteView))
        writeButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        writeButton.tintColor = .black
        searchButton = UIBarButtonItem(image: UIImage(named: "search_icon"), style: .plain, target: self, action: #selector(goSearchView))
        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
        searchButton.tintColor = .black
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationItem.rightBarButtonItems = [writeButton, searchButton]
        
        self.tabBarController?.tabBar.isHidden = false

    }

    func navigationItemUse() {
        writeButton.isEnabled = true
        searchButton.isEnabled = true
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
}

extension MyPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostCollectionViewCell", for: indexPath) as! MyPostCollectionViewCell
        
        if myPost.count != 0 {
            let data = myPost[indexPath.row]
            
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
            
            
            if data.imageSource == "" || data.imageSource == nil {
                cell.profileImageView.image = UIImage(named: "default_profileImage")
            } else {
                let profileImage = data.imageSource ?? ""
                let userImage = profileImage.toImage()
                cell.profileImageView.image = userImage
            }

        } else {
            cell.nicknameLabel.text = ""
            cell.categoryLabel.text = ""
            cell.titleLabel.text = ""
            cell.tagLabel0.text = " "
            cell.tagLabel1.text = " "
            cell.tagLabel2.text = " "
            cell.commentCountLabel.text = String(0)
        }
        
        if indexPath.row == myPost.count - 1 {
            let id = UserDefaults.standard.string(forKey: "userID")!
            let param = MyPostRequest(curUser: id)
            dataManager.postMyArticle(param, viewController: self, page: currentPage)
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

        let data = myPost[indexPath.row]
        let param = ExistsArticleRequest(no: data.no)

        dataManager.postExist(param, viewController: self)
    }
    
    
}


extension MyPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

     
        return CGSize(width: self.mainCollectionView.frame.width * 0.43, height: self.mainCollectionView.frame.width * 0.39)
       
        
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}



extension MyPostViewController: MyPostView {
    func stopRefreshControl() {
        self.mainCollectionView.refreshControl?.endRefreshing()
    }
    
    func startLoading() {
        self.loading.startAnimating()
    }
    
    func stopLoading() {
        self.loading.stopAnimating()
    }
    
    func goArticle() {
        let storyBoard = UIStoryboard(name: "In_Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        let data = myPost[cellIdx!]
        
        vc.getPostNumber = data.no
        vc.getTitle = data.title
        vc.getCategory = data.category
        vc.getTime = data.timeStamp
        vc.getNickname = data.userNickname
        vc.getContents = data.text
        vc.getShowCount = data.viewCount
        vc.getUserID = data.userId
        vc.getHash = data.hash 
        vc.getImage = data.imageSource ?? ""
        vc.getMainTitle = data.category
        vc.getReplyCount = data.replyCount
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension MyPostViewController: UpdateData {
    func update() {
        mainCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        currentPage = 0
        isLoadedAllData = false
        myPost.removeAll()
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = MyPostRequest(curUser: id)
        dataManager.postMyArticle(param, viewController: self, page: currentPage)
    }
}
