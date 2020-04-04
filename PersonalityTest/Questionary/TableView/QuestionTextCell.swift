//
//  QuestionTextCell.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import UIKit
import SnapKit

public class QuestionTextCell: UITableViewCell {
    
    static var identifier: String { String(describing: self) }
    
    class var textFont: UIFont { .avenirOfSize(16) }
    class var textHorizontalMargin: CGFloat { 16.0 }
    
    class func height(for questionText: String, with width: CGFloat) -> CGFloat {
        questionText.width(withConstrainedHeight: width - textHorizontalMargin * 2, font: textFont)
    }
    
    weak var titleLbl: UILabel!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .screenDarkBackground
        
        let label = UILabel()
        label.font = QuestionTextCell.textFont
        label.textColor = .textLightColor
        label.textAlignment = .justified
        
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(QuestionTextCell.textHorizontalMargin)
            make.right.equalToSuperview()
                .offset(QuestionTextCell.textHorizontalMargin)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(12)
        }
        
        titleLbl = label
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
