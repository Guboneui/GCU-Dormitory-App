//
//  TaxiViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit

class TaxiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "택시"
        self.tabBarController?.tabBar.isHidden = true
        let goWriteView = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
        goWriteView.tintColor = .black
        navigationItem.rightBarButtonItem = goWriteView
    }
    

    @objc func goWriteView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
