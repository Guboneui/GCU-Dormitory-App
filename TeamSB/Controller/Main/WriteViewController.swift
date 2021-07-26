//
//  WriteViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import DropDown
import Alamofire
import IQKeyboardManager


protocol UpdateData: AnyObject {
    func update()
}


class WriteViewController: UIViewController {
    
    
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
    
    @IBOutlet weak var tagCollectionViewLayout: LeftAlignedCollectionViewFlowLayout! {
        didSet {
            //tagCollectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            //tagCollectionViewLayout.
        }
    }
    
    let dropDown = DropDown()
    let categoryArray = ["배달", "택배", "택시", "빨래"]
    
    var dropdownState = false
    var tagArray: [String] = []
    var keyHeight: CGFloat?
    
    weak var delegate: UpdateData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        
        
        let ban = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(saveButtonAction))
        ban.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = ban
        
        
        
        
        resignForKeyboardNotification()
        //다른 공간 클릭 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
        
        guideLineView.backgroundColor = UIColor.SBColor.SB_DarkGray
        
        categoryTitle.text = "카테고리"
        
        
        contentsTextView.delegate = self
        contentsTextView.text = "내용을 입력 해주세요."
        contentsTextView.textColor = UIColor.SBColor.SB_LightGray
        
        //saveButton.backgroundColor = UIColor.SBColor.SB_BaseYellow
        
        dropDown.anchorView = dropdownBaseView
        dropDown.dataSource = categoryArray
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            print("selected item: \(item) at index: \(index)")
            self.categoryTitle.text = categoryArray[index]
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "글쓰기"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    func setCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        let tagCollectionViewNib = UINib(nibName: "TagCollectionViewCell", bundle: nil)
        tagCollectionView.register(tagCollectionViewNib, forCellWithReuseIdentifier: "TagCollectionViewCell")
        //tagCollectionView.layoutSubviews()
    }
    
    
    @objc func dismissKeyboard() {  //키보드 숨김처리
        view.endEditing(true)
    }
    
    func resignForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        mainScrollView.contentInset = contentInset
        mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        mainScrollView.contentInset = contentInset
        mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    @IBAction func categoryOptions(_ sender: Any) {
        dropDown.show()
    }
    
    
    
    @objc func saveButtonAction() {
        if titleTextField.text == "" || titleTextField.text == nil {
            let alert = UIAlertController(title: "제목을 입력 해주세요.", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        } else if categoryTitle.text == "카테고리" || categoryTitle.text == nil {
            let alert = UIAlertController(title: "카테고리를 선택 해주세요.", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        } else if contentsTextView.text == "내용을 입력 해주세요." || contentsTextView.text == nil {
            let alert = UIAlertController(title: "내용을 입력 해주세요.", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            postWriteArticle()
        }
        

    }
    
    func postWriteArticle() {
        let URL = "http://13.209.10.30:3000/writeArticle"
        
        var category = ""
        if categoryTitle.text == "배달" {
            category = "delivery"
        } else if categoryTitle.text == "택배" {
            category = "parcel"
        } else if categoryTitle.text == "택시" {
            category = "taxi"
        } else if categoryTitle.text == "빨래" {
            category = "laundry"
        }
       
        
        let PARAM: Parameters = [
            "title": titleTextField.text!,
            "category": category,
            "userId": UserDefaults.standard.string(forKey: "userID")!,
            "text": contentsTextView.text!,
            "hash": tagArray,
        ]
        
       
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON{(response) in
            
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 게시글 작성 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: {[self] _ in
                            
                            delegate?.update()
                            self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                        
                    } else {
                        let message = jsonObj.object(forKey: "message") as! String
                        
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
                
                
            case .failure(let error) :
                if let jsonObj = error as? NSDictionary {
                    print("서버통신 실패")
                    print(error)
                }
            }
        }
    }
    
    @IBAction func addTagButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if tagTextField.text == "" || tagTextField.text == nil {
            let alert = UIAlertController(title: "태그를 입력 해주세요", message: "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            
            
            if tagArray.count < 3 {
                let hashTag = tagTextField.text!
                tagArray.append(hashTag)
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
    
}
        
        
        
extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentsTextView.text == "" {
            textViewSetupView()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            contentsTextView.resignFirstResponder()
        }
        return true
    }
    
    
    func textViewSetupView() {
        if contentsTextView.text == "내용을 입력 해주세요." {
            contentsTextView.text = ""
            contentsTextView.textColor = UIColor.black
        } else if contentsTextView.text == ""{
            contentsTextView.text = "내용을 입력 해주세요."
            contentsTextView.textColor = UIColor.SBColor.SB_LightGray
        }
    }
}


extension WriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("태그 개수: \(tagArray.count)")
        return tagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        
        cell.tagLabel.text = "#" + " \(tagArray[indexPath.row])"
        
        
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
        
        tagArray.remove(at: deleteIndex!)
        tagCollectionView.reloadData()
    }
    
    
    
    
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin
    
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}

