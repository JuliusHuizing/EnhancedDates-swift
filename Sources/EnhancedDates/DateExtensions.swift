import Foundation

// MARK: - Date Modifying Methods

extension Date {
    
    func midnight() -> Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: self)
    }
}


// MARK: - Static Methods
extension Date {

    static func distantPast() -> Date {

        return Calendar.current.date(
            byAdding: .year,
            value: -1000,
            to: Date())!
    }
    static func distantFuture() -> Date {
        return Calendar.current.date(
            byAdding: .year,
            value: 1000,
            to: Date())!
    }

}

extension Date {

    static func dates(from: Date, till: Date) -> [Date] {
        
        let from = from.midnight()
        let till = till.midnight()
        
        if from == till {
            return [from]
        }
        
        var days = [Date]()
        var date = from
        for _ in 1 ... 1_000_000 {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            days.append(date)

            if Calendar.current.isDate(date, equalTo: till, toGranularity: .day) {
                break
            }
        }

        return days

    }

    
    static func datesSinceLast(_ weekday: Weekday) -> [Date] {

        let lastDate = Date.now.previous(weekday)
        var days = [Date.now.midnight()]
        var date = Date.now.midnight()
        for _ in 1 ... 7 {
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            days.append(date)

            if Calendar.current.isDate(lastDate, equalTo: Date.today().previous(.monday), toGranularity: .day) {
                break
            }
        }

        return days
    }

    
    /// Gets the days of the current week from Monday till Sunday.
    /// - Returns: An array containing the midnight dates of the given week from  Monday till Sunday.
    ///
    /// - Note: All dates returned are exaclty at midnight.
    static func datesThisWeek() -> [Date] {
        var dates = [Date.today().previous(.monday).midnight()]
        for _ in 1 ... 7 {
            let prevDate = dates.last!
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: prevDate)!
            // Only display dates untill next Sunday.
            if Calendar.current.isDate(newDate, equalTo: Date.today().next(.monday), toGranularity: .day) {
                break
            }
            dates.append(newDate)

        }
        return dates
    }

}








// The following extensions is adapted from: https://sarunw.com/posts/getting-number-of-days-between-two-dates/

extension Calendar {
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>

        return numberOfDays.day!
    }
}


// Note: The following extension are adapted from: https://stackoverflow.com/questions/33397101/how-to-get-mondays-date-of-the-current-week-in-swift

extension Date {
  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

      return date!.midnight()
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}



