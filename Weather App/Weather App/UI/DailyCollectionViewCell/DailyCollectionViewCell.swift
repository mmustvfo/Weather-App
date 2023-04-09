//
//  ForecastCollection.swift
//  Weather App
//
//  Created by Mustafo on 09/04/23.
//

import Foundation
import UIKit
import SnapKit

class DailyCollectionViewCell: UICollectionViewCell {
    
    static let id = "DailyCollectionViewCell"
    
    private let hourlyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let dayTemp: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    private let dayDate: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    var forecastDay: Forecastday! {
        didSet {
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    func configure() {
        
        [hourlyImageView, dayTemp, dayDate].forEach { addSubview($0) }

        backgroundColor = .systemIndigo
        layer.cornerRadius = 12
        
        setUpConstraints()
        
        let date = Date(timeIntervalSince1970: Double(forecastDay.dateEpoch))
        dayDate.text = "\(dateString(from: date))"
        dayTemp.text = "\(forecastDay.day.mintempC)°---\(forecastDay.day.maxtempC)°"
        hourlyImageView.image = getImage(for: forecastDay)
    }
    
    
    private func getImage(for day: Forecastday)-> UIImage? {
        if day.day.dailyWillItRain == 1 {
            return UIImage(named: "rain")
        } else if day.day.dailyWillItSnow == 1 {
            return UIImage(named: "snow")
        }
        return UIImage(named: "sun")
    }
    
    private func dateString(from date: Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: date)
    }
    
    private func setUpConstraints() {
        hourlyImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2.5)
            make.height.equalToSuperview()
        }

        dayTemp.snp.makeConstraints { make in
            make.left.equalTo(hourlyImageView.snp_rightMargin)
            make.width.lessThanOrEqualToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.top.equalToSuperview()
        }
        
        dayDate.snp.makeConstraints { make in
            make.left.equalTo(hourlyImageView.snp_rightMargin)
            make.width.lessThanOrEqualToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.equalToSuperview()
        }
    }
    
}
