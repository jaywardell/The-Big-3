//
//  TestingFlags.swift
//  PersonalLog
//
//  Created by Joseph Wardell on 12/9/22.
//

import Foundation

struct TestingFlags {
    
    static var `default`: TestingFlags { TestingFlags() }

    var deleteLogOnFirstLaunch: Bool {
#if NEGATETODELETE // negate this to get the behavior
#warning("Delete log on launch is turned on. DO NOT COMMIT!!!!")
        return true
#else
        return false
#endif
    }

    var offsetDateForLogEntries: Bool {
#if NEGATETOOFFSET // negate this to get the behavior
#warning("Date offset for new entries is turned on. DO NOT COMMIT!!!!")
        return true
#else
        return false
#endif
    }
    
    var restrictCalendarsFromReminders: Bool {
#if NEGATETORESTRICT // negate this to get the behavior
#warning("Restrict Calendars from Reminders is turned on. DO NOT COMMIT!!!!")
        return true
#else
        return false
#endif
    }

}
