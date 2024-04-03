//
//  ShoppingView.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 4/4/24.
//

import UIKit
import SnapKit

class ShoppingView: UIView {
    let searchBar = UISearchBar()
    let addTextField = UITextField()
    let addButton = UIButton()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    
    func configureHierarchy() {
        addSubview(addTextField)
        addSubview(addButton)
        addSubview(tableView)
    }
    func configureLayout() {
        addTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(addTextField.snp.centerY)
            make.trailing.equalTo(addTextField.snp.trailing).offset(-16)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addTextField.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    func configureView() {
        backgroundColor = .white
        addTextField.placeholder = "무엇을 구매하실 건가요?"
        addTextField.textColor = .black
        addTextField.borderStyle = .roundedRect
        addTextField.backgroundColor = .white
        
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .systemGray4
        addButton.layer.cornerRadius = 6
        
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
