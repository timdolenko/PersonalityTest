//
//  AnswerOptionCell.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import UIKit
import SnapKit

public class AnswerOptionCell: UITableViewCell {
    
    static var identifier: String { String(describing: self) }
    
    class var textFont: UIFont { .avenirOfSize(16) }
    class var textHorizontalMargin: CGFloat { 20.0 }
    class var textVerticalMargin: CGFloat { 12.0 }
    class var checkboxSize: CGFloat { 36.0 }
    class var checkboxRightMargin: CGFloat { 20.0 }
    
    class func height(for optionText: String, with width: CGFloat) -> CGFloat {
        optionText.height(
            withConstrainedWidth: width - textHorizontalMargin * 2
                - checkboxSize - checkboxRightMargin,
            font: textFont
        ) + textVerticalMargin * 2
    }
    
    private weak var titleLbl: UILabel!
    private weak var checkboxImageView: UIImageView!
    private weak var tapAreaButton: UIButton!
    
    public var didTap: (() -> ())?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .elevatedDarkBackground
        
        let label = UILabel()
        label.font = AnswerOptionCell.textFont
        label.textColor = .textLightColor
        label.textAlignment = .left
        label.numberOfLines = 0
        
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(AnswerOptionCell.textHorizontalMargin)
            make.top.equalToSuperview().offset(AnswerOptionCell.textVerticalMargin)
        }
        
        let checkboxImageView = UIImageView()
        checkboxImageView.contentMode = .scaleAspectFit
        checkboxImageView.image = #imageLiteral(resourceName: "checkbox_white_empty.pdf")
        addSubview(checkboxImageView)
        
        checkboxImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7)
            make.size.equalTo(AnswerOptionCell.checkboxSize)
            make.left.equalTo(label.snp.right)
                .offset(QuestionTextCell.textHorizontalMargin)
            make.right.equalToSuperview().offset(-AnswerOptionCell.checkboxRightMargin)
        }
        
        let button = UIButton()
        button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(4)
        }
        
        self.titleLbl = label
        self.checkboxImageView = checkboxImageView
        self.tapAreaButton = button
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(with option: String) {
        titleLbl.text = option
    }
    
    public func setOption(selected isSelected: Bool) {
        checkboxImageView.image = isSelected ? #imageLiteral(resourceName: "checkbox_checked.pdf") : #imageLiteral(resourceName: "checkbox_white_empty.pdf")
    }
    
    @objc func didTap(_ sender: UIButton) {
        didTap?()
    }
}

// MARK:  Class Identifiable
extension AnswerOptionCell: ClassIdentifiable {}
