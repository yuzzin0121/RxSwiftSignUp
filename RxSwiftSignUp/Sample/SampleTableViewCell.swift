//
//  SampleTableViewCell.swift
//  RxSwiftSignUp
//
//  Created by 조유진 on 4/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SampleTableViewCell: UITableViewCell {
    static let identifier = "SampleTableViewCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()

    
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureView() {
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
