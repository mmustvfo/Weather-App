//
//  DetailWeatherViewController.swift
//  Weather App
//
//  Created by Mustafo on 09/04/23.
//

import Foundation
import UIKit
import SnapKit

class DetailWeatherViewController: UIViewController {
    
    let todayDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        
        return label
    }()
    
    
    
    let hourForecastCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.id)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(todayDate)
        view.addSubview(hourForecastCollection)
        
        view.backgroundColor = .white
        
        hourForecastCollection.delegate = self
        hourForecastCollection.dataSource = self
        
        setupConstraints()
    }
    
    
    var forecastDay: Forecastday! {
        didSet {
            DispatchQueue.main.async {
                self.configureViews()
            }
        }
    }
    
    private func configureViews() {
        let date = Date(timeIntervalSince1970: forecastDay.dateEpoch)
        todayDate.text = date.defaultFormatted()
        
        
    }
    
    private func setupConstraints() {
        
        todayDate.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2.5)
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        
        hourForecastCollection.snp.makeConstraints { make in
            make.top.equalTo(todayDate.snp_bottomMargin).inset(10)
            make.height.equalTo(200)
            make.width.equalToSuperview()
            make.left.equalToSuperview().inset(5)
        }
    }
    
}

extension DetailWeatherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 150)
    }
    
}

extension DetailWeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastDay.hour.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.id, for: indexPath) as? HourlyForecastCell else {
            return UICollectionViewCell()
        }
        hourlyCell.hour = forecastDay.hour[indexPath.row]
        return hourlyCell
    }
    
    
    
    
}
