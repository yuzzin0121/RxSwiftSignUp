//
//  ShoppingTableViewCell.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 4/4/24.
//

import UIKit
import RxSwift

class ShoppingTableViewCell: UITableViewCell {
    static let identifier = "ShoppingTableViewCell"
    
    let checkButton = UIButton()
    let itemLabel = UILabel()
    let starButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(item: nil)
        disposeBag = DisposeBag()
    }
    
    func configureCell(item: ShoppingItem?) {
        guard let item else { return }
        itemLabel.text = item.itemName
        
        let checkImage: UIImage? = item.isDone ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        let starImage: UIImage? = item.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        checkButton.setImage(checkImage, for: .normal)
        starButton.setImage(starImage, for: .normal)
    }
    
    private func configureHierarchy() {
        contentView.addSubview(checkButton)
        contentView.addSubview(itemLabel)
        contentView.addSubview(starButton)
    }
    private func configureLayout() {
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.leading.equalTo(checkButton.snp.trailing).offset(16)
        }
        
        starButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
    private func configureView() {
        checkButton.tintColor = .black
        itemLabel.font = .boldSystemFont(ofSize: 14)
        itemLabel.textColor = .black
        starButton.tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
