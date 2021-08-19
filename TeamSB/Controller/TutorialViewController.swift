//
//  TutorialViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/20.
//

import UIKit

struct Page {
    var imageName: String
    var last: Bool
}

protocol PhotoAccess: AnyObject {
    func showPhotoAccess()
}

class TutorialViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    weak var delegate: PhotoAccess!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetting()
        pageControlSetting()
    }
    
    func collectionViewSetting() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(UINib(nibName: "TutorialCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TutorialCollectionViewCell")
        mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width, height: mainCollectionView.frame.height)
        flowLayout.scrollDirection = .horizontal
        mainCollectionView.collectionViewLayout = flowLayout
    }
    func pageControlSetting(){
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.8901960784, blue: 0.5450980392, alpha: 1)
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        
        
        
        
        
    }
    

    
}

extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
        
        if(indexPath.item == 0){
            print("page: 1")
        }else if(indexPath.item == 1){
            print("page: 2")
        }else{
            print("page: 3")
        }
        cell.configure(index: indexPath.item)
        
        cell.startButton.addTarget(self, action: #selector(endTutorial), for: .touchUpInside)
        
        
        
        
        return cell
    }
   

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        print(x, view.frame.width, x/view.frame.width)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func endTutorial() {
        
        self.dismiss(animated: true, completion: nil)
        delegate.showPhotoAccess()
    }
    
}


extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 50, height: 10)
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }



}
