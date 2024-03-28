//
//  PhoneViewController.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 3/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let descriptionLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    
    let phoneInitialValue = BehaviorSubject(value: "010")
    let validText = Observable.just("10자 이상, 숫자로 입력해주세요")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureView()
        
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 010 초기값으로 설정
        phoneInitialValue
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        let validation = phoneTextField.rx.text.orEmpty.map { $0.count >= 10 && (Int($0) != nil) }
        
        validation
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? Color.black : .systemGray6
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        // 다음 버튼 클릭 시
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(phoneTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(phoneTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    private func configureView() {
        view.backgroundColor = Color.white
        
        descriptionLabel.textColor = .red
    }
}
