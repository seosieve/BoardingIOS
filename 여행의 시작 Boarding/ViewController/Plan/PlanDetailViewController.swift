//
//  PlanDetailViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/12.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps

protocol AddPlanDelegate: AnyObject {
    func presentAddPlanModal(planID: String, NFTID: String)
}

class PlanDetailViewController: UIViewController {

    var feedbackGenerator: UIImpactFeedbackGenerator?
    
    var dataArray = [NFT]()
    var memoArray = [String]()
    var plan = Plan.dummyType
    var selectedDay = 1
    var lastCount = 0
    
    lazy var viewModel = PlanDetailViewModel(planID: self.plan.planID)
    let disposeBag = DisposeBag()
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var iconView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.shadowOffset = CGSize(width:0, height:12)
        $0.layer.shadowRadius = 6
        $0.layer.shadowColor = Gray.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOpacity = 0
    }
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var modifyButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = Pretendard.regular(17)
        $0.setTitleColor(Gray.medium, for: .normal)
    }
    
    var detailScrollView = UIScrollView()
    
    var detailContentView = UIView()
    
    var backgroundView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = plan.title
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(25)
    }
    
    lazy var DdayLabel = UILabel().then {
        $0.text = makeDday(boardingDate: plan.boarding)
        $0.font = Pretendard.bold(13)
        $0.textColor = Gray.white
        $0.textAlignment = .center
    }
    
    lazy var subTitleLabel = UILabel().then {
        $0.text = "\(plan.location), \(plan.boarding) ~ \(plan.landing)"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.semiLight
    }
    
    var dayScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.contentOffset = CGPoint(x: -20, y: 0)
    }
    
    var dayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    @objc func daySelected(_ sender: UIButton) {
        dayStackView.arrangedSubviews.forEach { button in
            if let button = button as? UIButton {
                button.isSelected = false
                button.layer.borderWidth = 1
            }
        }
        sender.isSelected = true
        sender.layer.borderWidth = 0
        selectedDay = sender.tag
        feedbackGenerator?.impactOccurred()
        dayLabel.text = "Day \(sender.tag)"
    }
    
    lazy var camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 12.0)
    
    lazy var map = GMSMapView(frame: CGRect.zero, camera: camera).then {
        $0.settings.scrollGestures = false
        $0.settings.zoomGestures = false
        $0.settings.tiltGestures = false
        $0.settings.rotateGestures = false
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    var dayView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var dayLabel = UILabel().then {
        $0.text = "Day 1"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var planView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var planPlaceHolder = UILabel().then {
        $0.text = "일정을 추가해 주세요."
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.medium
    }
    
    var planDetailTableView = UITableView().then {
        $0.backgroundColor = Gray.white
        $0.separatorStyle = .none
        $0.isHidden = true
        $0.dragInteractionEnabled = true
    }

    var addMemoButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        var title = AttributedString.init("메모 수정")
        title.font = Pretendard.semiBold(17)
        config.baseBackgroundColor = Gray.bright
        config.baseForegroundColor = Gray.medium
        config.attributedTitle = title
        config.background.cornerRadius = 12
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        $0.configuration = config
        $0.contentHorizontalAlignment = .left
    }
    
    var addMemoImage = UIImageView().then {
        $0.image = UIImage(named: "Memo")
    }
    
    var myScrapButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        var title = AttributedString.init("내 스크랩")
        title.font = Pretendard.semiBold(17)
        config.baseBackgroundColor = Boarding.lightBlue
        config.baseForegroundColor = Boarding.blue
        config.attributedTitle = title
        config.background.cornerRadius = 12
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        $0.configuration = config
        $0.contentHorizontalAlignment = .left
    }
    
    var myScrapImage = UIImageView().then {
        $0.image = UIImage(named: "SaveFilled")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Boarding.blue
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Gray.bright
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        detailScrollView.delegate = self
        planDetailTableView.register(PlanDetailTableViewCell.self, forCellReuseIdentifier: "planDetailTableViewCell")
        planDetailTableView.delegate = self
        planDetailTableView.dataSource = self
        planDetailTableView.dragDelegate = self
        planDetailTableView.dropDelegate = self
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { make in
            make.centerX.top.width.equalToSuperview()
            make.height.equalTo(window.safeAreaInsets.top)
        }
        
        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(45)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(modifyButton)
        modifyButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(-20)
        }
        
        view.insertSubview(detailScrollView, belowSubview: iconView)
        detailScrollView.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        detailScrollView.addSubview(detailContentView)
        detailContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        detailContentView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-300)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(700)
        }
        
        detailContentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        detailContentView.addSubview(DdayLabel)
        DdayLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(45)
            make.height.equalTo(26)
        }
        DdayLabel.rounded(axis: .horizontal)
        DdayLabel.backgroundColor = DdayLabel.text!.count > 3 ? Gray.light : Boarding.red
        
        detailContentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        
        detailContentView.addSubview(dayScrollView)
        dayScrollView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(25)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        dayScrollView.addSubview(dayStackView)
        dayStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        for index in 0..<plan.days {
            let dayButton = UIButton().then {
                $0.tag = index+1
                $0.setBackgroundColor(Gray.white, for: .normal)
                $0.setBackgroundColor(Boarding.blue, for: .selected)
                $0.setTitle("Day \(index+1)", for: .normal)
                $0.setTitleColor(Gray.medium, for: .normal)
                $0.setTitleColor(Gray.white, for: .selected)
                $0.titleLabel?.font = Pretendard.medium(15)
                $0.layer.borderColor = Gray.bright.cgColor
                $0.layer.borderWidth = 1
                $0.addTarget(self, action: #selector(daySelected), for: .touchUpInside)
            }
            if index == 0 {
                dayButton.isSelected = true
                dayButton.layer.borderWidth = 0
            }
            dayStackView.addArrangedSubview(dayButton)
            dayButton.snp.makeConstraints { make in
                make.width.equalTo(64)
                make.height.equalTo(32)
            }
            dayButton.rounded(axis: .horizontal)
        }
        
        detailContentView.addSubview(map)
        map.snp.makeConstraints { make in
            make.top.equalTo(dayScrollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(subTitleLabel)
            make.height.equalTo(230)
        }
        
        detailContentView.addSubview(dayView)
        dayView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(65)
        }
        
        dayView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        detailContentView.addSubview(planView)
        planView.snp.makeConstraints { make in
            make.top.equalTo(dayView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        planView.addSubview(planPlaceHolder)
        planPlaceHolder.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        planView.addSubview(planDetailTableView)
        planDetailTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        planView.addSubview(addMemoButton)
        addMemoButton.snp.makeConstraints { make in
            make.top.equalTo(planDetailTableView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(planView.snp.centerX).offset(-6)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        addMemoButton.addSubview(addMemoImage)
        addMemoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(20)
        }
        
        planView.addSubview(myScrapButton)
        myScrapButton.snp.makeConstraints { make in
            make.top.equalTo(planDetailTableView.snp.bottom).offset(10)
            make.left.equalTo(planView.snp.centerX).offset(6)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        myScrapButton.addSubview(myScrapImage)
        myScrapImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(20)
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        modifyButton.rx.tap
            .subscribe(onNext: {
                self.deleteAlert("플랜") {
                    self.indicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    self.viewModel.deletePlan(planID: self.plan.planID)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .subscribe(onNext: { [weak self] count in
                if count == 0 {
                    self?.planDetailTableView.isHidden = true
                    self?.planPlaceHolder.isHidden = false
                    self?.addMemoButton.isEnabled = false
                } else {
                    self?.planDetailTableView.isHidden = false
                    self?.planPlaceHolder.isHidden = true
                    self?.addMemoButton.isEnabled = true
                }
                self?.updateMap(data: self?.dataArray.last)
                self?.updateViewHeight(count: count)
            })
            .disposed(by: disposeBag)
        
        myScrapButton.rx.tap
            .subscribe(onNext: {
                let vc = MyScrapViewController()
                vc.planID = self.plan.planID
                vc.delegate = self
                vc.modalPresentationStyle = .automatic
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        addMemoButton.rx.tap
            .subscribe(onNext: {
                let vc = MemoEditViewController()
                vc.planID = self.plan.planID
                vc.memoArray = self.memoArray
                vc.modalPresentationStyle = .automatic
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.deleteCompleted
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{
                self.indicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .subscribe(onNext: { items in
                self.dataArray = items
                self.planDetailTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.memo
            .subscribe(onNext: { items in
                self.memoArray = items
            })
            .disposed(by: disposeBag)
    }
    
    func updateViewHeight(count: Int) {
        // UICollectionView의 높이를 업데이트
        let result = memoArray.map { $0.isEmpty ? 140 : 220 }.reduce(0, +)
        let totalHeight = count == 0 ? 30 : result
        if lastCount <= count {
            self.planDetailTableView.snp.updateConstraints { make in
                make.height.equalTo(totalHeight)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.planDetailTableView.snp.updateConstraints { make in
                    make.height.equalTo(totalHeight)
                }
                self.view.layoutIfNeeded()
            }
        }
        lastCount = count
    }
    
    func updateMap(data: NFT?) {
        let latitude = data?.latitude ?? 0
        let longitude = data?.longitude ?? 0
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //Update Camera
        let camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 12.0)
        map.camera = camera
        //Update Marker
        if let title = data?.location {
            let marker = GMSMarker(position: location)
            marker.icon = GMSMarker.markerImage(with: Boarding.blue)
            marker.title = title
            marker.map = map
        }
    }
}

//MARK: - UITableViewDelegate
extension PlanDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planDetailTableViewCell", for: indexPath) as! PlanDetailTableViewCell
        cell.selectionStyle = .none
        if dataArray[indexPath.row].NFTID != "" {
            cell.photoView.sd_setImage(with: URL(string: dataArray[indexPath.row].url), placeholderImage: nil, options: .scaleDownLargeImages)
            cell.numberLabel.text = String(indexPath.row+1)
            cell.titleLabel.text = dataArray[indexPath.row].title
            self.viewModel.getAddress(latitude: dataArray[indexPath.row].latitude, longitude: dataArray[indexPath.row].longitude) { location in
                cell.locationLabel.text = location
            }
            cell.contentLabel.text = dataArray[indexPath.row].content
            cell.memoView.isHidden = memoArray[indexPath.row] == "" ? true : false
            cell.memoLabel.isHidden = memoArray[indexPath.row] == "" ? true : false
            cell.memoLabel.text = memoArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if memoArray[indexPath.row] == "" {
            return 140
        } else {
            return 220
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateMap(data: dataArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let NFTID = self.dataArray[indexPath.row].NFTID
            self.dataArray.remove(at: indexPath.row)
            self.memoArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.viewModel.removeDayPlan(NFTID: NFTID, memoArray: self.memoArray)
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "Trash")
        deleteAction.backgroundColor = Boarding.lightRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("\(sourceIndexPath.row) -> \(destinationIndexPath.row)")
        let NFT = self.dataArray[sourceIndexPath.row]
        let memo = self.memoArray[sourceIndexPath.row]
        self.dataArray.remove(at: sourceIndexPath.row)
        self.dataArray.insert(NFT, at: destinationIndexPath.row)
        self.memoArray.remove(at: sourceIndexPath.row)
        self.memoArray.insert(memo, at: destinationIndexPath.row)
        self.viewModel.swapDayPlan(dayArray: self.dataArray.map{ $0.NFTID }, memoArray: memoArray)
    }
}

//MARK: - UITableViewDragDelegate
extension PlanDetailViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

//MARK: - UITableViewDropDelegate
extension PlanDetailViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}


//MARK: - UIScrollView
extension PlanDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var level = scrollView.contentOffset.y
        level = max(0, level)
        level = min(100, level)
        iconView.layer.shadowOpacity = Float(level/2000)
    }
}

//MARK: - AddPlanDelegate
extension PlanDetailViewController: AddPlanDelegate {
    func presentAddPlanModal(planID: String, NFTID: String) {
        let vc = AddPlanViewController()
        vc.planID = planID
        vc.NFTID = NFTID
        vc.days = plan.days
        vc.modalPresentationStyle = .automatic
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
}
