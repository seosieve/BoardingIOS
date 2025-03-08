//
//  CommentViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/14/23.
//

import UIKit
import RxSwift
import RxCocoa

class CommentViewController: UIViewController {
    
    var NFTID = ""
    var dataArray = [Comment]()
    
    lazy var viewModel = CommentViewModel(NFTID: NFTID)
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    lazy var backgroundView = UIView().then {
        $0.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        $0.addGestureRecognizer(tap)
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true)
    }
    
    var modalView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var modalIndicator = UIView().then {
        $0.backgroundColor = Gray.semiLight
    }
    
    var commentLabel = UILabel().then {
        $0.text = "댓글"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var commentCountLabel = UILabel().then {
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.medium
    }
    
    lazy var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "Triangle"), for: .normal)
        $0.setTitle("최신순", for: .normal)
        $0.setTitleColor(Gray.medium, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(16)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        $0.semanticContentAttribute = .forceRightToLeft
        
        let registrationOrder = UIAction(title: "최신순", state: .on, handler: { _ in
            self.viewModel.stopListening()
            self.viewModel.getAllCommentByDate()
        })
        let popularityOrder = UIAction(title: "인기순", handler: { _ in
            self.viewModel.stopListening()
            self.viewModel.getAllCommentByLikes()
        })
        $0.menu = UIMenu(options: .displayInline, children: [registrationOrder, popularityOrder])
        $0.showsMenuAsPrimaryAction = true
        $0.changesSelectionAsPrimaryAction = true
    }
    
    lazy var commentTableView = UITableView().then {
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        $0.contentOffset = CGPoint(x: 0, y: -10)
        $0.backgroundColor = Gray.white
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    var commentPlaceHolder = UILabel().then {
        $0.text = "아직 댓글이 없습니다"
        $0.font = Pretendard.semiBold(22)
        $0.textColor = Gray.semiLight
    }
    
    var bottomContainerView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var commentingDivider = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.alpha = 0
    }
    
    var commentingView = UIView().then {
        $0.backgroundColor = Gray.bright
    }
    
    var commentingUserImage = UIImageView().then {
        $0.backgroundColor = Gray.white
    }
    
    lazy var commentingTextField = UITextField().then {
        $0.placeholder = "댓글 달기"
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.black
        $0.tintColor = Boarding.blue
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        if sender.text == "" {
            UIView.animate(withDuration: 0.2) {
                self.commentingButton.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
            commentingButton.isHidden = true
        } else {
            UIView.animate(withDuration: 0.2) {
                self.commentingButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            commentingButton.isHidden = false
        }
    }
    
    var commentingButton = UIButton().then {
        $0.setImage(UIImage(named: "Send"), for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.backgroundColor = Boarding.blue
        $0.isHidden = true
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentTableViewCell")
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentingTextField.delegate = self
        dismissKeyboardWhenTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setViews()
        setRx()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboard = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboard.height
        UIView.animate(withDuration: 0.3) {
            self.commentingDivider.alpha = 1
            self.bottomContainerView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.commentingDivider.alpha = 0
            self.bottomContainerView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(30)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func setViews() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(modalView)
        modalView.snp.makeConstraints { make in
            make.centerX.left.bottom.equalToSuperview()
        }
        modalView.makeModalCircular()
        
        modalView.addSubview(modalIndicator)
        modalIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(4)
        }
        modalIndicator.rounded(axis: .horizontal)
        
        modalView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(commentCountLabel)
        commentCountLabel.snp.makeConstraints { make in
            make.left.equalTo(commentLabel.snp.right).offset(8)
            make.bottom.equalTo(commentLabel)
        }
        
        modalView.addSubview(sortButton)
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(commentLabel)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        modalView.addSubview(commentTableView)
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(10)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
        
        modalView.addSubview(commentPlaceHolder)
        commentPlaceHolder.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
        }
        
        modalView.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.top.equalTo(commentTableView.snp.bottom)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.bottom.equalToSuperview().inset(30)
        }
        
        bottomContainerView.addSubview(commentingDivider)
        commentingDivider.snp.makeConstraints { make in
            make.top.equalTo(bottomContainerView)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        bottomContainerView.addSubview(commentingView)
        commentingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        commentingView.rounded(axis: .horizontal)
        
        commentingView.addSubview(commentingUserImage)
        commentingUserImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(7)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
        commentingUserImage.rounded(axis: .horizontal)
        
        commentingView.addSubview(commentingButton)
        commentingButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-7)
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(36)
        }
        commentingButton.rounded(axis: .horizontal)
        
        commentingView.addSubview(commentingTextField)
        commentingTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(commentingUserImage.snp.right).offset(10)
            make.right.equalTo(commentingButton.snp.left).offset(-10)
        }
        
        modalView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        viewModel.thumbnail
            .subscribe(onNext: { url in
                self.commentingUserImage.sd_setImage(with: url, placeholderImage: UIImage())
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .subscribe(onNext: { items in
                self.dataArray = items
                self.commentTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .subscribe(onNext: { count in
                if count == 0 {
                    self.commentPlaceHolder.isHidden = false
                } else {
                    self.commentPlaceHolder.isHidden = true
                }
                self.commentCountLabel.text = "\(count)개"
            })
            .disposed(by: disposeBag)
        
        commentingButton.rx.tap
            .subscribe(onNext: {
                self.indicator.startAnimating()
                self.view.isUserInteractionEnabled = false
                self.viewModel.writeComment(content: self.commentingTextField.text!)
                self.viewModel.addCommentCount()
                self.commentingTextField.text = ""
                self.commentingButton.isHidden = true
                self.commentingTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.processCompleted
            .subscribe(onNext: {
                self.indicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.selectionStyle = .none
        let comment = dataArray[indexPath.row]
        if dataArray[indexPath.row].commentID != "" {
            let user = viewModel.users.value[indexPath.row]
            if user.userUid == "" {
                cell.photoView.image = imageWithColor(color: Gray.bright)
                cell.userNameLabel.text = "삭제된 유저"
            } else {
                cell.photoView.sd_setImage(with: URL(string: user.url), placeholderImage: nil, options: .scaleDownLargeImages)
                cell.userNameLabel.text = user.name
            }
            cell.commentTimeLabel.text = viewModel.getTime(comment.writtenDate)
            cell.commentLabel.text = comment.content
            cell.commentLabel.withLineSpacing(4)
            cell.commentLikeCount.text = "좋아요 \(comment.likes)개"
            cell.commentLikeCount.withMultipleFont(Pretendard.semiBold(13), range: "\(comment.likes)")
            cell.isUserAlreadyLiked(userUid: viewModel.userUid, likedPeople: comment.likedPeople)
            cell.likeTapped = {
                self.viewModel.like(commentID: comment.commentID)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let author = self.viewModel.users.value[indexPath.row]
        //자신이 쓴 댓글만 삭제 가능
        if author.userUid == viewModel.userUid {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let commentID = self.dataArray[indexPath.row].commentID
            self.dataArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.viewModel.deleteComment(commentID: commentID)
            self.viewModel.reduceCommentCount()
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "Trash")
        deleteAction.backgroundColor = Boarding.lightRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}


//MARK: - UITextFieldDelegate
extension CommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentingTextField.resignFirstResponder()
        return true
    }
}
