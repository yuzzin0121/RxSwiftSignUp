//
//  SignUpViewController.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 3/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let sampleEmail = BehaviorSubject(value: "a@a.com")
    // Observable.just("a@a.com")
    let buttonColor = Observable.just(UIColor.black)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        // 타입이 동일할 때 받아온 값을 바로 보내준다.
         sampleEmail
             .bind(to: emailTextField.rx.text)
             .disposed(by: disposeBag)

         validationButton.rx.tap
             .bind(with: self) { owner, _ in
                 // = 로 값을 바꾸지 않는다.
                 owner.sampleEmail.onNext("b@a.com")
             }.disposed(by: disposeBag)
         
         buttonColor
             .bind(to: nextButton.rx.backgroundColor,
                   emailTextField.rx.tintColor,
                   emailTextField.rx.textColor
             )
             .disposed(by: disposeBag)
         
         buttonColor
             .map { $0.cgColor }
             .bind(to: nextButton.layer.rx.borderColor)
             .disposed(by: disposeBag)
         
 //        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
         nextButton.rx.tap
             .bind(with: self) { owner, _ in
                 owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
             }
             .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
