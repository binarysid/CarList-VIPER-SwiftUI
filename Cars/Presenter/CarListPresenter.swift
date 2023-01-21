//
//  CarListPresenter.swift
//  Cars
//
//  Created by Linkon Sid on 19/1/23.
//

import Combine
import Foundation

protocol Loadable{
    func showLoader()
    func hideLoader()
}
protocol CarListPresentable:Loadable{
    func processViewDataFrom(articles:[CarData])
    func processViewDataFrom(cars:[Car])
    func hasViewData()->Bool
    func showError()
}
final class CarListPresenter:CarListViewable{
    @Published private(set) var viewError: Bool = false
    @Published private(set) var viewLoader: Bool = false
    @Published private(set) var viewObject: [CarViewData] = []
    var viewErrorPublisher: Published<Bool>.Publisher{  $viewError }
    var viewLoaderPublisher: Published<Bool>.Publisher{  $viewLoader }
    var viewObjectPublisher: Published<[CarViewData]>.Publisher{ $viewObject }
    private func processDateFrom(_ dateObj:Date?)->(date:String,time:String){
        var presentableTime = ""
        var presentableDate = ""
        if let date = dateObj{
            let time = date.getTime()
            presentableDate = "\(date.getDateOfMonth()) \(date.getMonthName()) \(date.getYearByComparingToCurrent())"
            presentableTime = "\(time.hour):\(time.minute)"
        }
        return (presentableDate,presentableTime)
    }
}

extension CarListPresenter:CarListPresentable{
    // Convert API data to Presentable object
    func processViewDataFrom(articles:[CarData]){
        viewObject = articles.map{[weak self] item -> CarViewData in // convert to domain object for presentation
            var resultDate = ""
            var resultTime = ""
            if let calendar = self?.processDateFrom(item.dateTime.toDate()){
                resultDate = calendar.date
                resultTime = calendar.time
            }
            return CarViewData(id:item.id, title: item.title, image: item.image, description: item.ingress, date: resultDate, time: resultTime)
        }
    }
    // Convert Local data to Presentable object
    func processViewDataFrom(cars:[Car]){
        viewObject = cars.map{[weak self] item -> CarViewData in // convert to domain object for presentation
            var resultDate = ""
            var resultTime = ""
            if let calendar = self?.processDateFrom(item.date){
                resultDate = calendar.date
                resultTime = calendar.time
            }
            return CarViewData(id:item.id, title: item.title, image: item.image, description: item.ingress, date: resultDate, time: resultTime)
        }
    }
    func hasViewData() -> Bool {
        return viewObject.count>0
    }
    func showLoader() {
        viewLoader = true
    }
    func hideLoader() {
        viewLoader = false
    }
    func showError(){
        viewError = true
    }
}
