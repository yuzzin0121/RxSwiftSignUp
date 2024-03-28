//
//  SignInViewController.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 3/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let minimalEmailLength = 5
private let minimalPasswordLength = 8


class SignInViewController: UIViewController {
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let emailMessageLabel = UILabel()
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let passwordMessageLabel = UILabel()
    
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureView()
        bind()
    }
    
    private func bind() {
        let emailValid = emailTextField.rx.text.orEmpty
            .map { $0.count >= minimalEmailLength }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        emailValid
            .bind(to: emailMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(with: self, onNext: { owner, value in
                owner.signInButton.isEnabled =  value
                let color: UIColor = value ? Color.black : .systemGray6
                owner.signInButton.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(emailMessageLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordMessageLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        emailMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(emailTextField)
            make.height.equalTo(14)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailMessageLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        passwordMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(passwordTextField)
            make.height.equalTo(14)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordMessageLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureView() {
        view.backgroundColor = Color.white
        
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
        
        emailMessageLabel.text = "이메일은 최소 \(minimalEmailLength) 글자 이상"
        emailMessageLabel.textColor = .systemRed
        passwordMessageLabel.text = "비밀번호는 최소 \(minimalPasswordLength) 글자 이상"
        passwordMessageLabel.textColor = .systemRed
    }
}
