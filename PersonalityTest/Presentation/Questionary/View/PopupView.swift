//
//  PopupView.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 04.04.2020.
//

import UIKit
import SnapKit

class PopupView: UIView {
    
    weak var label: UILabel!
    weak var activityIndicator: UIActivityIndicatorView!
    weak var iconImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .avenirOfSize(14)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        addSubview(label)
        
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        addSubview(indicator)
        
        
        indicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(36)
            make.top.equalToSuperview()
        }
        
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(indicator)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.top.equalTo(indicator.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        self.label = label
        self.activityIndicator = indicator
        self.iconImageView = iconImageView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
