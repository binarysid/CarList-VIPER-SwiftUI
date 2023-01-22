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
    func presentViewDataFromAPIData(articles:[CarData])
    func presentViewDataFromLocalData(cars:[Car])
    func hasViewData()->Bool
    func showError()
}
final class CarListPresenter{
    private(set) var viewError: Bool = false{
        didSet{
            viewState.setErrorStatus(hasError: viewError)
        }
    }
    private(set) var viewLoader: Bool = false{
        didSet{
            viewState.setActivityIndicator(show: viewLoader)
        }
    }
    private(set) var viewObject: [CarViewData] = []{
        didSet{
            viewState.setViewObject(data: viewObject)
        }
    }
    var viewState:CarListStateProtocol!
    
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
    func presentViewDataFromAPIData(articles:[CarData]){
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
    func presentViewDataFromLocalData(cars:[Car]){
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
