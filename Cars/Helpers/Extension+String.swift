//
//  Extension+String.swift
//  Cars
//
//  Created by Linkon Sid on 17/4/23.
//

import Foundation

extension String {
    // converts plain string to data
    var data: Data? {
        guard let url = URL(string: self) else {
            return nil
        }
        if let infoData = try? Data(contentsOf: url) {
            return infoData
        }
        return nil
    }
}

extension String {
    public enum DateType {
        case isoDateTimeSec
        case dmy
        case localDateTimeSec
        var stringFormat: String {
            switch self {
            case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .dmy: return "dd.MM.yyyy HH:mm"
            case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
            }
        }
    }

    func toDate(_ format: DateType = .dmy) -> Date? {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
    }
}
