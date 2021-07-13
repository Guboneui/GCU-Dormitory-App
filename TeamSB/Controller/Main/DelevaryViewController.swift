//
//  DelevaryViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit

class DelevaryViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "배달"
        self.tabBarController?.tabBar.isHidden = true
        let goWriteView = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
        goWriteView.tintColor = .black
        let ass = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        ass.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        ass.tintColor = .black
        
        
        navigationItem.rightBarButtonItems = [goWriteView, ass]
        
    }
    
    @objc func goWriteView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}


