//
//  EditViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/08.
//

import UIKit
import DropDown
import Alamofire
import IQKeyboardManager
import NVActivityIndicatorView


protocol AfterEditDelegate: AnyObject {
    func afterEdit(articleNO: Int)
    func updateComment(articleNO: Int)
    func updateGetData(getPostNumber: Int, getTitle: String, getCategory: String, getUserID: String, getNickname: String, getContents: String, getHash: [String])
}


class EditViewController: UIViewController {

    
    var originID = ""
    var originTitle = ""
    var originCategory = ""
    var originText = ""
    var originHash: [String] = []
    var originNo = 0
    
   
    @IBOutlet weak var categoryBaseView: UIView!
    @IBOutlet weak var titleBaseView: UIView!
    @IBOutlet weak var tagBaseView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var dropdownBaseView: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var guideLineView: UIView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dropDownImage: UIImageView!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var addTagButton: UIButton!
    @IBOutlet weak var tagCollectionViewLayout: LeftAlignedCollectionViewFlowLayout! {
        didSet {
        }
    }
        
    weak var afterEditDelegate: AfterEditDelegate?
    
    let dropDown = DropDown()
    let categoryArray = ["배달", "택배", "택시", "룸메"]
    
    var dropdownState = false
   
    var keyHeight: CGFloat?
    var getCategory: String = "선택"
    
    weak var delegate: UpdateData?
    
    var loading: NVActivityIndicatorView!
    
    lazy var dataManager: EditDataManager = EditDataManager(view: self)
    
    override func loadView() {
        super.loadView()
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setDropdown()
        setCollectionView()
        originArticle()
        tagCollectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNaviTab()
        
    }


   
    
}


extension EditViewController {
    
    func originArticle() {
        titleTextField.text = originTitle
        categoryTitle.text = originCategory
        contentsTextView.text = originText
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
    
    func setNaviTab() {
        self.navigationItem.title = "수정"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    func setDesign() {
        
        dropdownBaseView.layer.borderWidth = 1
        dropdownBaseView.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        
        categoryBaseView.backgroundColor = .white
        categoryBaseView.layer.cornerRadius = categoryBaseView.frame.height / 2
        categoryBaseView.layer.borderWidth = 2
        categoryBaseView.layer.borderColor = #colorLiteral(red: 1, green: 0.8901960784, blue: 0.5450980392, alpha: 1)
        
        titleBaseView.backgroundColor = .white
        titleBaseView.layer.cornerRadius = categoryBaseView.frame.height / 2
        titleBaseView.layer.borderWidth = 2
        titleBaseView.layer.borderColor = #colorLiteral(red: 1, green: 0.8901960784, blue: 0.5450980392, alpha: 1)
        
        tagBaseView.backgroundColor = .white
        tagBaseView.layer.cornerRadius = categoryBaseView.frame.height / 2
        tagBaseView.layer.borderWidth = 2
        tagBaseView.layer.borderColor = #colorLiteral(red: 1, green: 0.8901960784, blue: 0.5450980392, alpha: 1)
        
        
        addTagButton.layer.cornerRadius = addTagButton.frame.height / 2
        addTagButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        addTagButton.layer.shadowRadius = addTagButton.frame.height / 2
        addTagButton.layer.shadowOpacity = 0.25
        
        
        
        
        let ban = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(saveButtonAction))
        ban.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = ban
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        
        
        guideLineView.backgroundColor = UIColor.SBColor.SB_DarkGray
        
        categoryTitle.text = getCategory
        
        contentsTextView.textColor = .black
        
        dropDownImage.tintColor = UIColor.SBColor.SB_BaseYellow
    }
    
    
    func setDropdown() {
        dropDown.anchorView = dropdownBaseView
        dropDown.dataSource = categoryArray
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            dropDownImage.image = UIImage(systemName: "arrowtriangle.down.fill")
            self.categoryTitle.text = categoryArray[index]
        }
        
        dropDown.cancelAction = { [unowned self] in
            dropDownImage.image = UIImage(named: "drop")
        }

        dropDown.willShowAction = { [unowned self] in
            dropDownImage.image = UIImage(named: "upDrop")
        }
    }
    
    
    func setCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        let tagCollectionViewNib = UINib(nibName: "EditTagCollectionViewCell", bundle: nil)
        tagCollectionView.register(tagCollectionViewNib, forCellWithReuseIdentifier: "EditTagCollectionViewCell")
        tagCollectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        if let flowLayout = tagCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            
        }

        
        
    }
    

}





