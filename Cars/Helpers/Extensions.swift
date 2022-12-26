//
//  Extensions.swift
//  Cars
//
//  Created by Linkon Sid on 20/12/22.
//
import UIKit
import SwiftUI

class AppTheme {
    static func navigationBarColors(background : UIColor?,
       titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = background ?? .clear
        
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
       
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}

extension String{
    // converts plain string to data
    var data:Data? {
        get{
            guard let url = URL(string: self) else {
                return nil
            }
            if let infoData = try? Data(contentsOf: url) {
                return infoData
            }
            return nil
        }
    }
}

extension String {
    public enum DateType {
        case isoDateTimeSec
        case dmy
        case localDateTimeSec
        
        var stringFormat:String {
          switch self {
          case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
          case .dmy: return "dd.MM.yyyy HH:mm"
          case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
          }
        }
 }
        
 func toDate(_ format: DateType = .dmy) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
  }
 }

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
extension Date{
    func getDateOfMonth()->Int{
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.day, from: self)
        return weekDay
    }
    func getTime()->(hour:Int,minute:Int,second:Int){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        return (hour,minutes,seconds)
    }
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    func getYearByComparingToCurrent()->String{
        let currentDate = Date()
        let calendar = Calendar.current
        let currDatecomponents = calendar.dateComponents([.year], from: currentDate)
        let givenDateComponents = calendar.dateComponents([.year], from: self)
        guard let currentYear = currDatecomponents.year, let givenYear = givenDateComponents.year,currentYear != givenYear else{
            return ""
        }
        return String(givenYear)
    }
}
