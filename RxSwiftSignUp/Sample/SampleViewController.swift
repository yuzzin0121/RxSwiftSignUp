//
//  SampleViewController.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    private let textField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.placeholder = "입력하세요"
        return view
    }()
    
    private let addButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        view.setTitleColor(.white, for: .normal)
        view.setTitle("추가", for: .normal)
        return view
    }()
    
    lazy var data: [String] = []
    let items = BehaviorRelay<[String]>(value: [])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        
        // 셀 정의
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = "\(element)"
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let text = owner.textField.text else { return }
                var list = owner.items.value
                list.append(text)
                owner.items.accept(list)
            }
            .disposed(by: disposeBag)
        
        
    }

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(textField)
        view.addSubview(addButton)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
   }
}
