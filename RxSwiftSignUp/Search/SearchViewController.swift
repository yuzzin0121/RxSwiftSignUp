//
//  SearchViewController.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
        configureView()
        bind()
    }
    
    @objc func plusButtonClicked() {
        let sample = ["A", "B", "C", "D", "E"]
        data.append(sample.randomElement()!)
        items.onNext(data)
    }
    
    private func bind() {
        // 셀 정의
        items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = "text \(element)"
                cell.appIconImageView.backgroundColor = .systemBlue
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind(with: self) { owner, value in
                owner.data.remove(at: value.0.row)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        
        // 서치바 텍스트가 포함된 결과를 테이블뷰에 보여주기
        // 사용자가 검색하면 1초 뒤에 네트워크 통신을 진행
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("실시간 검색: \(value)")
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("검색 버튼 클릭: \(value)")
                let result = value.isEmpty ? owner.data : owner.data.filter {
                    $0.contains(value)
                }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
    }
    
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
       
   }
}
