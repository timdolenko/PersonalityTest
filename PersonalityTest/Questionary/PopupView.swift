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
            make.width.equalTo(160)
            make.height.equalTo(60)
            make.top.equalTo(indicator).offset(14)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
