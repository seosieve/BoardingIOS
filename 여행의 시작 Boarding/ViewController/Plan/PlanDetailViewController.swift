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
    
    var plan = Plan.dummyType
    var selectedDay = 1
    
    var dataArray = ["TableView row 0", "TableView row 1", "TableView row 2"]
    
    
    let viewModel = PlanDetailViewModel()
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
    
    lazy var camera = GMSCameraPosition.camera(withLatitude: 64, longitude: -113, zoom: 14.0)
    
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
    
    lazy var planDetailFlowLayout = UICollectionViewFlowLayout().then {
        let width = (view.bounds.width - 70)
        let height: CGFloat = 120
        $0.itemSize = CGSize(width: width, height: height)
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
//        $0.minimumInteritemSpacing = 4
//        $0.minimumLineSpacing = 4
    }
    
    lazy var planDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.collectionViewLayout = planDetailFlowLayout
        $0.backgroundColor = Gray.white
        $0.isHidden = true
        $0.dragInteractionEnabled = true
    }

    var addMemoButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        var title = AttributedString.init("메모 추가")
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
        planDetailCollectionView.register(PlanDetailCollectionViewCell.self, forCellWithReuseIdentifier: "planDetailCollectionViewCell")
        planDetailCollectionView.delegate = self
        planDetailCollectionView.dataSource = self
        planDetailCollectionView.dragDelegate = self
        planDetailCollectionView.dropDelegate = self
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
            make.bottom.equalToSuperview().offset(-40)
        }
        
        planView.addSubview(planPlaceHolder)
        planPlaceHolder.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        planView.addSubview(planDetailCollectionView)
        planDetailCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        planView.addSubview(addMemoButton)
        addMemoButton.snp.makeConstraints { make in
            make.top.equalTo(planDetailCollectionView.snp.bottom).offset(20)
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
            make.top.equalTo(planDetailCollectionView.snp.bottom).offset(20)
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
                self.planDetailCollectionView.isHidden = false
                self.planPlaceHolder.isHidden = true
                self.updateViewHeight(count: 3)
            })
            .disposed(by: disposeBag)
        
        viewModel.deleteCompleted
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{
                self.indicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func updateViewHeight(count: Int) {
        // UICollectionView의 높이를 업데이트
        let height = 140
        let numberOfCells = count
        let totalHeight = height * numberOfCells
        planDetailCollectionView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }
    }
}

extension PlanDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "planDetailCollectionViewCell", for: indexPath) as! PlanDetailCollectionViewCell
        cell.numberLabel.text = "\(indexPath.row)"
        cell.locationLabel.text = dataArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if
            let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                let temp = dataArray[sourceIndexPath.item]
                dataArray.remove(at: sourceIndexPath.item)
                dataArray.insert(temp, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }) { done in
                //
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            return []
        }
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    
    
    
    
    
//    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
//        return true
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = dataArray[indexPath.row]
//        let itemProvider = NSItemProvider(object: item as NSItemProviderWriting)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
//        guard collectionView.hasActiveDrag else { return UICollectionViewDropProposal(operation: .forbidden) }
//        return UICollectionViewDropProposal(operation: .move)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        if let destinationIndexPath = coordinator.destinationIndexPath {
//            if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
//                collectionView.performBatchUpdates {
//                    dataArray.remove(at: sourceIndexPath.item)
//                    dataArray.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
//                    
//                    collectionView.deleteItems(at: [sourceIndexPath])
//                    collectionView.insertItems(at: [destinationIndexPath])
//                }
//                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
//            }
//        }
//    }
}

//MARK: - UITableViewDelegate
//extension PlanDetailViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "planDetailTableViewCell", for: indexPath) as! PlanDetailTableViewCell
//        cell.selectionStyle = .none
//        cell.numberLabel.text = "\(indexPath.row)"
//        cell.locationLabel.text = dataArray[indexPath.row]
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 140
//    }
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
//    -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
//            self.dataArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            completionHandler(true)
//        }
//        deleteAction.image = UIImage(named: "Trash")
//        deleteAction.backgroundColor = Boarding.lightRed
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        print("\(sourceIndexPath.row) -> \(destinationIndexPath.row)")
//        let moveCell = self.dataArray[sourceIndexPath.row]
//        self.dataArray.remove(at: sourceIndexPath.row)
//        self.dataArray.insert(moveCell, at: destinationIndexPath.row)
//    }
//}

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
