//
//  AnswerRangeCell.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import UIKit
import SnapKit

public class AnswerRangeCell: UITableViewCell {
    
    static var identifier: String { String(describing: self) }
    
    class var height: CGFloat { 92.0 }
    
    weak var titleLbl: UILabel!
    weak var slider: UISlider!
    
    public var didChangeValue: ((Int) -> ())?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .elevatedDarkBackground
        
        let label = UILabel()
        label.font = .avenirOfSize(16)
        label.textColor = .textLightColor
        label.textAlignment = .center
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(20)
            make.height.equalTo(22)
        }
        
        let slider = UISlider()
        slider.tintColor = .accentColor
        slider.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        addSubview(slider)
        
        slider.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.titleLbl = label
        self.slider = slider
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setOption(value: Int) {
        
    }
    
    @objc func didChangeValue(_ sender: UIButton) {
        didChangeValue?(Int(slider.value))
    }
}
