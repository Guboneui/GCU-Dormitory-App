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
    
    var loading: NVActivityIndicatorView!
    
    lazy var dataManager: MyPostDataManager = MyPostDataManager(view: self)
    var myPost: [MyPost] = []
    var currentPage = 0
    var isLoadedAllData = false
    var cellIdx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setLoading()
        setTableView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loading.startAnimating()
        mainCollectionView.reloadData()
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = MyPostRequest(curUser: id)
        dataManager.postMyArticle(param, viewController: self, page: currentPage)
        
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        myPost.removeAll()
        mainCollectionView.reloadData()
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = MyPostRequest(curUser: id)
        dataManager.postMyArticle(param, viewController: self, page: currentPage)
    }
    


}
extension MyPostViewController {
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
    
//    func setNavigationBarItem() {
//        self.navigationItem.title = "게시글"
//        self.tabBarController?.tabBar.isHidden = true
//        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
//        writeButton.tintColor = .black
//        searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goSearchView))
//        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
//        searchButton.tintColor = .black
//        backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
//        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        backButton.tintColor = .black
//
//        navigationItem.leftBarButtonItem = backButton
//
//        navigationItem.rightBarButtonItems = [writeButton, searchButton]
//
//    }
//
//    func navigationItemUse() {
//        writeButton.isEnabled = true
//        searchButton.isEnabled = true
//    }
    
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
            cell.contentsLabel.text = data.text
            cell.commentCountLabel.text = String(data.replyCount)
            var time = data.timeStamp
            time = time.substring(from: 11, to: 16)
            cell.timeLabel.text = time
            //let profileImage = data.imageSource ?? ""
            //let userImage = profileImage.toImage()
            //cell.profileImageView.image = userImage

        } else {
            cell.nicknameLabel.text = ""
            cell.categoryLabel.text = ""
            cell.titleLabel.text = ""
            cell.contentsLabel.text = ""
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
        return 16
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
        vc.delegate = self
        vc.getHash = data.hash ?? []
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension MyPostViewController: WhenDismissDetailView {
    func reloadView() {
        currentPage = 0
        isLoadedAllData = false
        myPost.removeAll()
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = MyPostRequest(curUser: id)
        dataManager.postMyArticle(param, viewController: self, page: currentPage)
    }
    
    
    
}
