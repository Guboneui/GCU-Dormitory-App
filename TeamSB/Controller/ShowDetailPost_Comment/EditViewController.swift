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

class EditViewController: UIViewController {

    
    var originID = ""
    var originTitle = ""
    var originCategory = ""
    var originText = ""
    var originHash: [String] = []
    var originNo = 0
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var dropdownBaseView: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var guideLineView: UIView!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dropDownImage: UIImageView!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var addTagButton: UIButton!
        
    
    let dropDown = DropDown()
    let categoryArray = ["배달", "택배", "택시", "룸메"]
    
    var dropdownState = false
   
    var keyHeight: CGFloat?
    var getCategory: String = "선택"
    
    weak var delegate: UpdateData?
    
    var loading: NVActivityIndicatorView!
    
    //lazy var dataManager: WriteDataManager = WriteDataManager(view: self)
    
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


    func originArticle() {
        titleTextField.text = originTitle
        categoryTitle.text = originCategory
        contentsTextView.text = originText
    }
    
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
        
        let category = categoryTitle.text!
        let userId = UserDefaults.standard.string(forKey: "userID")!
        let text = contentsTextView.text!
        
        //let param = WriteArticleRequest(title: title, category: category, userId: userId, text: text, hash: tagArray)
        //dataManager.postWriteArticle(param, viewController: self)
        
    }
    
}


extension EditViewController {
    
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
        self.navigationItem.title = "글쓰기"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    func setDesign() {
        let ban = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(saveButtonAction))
        ban.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = ban
        
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
            dropDownImage.image = UIImage(systemName: "arrowtriangle.down.fill")
        }
        
        dropDown.willShowAction = { [unowned self] in
            dropDownImage.image = UIImage(systemName: "arrowtriangle.up.fill")
        }
    }
    
    
    func setCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        let tagCollectionViewNib = UINib(nibName: "EditTagCollectionViewCell", bundle: nil)
        tagCollectionView.register(tagCollectionViewNib, forCellWithReuseIdentifier: "EditTagCollectionViewCell")
        
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
    
}



//MARK: -DataManager 연결 함수
extension EditViewController: WriteView {
    func popView(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[self] _ in
            
            delegate?.update()
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

