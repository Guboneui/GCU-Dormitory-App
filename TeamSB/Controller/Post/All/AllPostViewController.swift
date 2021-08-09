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

    @IBOutlet weak var allPostCollectionView: UICollectionView!
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
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBarItem()
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
        writeButton.tintColor = .black
        searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goSearchView))
        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
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
        return allPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllPostCollectionViewCell", for: indexPath) as! AllPostCollectionViewCell
        
        if allPost.count != 0 {
            let data = allPost[indexPath.row]
            
            cell.nicknameLabel.text = data.userNickname
            cell.categoryLabel.text = data.category
            cell.titleLabel.text = data.title
            cell.contentsLabel.text = data.text
            cell.commentCountLabel.text = String(data.replyCount)
            let profileImage = data.imageSource ?? ""
            let userImage = profileImage.toImage()
            cell.profileImageView.image = userImage
            var time = data.timeStamp
            time = time.substring(from: 11, to: 16)
            cell.timeLabel.text = time

        } else {
            cell.nicknameLabel.text = ""
            cell.categoryLabel.text = ""
            cell.titleLabel.text = ""
            cell.contentsLabel.text = ""
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
        return 16
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
        self.loading.startAnimating()
    }
    func stopLoading() {
        self.loading.stopAnimating()
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
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
