//
//  QuestionTextCell.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import UIKit
import SnapKit

public class QuestionTextCell: UITableViewCell {
    
    class var textFont: UIFont { .avenirOfSize(16) }
    class var textHorizontalMargin: CGFloat { 20.0 }
    class var textVerticalMargin: CGFloat { 12.0 }
    
    class func height(for questionText: String, with width: CGFloat) -> CGFloat {
        questionText.height(withConstrainedWidth: width - textHorizontalMargin * 2, font: textFont) + textVerticalMargin * 2
    }
    
    private weak var titleLbl: UILabel!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .screenDarkBackground
        
        let label = UILabel()
        label.font = QuestionTextCell.textFont
        label.textColor = .textLightColor
        label.textAlignment = .left
        label.numberOfLines = 0
        
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(safeAreaLayoutGuide.snp.left)
                .offset(QuestionTextCell.textHorizontalMargin)
            make.right.equalTo(safeAreaLayoutGuide.snp.right)
                .offset(-QuestionTextCell.textHorizontalMargin)
            make.top.equalToSuperview().offset(QuestionTextCell.textVerticalMargin)
        }
        
        titleLbl = label
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(with question: String) {
        titleLbl.text = question
    }
}

// MARK:  Class Identifiable
extension QuestionTextCell: ClassIdentifiable {}
