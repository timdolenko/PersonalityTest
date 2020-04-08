//
//  AnswerRangeCell.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 08.04.2020.
//

import Foundation

import UIKit
import SnapKit

public class AnswerRangeCell: UITableViewCell {
    
    class var height: CGFloat { 264.0 }
    
    private weak var titleLbl: UILabel!
    private weak var pickerView: UIPickerView!
    
    private enum Component: Int {
        case from
        case to
    }
    
    private var range: AnswerDescription.NumberRange = .init(from: 0, to: 0) {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    private var selectedRange: AnswerDescription.NumberRange = .init(from: 0, to: 0) {
        didSet {
            pickerView.selectRow(convertNumber(selectedRange.from), inComponent: Component.from.rawValue, animated: false)
            pickerView.selectRow(convertNumber(selectedRange.to), inComponent: Component.to.rawValue, animated: false)
            
            titleLbl.text = "\(selectedRange.from) - \(selectedRange.to)"
        }
    }
    
    public var didChangeValue: ((AnswerDescription.NumberRange) -> ())?
    
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
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(22)
        }
        
        let picker = UIPickerView()
        picker.delegate = self
        addSubview(picker)
        
        picker.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
            make.height.equalTo(216)
        }
        
        self.titleLbl = label
        self.pickerView = picker
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(with range: AnswerDescription.NumberRange) {
        self.range = range
    }
    
    public func setRange(selectedRange: AnswerDescription.NumberRange?) {
        self.selectedRange = selectedRange ?? range
    }
}

extension AnswerRangeCell {
    private func convertIndex(_ index: Int) -> Int {
        range.from + index
    }
    private func convertNumber(_ number: Int) -> Int {
        number - range.from
    }
}

extension AnswerRangeCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Component.to.rawValue + 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        range.to - range.from + 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(convertIndex(row))
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let from = convertIndex(pickerView.selectedRow(inComponent: Component.from.rawValue))
        let to = convertIndex(pickerView.selectedRow(inComponent: Component.to.rawValue))
        let range = AnswerDescription.NumberRange(from: from, to: to)
        print("did select \(range) \(range)")
        didChangeValue?(range)
    }
}

// MARK:  Class Identifiable
extension AnswerRangeCell: ClassIdentifiable {}
