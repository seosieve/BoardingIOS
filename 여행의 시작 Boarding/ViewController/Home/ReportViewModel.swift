//
//  ReportViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/04.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ReportViewModel {
    let reportID = db.collection("Report").document().documentID
    var userUid = ""
    
    let writeReportSubject = PublishSubject<Void>()
    let addReportCountSubject = PublishSubject<Void>()
    @MainActor let processCompleted = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
        }
        
//        Observable.zip(writeReportSubject, addReportCountSubject)
//            .map{ _ in return }
//            .subscribe(onNext: { [weak self] in
//                self?.processCompleted.onNext(())
//            })
//            .disposed(by: disposeBag)
        
        let observable = Observable.zip(writeReportSubject, addReportCountSubject)
            .map{ _ in return }
        
        Task {
            for try await aa in observable.values {
                processCompleted.onNext(())
            }
        }
    }
    
    func writeReport(NFTID: String, authorUid: String, reason: String, detail: String) {
        let unixTimestamp = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let report = Report(reportID: reportID, userUid: userUid, NFTID: NFTID, authorUid: authorUid, writtenDate: dateToString(date), reason: reason, detail: detail)
        db.collection("Report").document(reportID).setData(report.dicType) { error in
            if let error = error {
                print("report 저장 에러: \(error)")
            } else {
                print("report 저장 성공: \(self.reportID)")
                self.writeReportSubject.onNext(())
            }
        }
    }
    
    func writeReportAsync(NFTID: String, authorUid: String, reason: String, detail: String) async -> Void {
        let unixTimestamp = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let report = Report(reportID: reportID, userUid: userUid, NFTID: NFTID, authorUid: authorUid, writtenDate: dateToString(date), reason: reason, detail: detail)
        
        do {
            try await db.collection("Report").document(reportID).setData(report.dicType)
            print("report 저장 성공: \(self.reportID)")
            return
        } catch {
            print("report 저장 에러: \(error)")
        }
    }
    
    func addReportCount(NFTID: String) {
        db.collection("NFT").document(NFTID).updateData(["reports": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("reports count 증가 에러: \(error)")
            } else {
                print("reports count 증가 성공")
                self.addReportCountSubject.onNext(())
            }
        }
    }
    
    func addReportCountAsync(NFTID: String) async -> Void {
        do {
            try await db.collection("NFT").document(NFTID).updateData(["reports": FieldValue.increment(Int64(1))])
            print("reports count 증가 성공")
            return
        } catch {
            print("reports count 증가 에러: \(error)")
        }
    }
    
    func addBlockedUser(_ authorUid: String) {
        db.collection("User").document(userUid).updateData(["blockedUser": FieldValue.arrayUnion([authorUid])]) { error in
            if let error = error {
                print("blockedUser 추가 에러: \(error)")
            } else {
                print("blockedUser 추가 성공")
            }
        }
    }
}
