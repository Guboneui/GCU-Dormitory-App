//
//  DetailPostViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/26.
//

import UIKit
import Alamofire
import IQKeyboardManager


protocol WhenDismissDetailView: AnyObject {
    func reloadView()
}

class DetailPostViewController: UIViewController {
    
    @IBOutlet weak var bottomBaseView: UIView!
    @IBOutlet weak var sendViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    //@IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var getMainTitle = ""
    var getPostNumber: Int = 0
    var getTitle: String = ""
    var getCategory: String = ""
    var getTime: String = ""
    var getUserID: String = ""
    var getNickname: String = ""
    var getContents: String = ""
    var getShowCount: Int = 0
    var getHash: [String] = []
    var getImage: String = ""
    var getReplyCount: Int = 0
    
    var cellHeightsDictionary: NSMutableDictionary = [:]
    
    lazy var dataManager: DetailPostViewDataManager = DetailPostViewDataManager(view: self)
    var comment: [Comment] = []
    var post: [RePost] = []
    var reload = false
    var currentPage = 0
    var isLoadedAllData = false
    
    
    weak var delegate: WhenDismissDetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        print(">> 게시글 작성자 ID = \(getUserID)...닉네임 = \(getNickname)")
        print(">> \(getPostNumber) 게시글의 현재 조회수는 \(getShowCount)")
        
        setTableView()
        
        messageTextView.delegate = self
        
        postAddArticleCount()
        postGetArticleComment()
        configDesign()
       
        checkWriter()
        
        IQKeyboardManager.shared().isEnabled = false
        initNotification()
        
        messageTextView.delegate = self
        messageTextView.text = "내용을 입력 해주세요."
        messageTextView.textColor = UIColor.SBColor.SB_LightGray

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation_Tab()
        makeBackButton()
        print("viewWillAppear")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.reloadView()
        self.tabBarController?.tabBar.isHidden = true
        print("viewDidDisappear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = true
        print("viewWillDisappear")
        
    }
    
}
//MARK: -생명주기(뷰 로드 시)에서 사용되는 API 함수
extension DetailPostViewController {
    func setNavigation_Tab(){
        self.navigationItem.title = "\(getMainTitle)"
        self.navigationController?.navigationBar.isHidden = false
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func postAddArticleCount() {
        let param = AddArticleCountRequest(no: getPostNumber)
        dataManager.postAddArticleCount(param, viewController: self)
    }
    
    func postGetArticleComment() {
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let parama = GetCommentRequest(curUser: userID, article_no: getPostNumber)
        dataManager.postGetArticleComment(parama, viewController: self, page: currentPage)
        
    }
}

//MARK: -기본 UI 함수
extension DetailPostViewController {
    
    func configDesign() {
        bottomBaseView.backgroundColor = .white
        bottomBaseView.layer.cornerRadius = bottomBaseView.frame.height / 2
        bottomBaseView.layer.borderWidth = 2
        bottomBaseView.layer.borderColor = #colorLiteral(red: 0.9764705882, green: 0.8549019608, blue: 0.4705882353, alpha: 1)
        
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
        sendButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.8549019608, blue: 0.4705882353, alpha: 1)
    }

    func setTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.estimatedRowHeight = 130
        mainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    
        
        let mainPostTableViewNib = UINib(nibName: "MainPostTableViewCell", bundle: nil)
        mainTableView.register(mainPostTableViewNib, forCellReuseIdentifier: "MainPostTableViewCell")
        
