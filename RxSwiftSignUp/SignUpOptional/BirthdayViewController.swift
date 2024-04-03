//
//  BirthdayViewController.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 3/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let infoText = BehaviorSubject(value: "만 17세 이상만 가입 가능합니다.")
    let today = BehaviorSubject<Date>(value: .now)
    let year = PublishRelay<Int>()
    let month = PublishRelay<Int>()
    let day = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    private func bind() {
        infoText.bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        year
            .asDriver(onErrorJustReturn: 2024)
            .map { "\($0)년" }
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .asDriver(onErrorJustReturn: 4)
            .map { "\($0)월" }
            .drive(monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        day
            .asDriver(onErrorJustReturn: 4)
            .map { "\($0)일" }
            .drive(dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        today
            .bind(with: self) { owner, date in
                let component = owner.getComponent(date: date)
                
                guard let year = component.year, let month = component.month, let day = component.day else { return }
                
                owner.infoLabel.rx.textColor.onNext(.systemRed)
                owner.nextButton.rx.backgroundColor.onNext(.systemGray6)
                owner.nextButton.rx.isEnabled.onNext(false)
            }
            .disposed(by: disposeBag)
        
        
        birthDayPicker.rx.date
            .subscribe(with: self) { owner, date in
                let component = owner.getComponent(date: date)
                let todayComponent = owner.getComponent(date: .now)
                guard let year = component.year, let month = component.month, let day = component.day, let todayYear = todayComponent.year else { return }
                
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
                
                let isValid = todayYear - year < 17
                
                let infoMessage = isValid ? "만 17세 이상만 가입 가능합니다" : "가입 가능한 나이입니다."
                let textColor: UIColor = isValid ? .systemRed : .systemBlue
                let backgroundColor: UIColor = isValid ? .systemGray5 : .systemBlue
                let isEnabled = isValid ? false : true
                owner.infoText.onNext(infoMessage)
                owner.infoLabel.rx.textColor.onNext(textColor)
                owner.nextButton.rx.backgroundColor.onNext(backgroundColor)
                owner.nextButton.rx.isEnabled.onNext(isEnabled)
                
            }
            .disposed(by: disposeBag)
        
    }
    
    func getComponent(date: Date) ->  DateComponents {
        let component = calendar.dateComponents([.year, .month, .day], from: date)
        return component
    }
    
    
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

