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
        view.register(SampleTableViewCell.self, forCellReuseIdentifier: SampleTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    private let textField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let addButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .black
        view.setTitleColor(.white, for: .normal)
        view.setTitle("추가", for: .normal)
        return view
    }()
    
    var data: [String] = []
    let items = PublishSubject<[String]>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    
    private func bind() {
        Observable
            .zip(addButton.rx.tap, textField.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                print("추가")
                owner.data.append(value.1)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: SampleTableViewCell.identifier, cellType: SampleTableViewCell.self)) { row, element, cell in
                cell.nameLabel.text = element
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