        let mainCommentsTableViewNib = UINib(nibName: "MainCommentsTableViewCell", bundle: nil)
        mainTableView.register(mainCommentsTableViewNib, forCellReuseIdentifier: "MainCommentsTableViewCell")

        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }
    
    
    func showAdminBarItem() {
        let line = UIBarButtonItem(image: UIImage(named: "line"), style: .plain, target: self, action: #selector(adminPost))
        line.tintColor = .black
        
        navigationItem.rightBarButtonItem = line

    }
    
    func showUserBarItem() {
        let line = UIBarButtonItem(image: UIImage(named: "line"), style: .plain, target: self, action: #selector(showBanAlert))
        line.tintColor = .black
        
        navigationItem.rightBarButtonItem = line
    }
    
    func makeBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    func checkWriter() {
        let userid = UserDefaults.standard.string(forKey: "userID")
        if getUserID == userid {
            print(">> 작성자가 접근하여 수정과 삭제가 모두 가능합니다")
            showAdminBarItem()
        } else {
            print("일반 유저가 접근하여 읽기만 가능")
            showUserBarItem()
        }
    }
    
}

//MARK: -스토리보드 연결 함수
extension DetailPostViewController {
    @objc func refreshData() {
        print(">> 댓글 상단 새로고침&&&&&")
        
        
        
        currentPage = 0
        self.isLoadedAllData = false
        comment.removeAll()
        mainTableView.reloadData()
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let parama = GetCommentRequest(curUser: userID, article_no: getPostNumber)
        dataManager.postGetArticleComment(parama, viewController: self, page: currentPage)
        
        
        
        let param = RePostRequest(no: getPostNumber)
        dataManager.repostArticle(param, viewCcntroller: self)
        
        
    }

    
    @objc func adminPost() {
        let alert = UIAlertController(title: "관리자 권한", message: "", preferredStyle: .actionSheet)
        let editButton = UIAlertAction(title: "게시글 수정", style: .default, handler: { [self] _ in
            print(">> 게시글을 수정합니다.")
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            vc.originNo = self.getPostNumber
            vc.originTitle = self.getTitle
            vc.originCategory = self.getCategory
            vc.originText = self.getContents
            vc.originHash = self.getHash
            vc.originID = self.getUserID
            vc.afterEditDelegate = self
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let deleteButton = UIAlertAction(title: "게시글 삭제", style: .default, handler: { _ in
            print(">> 게시글을 삭제버튼 클릭")
            let alert = UIAlertController(title: "삭제하시겠어요?", message: "", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: {_ in
                print("게시글 삭제 취소")
            })
            let okButton = UIAlertAction(title: "확인", style: .default, handler: {[self] _ in
                let param = DeleteArticleRequest(curUser: UserDefaults.standard.string(forKey: "userID")!, no: getPostNumber)
                dataManager.postDeleteArticleCount(param, viewController: self)
            })
            okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
            alert.addAction(cancelButton)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        editButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        deleteButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        cancelButton.setValue(UIColor(displayP3Red: 255/255, green: 63/255, blue: 63/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(editButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func showBanAlert() {
        let alert = UIAlertController(title: "게시글 신고", message: "", preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let okButton = UIAlertAction(title: "신고", style: .default, handler: {[self] _ in
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "BanPopUPViewController") as! BanPopUPViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.getPostNumber = getPostNumber
            
            self.present(vc, animated: false, completion: nil)
        })
        okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        cancelButton.setValue(UIColor(displayP3Red: 255/255, green: 63/255, blue: 63/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(cancelButton)
        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if messageTextView.text == "" || messageTextView.text == nil {
    
        } else {
            let userID = UserDefaults.standard.string(forKey: "userID")!
            let message = messageTextView.text!
            
            
            let param = PostCommentRequest(article_no: getPostNumber, content: message, curUser: userID)
            dataManager.postSendArticleComment(param, viewController: self)
            messageTextView.text = ""
            
        }
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: -채팅 뷰 + 키보드 정리
extension DetailPostViewController {
    
    func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // 키보드 올라오기
    @objc func keyboardWillShow(noti: Notification) {
        let notiInfo = noti.userInfo!
        // 키보드 높이를 가져옴
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        sendViewBottomMargin.constant = height

        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    // 키보드 내려가기
    @objc func keyboardWillHide(noti: Notification) {
        let notiInfo = noti.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.sendViewBottomMargin.constant = 0

        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: -tableview Setting
extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return comment.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainPostTableViewCell", for: indexPath) as! MainPostTableViewCell
            
            if reload == false {
                cell.titleLabel.text = getTitle
                cell.timeLabel.text = getTime
                cell.adminLabel.text = getNickname
                cell.contentsLabel.text = getContents
                
                var hashString = ""
                
                if getHash.count != 0 {
                    for i in 0..<getHash.count {
                        if i == getHash.count - 1{
                            hashString += "#" + getHash[i]
                        } else {
                            hashString += "#\(getHash[i])\n"
                        }
                    }
                    cell.tagLabel.text = hashString
                } else {
                    cell.tagLabel.text = ""
                }
                
                
//                let imageString = getImage
//                let userProfileImage = imageString.toImage()
//                cell.profileImageView.image = userProfileImage
//
                if getImage == "" || getImage == nil {
                    cell.profileImageView.image = UIImage(named: "default_profileImage")
                } else {
                    let profileImage = getImage ?? ""
                    let userImage = profileImage.toImage()
                    cell.profileImageView.image = userImage
                }
                
                
                
                
                
                
                cell.commentCountLabel.text = String(getReplyCount)
                cell.selectionStyle = .none
            } else {
                let data = post[0]
                cell.titleLabel.text = data.title
                
                cell.timeLabel.text = data.timeStamp
                cell.adminLabel.text = data.userNickname
                cell.contentsLabel.text = data.text
                cell.commentCountLabel.text = String(data.replyCount)
                
                
                if data.imageSource == "" || data.imageSource == nil {
                    cell.profileImageView.image = UIImage(named: "default_profileImage")
                } else {
                    let profileImage = data.imageSource ?? ""
                    let userImage = profileImage.toImage()
                    cell.profileImageView.image = userImage
                }
            
                
                
                var hashString = ""
                
                if data.hash.count != 0 {
                    for i in 0..<data.hash.count {
                        if i == data.hash.count - 1{
                            hashString += "#" + data.hash[i]
                        } else {
                            hashString += "#\(data.hash[i])\n"
                        }
                    }
                    cell.tagLabel.text = hashString
                } else {
                    cell.tagLabel.text = ""
                }
                cell.selectionStyle = .none
            }
            
            
           
            
            return cell
            
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCommentsTableViewCell", for: indexPath) as! MainCommentsTableViewCell
            let data = comment[indexPath.row]
            let deviceID = UserDefaults.standard.string(forKey: "userID")!
            
            cell.nicknameLabel.text = data.userNickname
            cell.commentLabel.text = data.content
            cell.timeLabel.text = data.timeStamp.substring(from: 5, to: 16)
            
            if data.userId == deviceID {
                cell.nicknameLabel.textColor = UIColor.SBColor.SB_BaseYellow
            } else {
                cell.nicknameLabel.textColor = .black
            }
            
            if data.imageSource == "" || data.imageSource == nil {
                cell.profileImageView.image = UIImage(named: "default_profileImage")
            } else {
                let profileImage = data.imageSource ?? ""
                let userImage = profileImage.toImage()
                cell.profileImageView.image = userImage
            }
            
            
            
            cell.selectionStyle = .none
            
            if indexPath.row == comment.count - 1{
                let userID = UserDefaults.standard.string(forKey: "userID")!
                let parama = GetCommentRequest(curUser: userID, article_no: getPostNumber)
                dataManager.postGetArticleComment(parama, viewController: self, page: currentPage)
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if let height = cellHeightsDictionary.object(forKey: indexPath) as? Double {
            return CGFloat(height)
        }
        
        return UITableView.automaticDimension
    }
    
    
}




//MARK: -DataManager 연결 함수
extension DetailPostViewController: DetailPostView {
    func reloadPost() {
        self.reload = true
        self.mainTableView.reloadData()
        
    }
    
    func updateTableView() {
        
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let param = GetCommentRequest(curUser: userID, article_no: self.getPostNumber)
        
        self.currentPage = 0
        self.isLoadedAllData = false
        self.comment.removeAll()
        
        dataManager.postGetArticleComment(param, viewController: self, page: currentPage)
    }
    
    func popView(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: { [self] _ in
            delegate?.reloadView()
            self.navigationController?.popViewController(animated: true)
        })
        okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    func stopRefreshControl() {
        self.mainTableView.refreshControl?.endRefreshing()
    }
    func successPost() {
        self.presentAlert(title: "댓글이 작성되었습니다")
        let size = CGSize(width: view.frame.width, height: self.messageTextView.frame.height)
        let estimatedSize = messageTextView.sizeThatFits(size)
        messageTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
            
        }
    }
}


extension DetailPostViewController: AfterEditDelegate {
    func updateGetData(getPostNumber: Int, getTitle: String, getCategory: String, getUserID: String, getNickname: String, getContents: String, getHash: [String]) {
        self.getPostNumber = getPostNumber
        self.getTitle = getTitle
        self.getMainTitle = getCategory
        self.getCategory = getCategory
        self.getUserID = getUserID
        self.getNickname = getNickname
        self.getContents = getContents
        self.getHash = getHash
    }
    
    func updateComment(articleNO: Int) {
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let secondParam = GetCommentRequest(curUser: userID, article_no: articleNO)
        
        
        self.currentPage = 0
        self.isLoadedAllData = false
        self.comment.removeAll()
        
        dataManager.postGetArticleComment(secondParam, viewController: self, page: currentPage)
    }
    
    func afterEdit(articleNO: Int) {
        let param = RePostRequest(no: articleNO)
        dataManager.repostArticle(param, viewCcntroller: self)
        
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let secondParam = GetCommentRequest(curUser: userID, article_no: articleNO)
        
        self.currentPage = 0
        self.isLoadedAllData = false
        self.comment.removeAll()
        
       
        
        dataManager.postGetArticleComment(secondParam, viewController: self, page: currentPage)
        
    }
    
    
}

extension DetailPostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        //let size = CGSize(width: view.frame.width, height: .infinity)
        let size = CGSize(width: view.frame.width, height: self.messageTextView.frame.height)
       
        let estimatedSize = textView.sizeThatFits(size)
        messageTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        textViewSetupView()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text == "" {
            textViewSetupView()
        }
    }

//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            contentsTextView.resignFirstResponder()
//        }
//        return true
//    }

    func textViewSetupView() {
        if messageTextView.text == "댓글을 입력하세요." {
            messageTextView.text = ""
            messageTextView.textColor = UIColor.black
        } else if messageTextView.text == ""{
            messageTextView.text = "댓글을 입력하세요."
            messageTextView.textColor = UIColor.SBColor.SB_LightGray
        }
    }
}

