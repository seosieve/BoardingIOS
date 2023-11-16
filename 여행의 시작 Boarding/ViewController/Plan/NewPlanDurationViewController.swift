//
//  NewPlanDurationViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/09.
//

import UIKit
import FSCalendar

class NewPlanDurationViewController: UIViewController {

    var titleResult = ""
    var locationResult = ""
    
    var selectedDate = [Date]()
    var days = 0
    var writtenDate: Double = 0
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter
    }()
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var titleLabel = UILabel().then {
        $0.text = "여행 기간은 어떻게 되시나요?"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var boardingLabel = UILabel().then {
        $0.text = "가는 날"
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.light
    }
    
    var boardingUnderLine = UIView().then {
        $0.backgroundColor = Gray.semiLight
    }
    
    var landingLabel = UILabel().then {
        $0.text = "오는 날"
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.light
    }
    
    var landingUnderLine = UIView().then {
        $0.backgroundColor = Gray.semiLight
    }
    
    var calendarContainerView = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    lazy var calendarHeaderLabel = UILabel().then {
        $0.text = self.dateFormatter.string(from: calendarView.currentPage)
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    lazy var backwardButton = UIButton().then {
        $0.setImage(UIImage(named: "CalendarLeft"), for: .normal)
        $0.tintColor = Boarding.blue
        $0.addTarget(self, action: #selector(backwardButtonPressed), for: .touchUpInside)
    }
    
    lazy var forwardButton = UIButton().then {
        $0.setImage(UIImage(named: "CalendarRight"), for: .normal)
        $0.tintColor = Boarding.blue
        $0.addTarget(self, action: #selector(forwardButtonPressed), for: .touchUpInside)
    }
    
    @objc func backwardButtonPressed() {
        scrollCurrentPage(true)
    }
    
    @objc func forwardButtonPressed() {
        scrollCurrentPage(false)
    }
    
    func scrollCurrentPage(_ reverse: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = reverse ? -1 : 1
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true)
    }
    
    var calendarView = FSCalendar().then {
        $0.scope = .month
        $0.headerHeight = 0
        $0.allowsMultipleSelection = true
        $0.placeholderType = .none
        $0.calendarHeaderView.isHidden = true
        $0.locale = Locale(identifier: "ko_KR")
        $0.appearance.weekdayFont = Pretendard.medium(15)
        $0.appearance.weekdayTextColor = Gray.light
        $0.appearance.titleFont = Pretendard.medium(21)
        $0.appearance.titleDefaultColor = Gray.dark
        $0.appearance.titleWeekendColor = Gray.dark
        $0.appearance.titleTodayColor = Gray.dark
        $0.appearance.todayColor = .none
        $0.appearance.selectionColor = Boarding.blue
    }
    
    lazy var nextButton = UIButton().then {
        $0.setBackgroundColor(Boarding.blue, for: .normal)
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.7), for: .disabled)
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.setTitleColor(Gray.dark, for: .disabled)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        $0.isEnabled = false
    }
    
    @objc func nextButtonPressed() {
        let vc = self.navigationController!.viewControllers[1] as! NewPlanViewController
        vc.titleResult.accept(titleResult)
        vc.locationResult.accept(locationResult)
        vc.boardingResult.accept(boardingLabel.text!)
        vc.landingResult.accept(landingLabel.text!)
        vc.daysResult.accept(days)
        vc.writtenDateResult.accept(writtenDate)
        vc.titleLabel.textColor = Gray.dark
        vc.locationLabel.textColor = Gray.dark
        vc.boardingLabel.textColor = Gray.dark
        vc.landingLabel.textColor = Gray.dark
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        calendarView.delegate = self
        calendarView.dataSource = self
        setViews()
    }
    
    func setViews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(boardingLabel)
        boardingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(boardingUnderLine)
        boardingUnderLine.snp.makeConstraints { make in
            make.top.equalTo(boardingLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(view.snp.centerX).offset(-25)
            make.height.equalTo(2)
        }

        view.addSubview(landingLabel)
        landingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.equalTo(view.snp.centerX).offset(25)
        }

        view.addSubview(landingUnderLine)
        landingUnderLine.snp.makeConstraints { make in
            make.top.equalTo(boardingLabel.snp.bottom).offset(12)
            make.left.equalTo(view.snp.centerX).offset(25)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(2)
        }
        
        view.addSubview(calendarContainerView)
        calendarContainerView.snp.makeConstraints { make in
            make.top.equalTo(boardingUnderLine).offset(50)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(350)
        }
        
        calendarContainerView.addSubview(calendarHeaderLabel)
        calendarHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        calendarContainerView.addSubview(backwardButton)
        backwardButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarHeaderLabel)
            make.right.equalTo(calendarHeaderLabel.snp.left).offset(-6)
            make.width.height.equalTo(26)
        }
        
        calendarContainerView.addSubview(forwardButton)
        forwardButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarHeaderLabel)
            make.left.equalTo(calendarHeaderLabel.snp.right).offset(6)
            make.width.height.equalTo(26)
        }
        
        calendarContainerView.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(calendarHeaderLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        nextButton.rounded(axis: .horizontal)
    }
}

//MARK: - FSCalendarDelegate
extension NewPlanDurationViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func stringDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if selectedDate.isEmpty {
            selectedDate.append(date)
        } else {
            let distance = Calendar.current.dateComponents([.day], from: date, to: selectedDate.first!).day!
            days = abs(distance) + 1
            if distance < 0 {
                selectedDate.append(date)
            } else {
                selectedDate.insert(date, at: 0)
            }
        }
        
        if selectedDate.count == 1 {
            boardingLabel.text = stringDate(selectedDate[0])
            boardingLabel.textColor = Gray.dark
            boardingUnderLine.backgroundColor = Boarding.blue
        } else {
            boardingLabel.text = stringDate(selectedDate[0])
            boardingLabel.textColor = Gray.dark
            boardingUnderLine.backgroundColor = Boarding.blue
            landingLabel.text = stringDate(selectedDate[1])
            landingLabel.textColor = Gray.dark
            landingUnderLine.backgroundColor = Boarding.blue
            writtenDate = selectedDate[0].timeIntervalSince1970
            nextButton.isEnabled = true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = selectedDate.filter{$0 != date}
        
        if selectedDate.count == 1 {
            boardingLabel.text = stringDate(selectedDate[0])
            landingLabel.text = "오는 날"
            landingLabel.textColor = Gray.light
            landingUnderLine.backgroundColor = Gray.semiLight
            nextButton.isEnabled = false
        } else {
            boardingLabel.text = "가는 날"
            boardingLabel.textColor = Gray.light
            boardingUnderLine.backgroundColor = Gray.semiLight
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if calendar.selectedDates.count > 1 {
            return false
        } else {
            return true
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.calendarHeaderLabel.text = self.dateFormatter.string(from: calendar.currentPage)
    }
}
