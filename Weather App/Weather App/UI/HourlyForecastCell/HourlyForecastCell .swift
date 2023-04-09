//
//  HourlyForecastCell .swift
//  Weather App
//
//  Created by Mustafo on 09/04/23.
//

import Foundation
import UIKit
import SnapKit

class HourlyForecastCell: UICollectionViewCell {
    
    static let id = "HourlyForecastCell"
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    var hour: Hour! {
        didSet {
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    private func configure() {
        addSubview(hourLabel)
        addSubview(tempLabel)
            
        
        setUpConstraints()
        
        backgroundColor = .magenta
        layer.cornerRadius = 12

        
        let date = Date(timeIntervalSince1970: hour.timeEpoch)
        hourLabel.text = date.defaultFormatted(format: "HH:00")
        tempLabel.text = "\(hour.tempC)°"
    }
    
    
    private func setUpConstraints() {
        
        hourLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        tempLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
}

