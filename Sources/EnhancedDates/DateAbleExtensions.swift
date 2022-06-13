//
//  File.swift
//  
//
//  Created by Julius Huizing on 13/06/2022.
//

import Foundation


// MARK: - Protocol

public protocol DateAble {
    var date: Date { get }
}


// MARK: - Extensions

public extension Array where Element: DateAble {
    
    var dates: [Date] {
        let dates = self.map {$0.date}
        return dates.sorted(by: {$1 > $0})

    }
    
    func between(_ startdate: Date?, and endDate: Date?) -> [Element] {
        return self.filter({ $0.date >= (startdate ?? Date.distantPast()) && $0.date <= (endDate ?? Date.distantFuture()) })
    }
    var earliestDate: Date? {
        return self.sorted(by: {$0.date < $1.date}).first?.date
    }
    var latestDate: Date? {
        return self.sorted(by: {$0.date < $1.date}).last?.date
    }
}
