//
//  ShoppingViewModel.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    let inputText = PublishSubject<String>()
    let inputCellTap = PublishSubject<Void>()
    let inputAddButtonTap = PublishSubject<Void>()
    var inputData: [ShoppingItem] = []
    var outputList = BehaviorRelay<[ShoppingItem]>(value: [])
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let inputText: ControlProperty<String?>
        let inputAddButtonTap: ControlEvent<Void>
    }
    
    struct Output {
      
    }
    
    init() {
//        transform()
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
    
    
//    private func transform() {
//        // 입력된 아이템
//        inputText
//            .distinctUntilChanged()
//            .subscribe(with: self) { owner, value in
//                print("")
//                let result = value.isEmpty ? "" : value
//            }
//            .disposed(by: disposeBag)
//        
//        
//        // 추가버튼 클릭 시
//        inputAddButtonTap
//            .withLatestFrom(inputText)
//            .subscribe(with: self) { owner, value in
//                print("inputAddButtonTap Sub")
//                var list =  owner.outputList.value
//                let item = ShoppingItem(itemName: value)
//                list.append(item)
//                owner.outputList.accept(list)
//            }
//            .disposed(by: disposeBag)
//    }
}
