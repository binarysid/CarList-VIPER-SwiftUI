//
//  CarPresenter.swift
//  Cars
//
//  Created by Linkon Sid on 12/4/23.
//

import Foundation

class CarListPresenter {
    var router: (any CarRouting)?
    var interactor: CarInteracting?
    weak var view: CarViewOutput?
}

// MARK:- Presenter Input
extension CarListPresenter: CarViewInput {
    func fetchCarList() async {
        await interactor?.fetchCars()
    }
    func makeDetailView(with data: CarViewData) -> CarDetailView? {
        router?.makeDetailView(with: data)
    }
}

// MARK:- Presenter Output
extension CarListPresenter:CarPresenting {
    func didFetchCars(result: Result<[CarData], NetworkError>) {
        switch result {
        case .success(let data):
            view?.update(data: convertToViewData(data: data))
        case .failure(let error):
            view?.update(error: error.localizedDescription)
        }
    }
}

// MARK:- Presentation Logic
extension CarListPresenter {
    private func convertToViewData(data: [CarData]) -> [CarViewData] {
        data.map{ item -> CarViewData in
            let calendar = self.processDateFrom(item.dateTime.toDate())
            return CarViewData(id: item.id, title: item.title, image: item.image, description: item.ingress, date: calendar.date, time: calendar.time)
        }
    }

    private func processDateFrom(_ dateObj: Date?) -> (date: String, time: String) {
        var presentableTime = ""
        var presentableDate = ""
        if let date = dateObj{
            let time = date.getTime()
            presentableDate = "\(date.getDateOfMonth()) \(date.getMonthName()) \(date.getYearByComparingToCurrent())"
            presentableTime = "\(time.hour):\(time.minute)"
        }
        return (presentableDate, presentableTime)
    }
}