//MARK: -hash collectionView 설정
extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("태그 개수: \(originHash.count)")
        return originHash.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditTagCollectionViewCell", for: indexPath) as! EditTagCollectionViewCell
        
        cell.tagLabel.text = "#" + " \(originHash[indexPath.row])"
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        cell.addGestureRecognizer(tapGesture)
        
        
        return cell
    }
    
    @objc func tapGestureAction(sender: UITapGestureRecognizer) {
        print(">> 해시 태그 삭제")
        self.view.endEditing(true)  //키보드 내리기
        
        let touchPont = sender.location(in: tagCollectionView)
        let indexPath = tagCollectionView.indexPathForItem(at: touchPont)
        
        let deleteIndex = indexPath?.item
        
        originHash.remove(at: deleteIndex!)
        tagCollectionView.reloadData()
    }
    
    @objc func backButtonAction() {
        let alert = UIAlertController(title: "글쓰기 취소", message: "수정 내용이 저장되지 않습니다.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: { [self] _ in
            self.afterEditDelegate?.updateComment(articleNO: originNo)
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension EditViewController{
    @IBAction func dropDownButton(_ sender: Any) {
        dropDown.show()
    }
    @IBAction func addTagButton(_ sender: Any) {
        self.view.endEditing(true)
        
        if tagTextField.text == "" || tagTextField.text == nil {
            let alert = UIAlertController(title: "태그를 입력 해주세요", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            if originHash.count < 3 {
                let hashTag = tagTextField.text!
                originHash.append(hashTag)
                tagTextField.text = ""
                
                tagCollectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "태그는 최대 3개까지 가능합니다.", message: "", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @objc func saveButtonAction() {
        
        guard let title = titleTextField.text?.trim, title.isExists else {
            self.presentAlert(title: "제목을 입력 해주세요")
            return
        }
        
        guard categoryTitle.text != "선택" else {
            self.presentAlert(title: "카테고리를 선택 해주세요")
            return
        }
        
        guard contentsTextView.text != "내용을 입력 해주세요." else {
            self.presentAlert(title: "내용을 입력 해주세요.")
            return
        }
        
        self.loading.startAnimating()
    
        let sendNickname = UserDefaults.standard.string(forKey: "userNickname")!
        let sendId = UserDefaults.standard.string(forKey: "userID")!
        let sendTitle = titleTextField.text!
        let sendCategory = categoryTitle.text!
        let sendText = contentsTextView.text!
        let sendHash = originHash
        let sendNO = originNo
        let param = EditArticleRequest(curUser: sendId, title: sendTitle, category: sendCategory, text: sendText, hash: sendHash, no: sendNO)
        afterEditDelegate?.updateGetData(getPostNumber: originNo, getTitle: sendTitle, getCategory: sendCategory, getUserID: sendId, getNickname: sendNickname, getContents: sendText, getHash: originHash)
        
        dataManager.changeArticle(param, viewController: self)
    }
    
}



//MARK: -DataManager 연결 함수
extension EditViewController: EditView {
   
    func popView(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[self] _ in

            afterEditDelegate?.afterEdit(articleNO: self.originNo)
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    func showAlert(message: String) {
        self.presentAlert(title: message)
    }

    func stopLoading() {
        self.loading.stopAnimating()
    }

    
}

