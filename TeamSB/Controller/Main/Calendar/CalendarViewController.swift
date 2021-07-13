//
//  CalendarViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/04.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var testLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "식단"
    }
    
    
    func setCalendar() {
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.placeholderType = .none
        dateFormatter.dateFormat = "MM-dd"
        
        
        calendar.backgroundColor = UIColor.SBColor.SB_LightGray
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.eventSelectionColor = UIColor.SBColor.SB_BaseYellow
        calendar.appearance.todayColor = UIColor.SBColor.SB_LightYellow
        calendar.appearance.todaySelectionColor = UIColor.SBColor.SB_LightYellow
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.appearance.selectionColor = UIColor.SBColor.SB_BaseYellow
        
        
        calendar.headerHeight = 50
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        
        calendar.locale = Locale(identifier: "ko_KR")
       
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
   
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var selectDate: String = dateFormatter.string(from: date)
        print(selectDate)
        testLabel.text = selectDate
        
        //print("\(dateFormatter.string(from: date)) 선택됨")
    }
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("\(dateFormatter.string(from: date)) 해제됨")
    }
    
}
