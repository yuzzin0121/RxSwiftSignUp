//
//  ShoppingViewController.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 4/4/24.
//

import UIKit
import RxSwift
import RxCocoa

class ShoppingViewController: UIViewController {
    let mainView = ShoppingView()
    
    var data: [ShoppingItem] = []
    var list = PublishSubject<[ShoppingItem]>()
    let disposeBag = DisposeBag()
    
    let viewModel = ShoppingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigatoinItem()
        bind()
    }
    
    private func bind() {
        // 셀 정의
        list.bind(to: mainView.tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { row, element, cell in
            cell.configureCell(item: element)
            cell.checkButton.rx.tap
                .bind(with: self) { owner, Void in
                    owner.viewModel.inputData[row].isDone.toggle()
                    owner.list.onNext(owner.viewModel.inputData)
                }
                .disposed(by: cell.disposeBag)
            
            cell.starButton.rx.tap.bind(with: self) { owner, _ in
                owner.viewModel.inputData[row].favorite.toggle()
                owner.list.onNext(owner.viewModel.inputData)
            }.disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        mainView.addTextField.rx.text.orEmpty
            .bind(to: viewModel.inputText)
            .disposed(by: disposeBag)
        
        // 추가 버튼 클릭 시
        mainView.addButton.rx.tap.bind(with: self) { owner, _ in
            guard let inputText = owner.mainView.addTextField.text else { return }
            let item = ShoppingItem(itemName: inputText)
            owner.data.append(item)
            owner.list.onNext(owner.data)
        }
        .disposed(by: disposeBag)
        
        mainView.addButton.rx.tap
            .bind(to: viewModel.inputAddButtonTap)
            .disposed(by: disposeBag)
        
        
        
        // 셀 클릭 시
        Observable.zip(mainView.tableView.rx.itemSelected, mainView.tableView.rx.modelSelected(ShoppingItem.self))
            .bind(with: self) { owner, value in
                owner.data.remove(at: value.0.row)
                owner.list.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        // 검색 키워드 타이핑할 때
        mainView.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
            let result = text.isEmpty ? owner.data : owner.data.filter { $0.itemName.contains(text) }
            owner.list.onNext(result)
        }.disposed(by: disposeBag)
        
        // 검색버튼 클릭 시
        mainView.searchBar.rx.searchButtonClicked
            .withLatestFrom(mainView.searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                let result = text.isEmpty ? owner.data : owner.data.filter { $0.itemName.contains(text) }
                owner.list.onNext(result)
                owner.mainView.addTextField.text = ""
            }
            .disposed(by: disposeBag)
    }
 
    override func loadView() {
        view = mainView
    }
    
    private func configureNavigatoinItem() {
        navigationItem.titleView = mainView.searchBar
    }

}
