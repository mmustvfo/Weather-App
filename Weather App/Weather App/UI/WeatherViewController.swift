//
//  ViewController.swift
//  Weather App
//
//  Created by Mustafo on 09/04/23.
//

import UIKit
import SnapKit
import Combine

class WeatherViewController: UIViewController {
    
    private let currentWeather: UILabel = {
        let label = UILabel()
        label.text = "Loading Data"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let weatherDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 35, weight: .regular)
        label.textColor = .systemOrange
        
        return label
    }()
    
    private let forecastDaysPicker: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["3 Days","7 Days","10 Days"])
        segmentedControl.selectedSegmentIndex = 0
        
        
        return segmentedControl
    }()
    
    private let forecastCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DailyCollectionViewCell.self, forCellWithReuseIdentifier: DailyCollectionViewCell.id)
        
        return collectionView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = WeatherViewModel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addViews()
        view.backgroundColor = .white
        
        forecastDaysPicker.addTarget(self, action: #selector(self.didChangeForeCast(_:)), for: .valueChanged)
        
        forecastCollection.dataSource = self
        forecastCollection.delegate = self
        
        setUpConstraints()
        addBindings()
    }
    
    private func addViews() {
        view.addSubview(currentWeather)
        view.addSubview(weatherDescription)
        view.addSubview(forecastDaysPicker)
        view.addSubview(forecastCollection)

    }
    
    private func setUpConstraints() {
        currentWeather.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(4)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        weatherDescription.snp.makeConstraints { make in
            make.top.equalTo(currentWeather.snp_bottomMargin)
            make.height.equalToSuperview().dividedBy(4)
            make.width.equalToSuperview()
            
        }
        
        forecastDaysPicker.snp.makeConstraints { make in
            make.top.equalTo(weatherDescription.snp_bottomMargin).inset(10)
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        forecastCollection.snp.makeConstraints { make in
            make.top.equalTo(forecastDaysPicker.snp_bottomMargin).inset(-20)
            make.width.equalToSuperview()
            make.height.equalTo(80)
            make.left.equalToSuperview().inset(5)
        }
    }
    
    @objc private func didChangeForeCast(_ sender: UISegmentedControl) {
        let newValue = sender.selectedSegmentIndex == 0 ? 3 : (sender.selectedSegmentIndex == 1 ? 7 : 10)
        viewModel.forecastDays = newValue
    }
    
    private func addBindings() {
        
        viewModel.$currentWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                guard let weather, let self else { return }
                self.currentWeather.text = "\(weather.current.feelslikeC) °C"
                self.weatherDescription.text = "\(weather.current.condition.text)"
            }
            .store(in: &cancellables)
        
        viewModel.$forecastWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.forecastCollection.reloadData()
            }
            .store(in: &cancellables)
        
    }
    


}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 160, height: 80)
    }
    
}



extension WeatherViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.forecastWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dailyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCollectionViewCell.id, for: indexPath) as? DailyCollectionViewCell else {
            return UICollectionViewCell()
        }
        dailyCollectionViewCell.forecastDay = viewModel.forecastWeather[indexPath.row]
        return dailyCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailWeatherVC = DetailWeatherViewController()
        let model = viewModel.forecastWeather[indexPath.row]
        detailWeatherVC.forecastDay = model
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailWeatherVC, animated: true)
        }
    }
    
    
    
}
