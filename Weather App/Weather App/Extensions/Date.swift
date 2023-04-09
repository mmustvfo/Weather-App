//
//  Date.swift
//  Weather App
//
//  Created by Mustafo on 09/04/23.
//

import Foundation

extension Date {
    
    func defaultFormatted(format: String = "d MMM")-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
}
