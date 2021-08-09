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
import NVActivityIndicatorView


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
        }
    }

    let dropDown = DropDown()
    let categoryArray = ["배달", "택배", "택시", "룸메"]

    var dropdownState = false
    var tagArray: [String] = []
    var keyHeight: CGFloat?
    var getCategory: String = "선택"

    weak var delegate: UpdateData?

    var loading: NVActivityIndicatorView!

    lazy var dataManager: WriteDataManager = WriteDataManager(view: self)

//MARK: -생명주기
    override func loadView() {
        super.loadView()
        setLoading()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setDropdown()
        setCollectionView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNaviTab()
    }

}

//MARK: -기본 UI 정리
extension WriteViewController {

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

        contentsTextView.delegate = self
        contentsTextView.text = "내용을 입력 해주세요."
        contentsTextView.textColor = UIColor.SBColor.SB_LightGray

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
        let tagCollectionViewNib = UINib(nibName: "TagCollectionViewCell", bundle: nil)
        tagCollectionView.register(tagCollectionViewNib, forCellWithReuseIdentifier: "TagCollectionViewCell")
        tagCollectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        if let flowLayout = tagCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        }

    }


}

//MARK: -스토리보드 Action 함수
extension WriteViewController {

    @IBAction func categoryOptions(_ sender: Any) {
        dropDown.show()
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

        let param = WriteArticleRequest(title: title, category: category, userId: userId, text: text, hash: tagArray)

        dataManager.postWriteArticle(param, viewController: self)

        print(tagArray)

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

//MARK: -TextView PlaceHolder 커스텀
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

//MARK: -hash collectionView 설정
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

//MARK: -hash collectionView FlowLayout 설정(좌측 정렬)
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    let cellSpacing: CGFloat = 3
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 3
        self.sectionInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 0.0, right: 16.0)
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)

        }
        return attributes

    }


}

//MARK: -DataManager 연결 함수
extension WriteViewController: WriteView {
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


