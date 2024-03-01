//
//  Model.swift
//  surfers
//
//  Created by United It Services on 21/08/23.
//

import Foundation
import UIKit

struct search: Codable {
    var workingType: String
    var name: String
    var taskTitle: String
    var dateRange:String
    var startTime:String
    var endTime:String
    var breakTime:String
    var servicelat:String
    var servicelong:String
    var type:String
    var id: Int
    var timeCardType:Int
    var createBy:Int
    var taskName:String
    var hours: String
    var minutes:String
    
    init( workingType: String, name: String,taskTitle:String, dateRange:String, startTime:String, id: Int, endTime:String, breakTime:String, servicelat: String, servicelong: String, type:String,timeCardType:Int, createBy:Int, taskName: String, hours:String, minutes:String) {
        self.workingType = workingType
        self.name = name
        self.taskTitle = taskTitle
        self.dateRange = dateRange
        self.startTime = startTime
        self.endTime = endTime
        self.servicelat = servicelat
        self.servicelong = servicelong
        self.type = type
        self.id = id
        self.breakTime = breakTime
        self.timeCardType = timeCardType
        self.createBy = createBy
        self.taskName = taskName
        self.hours = hours
        self.minutes = minutes
    }
    
}
struct dashboard: Codable {
    var image: [String]
    var name: [String]
    var count: [Int]
    
    
    init( image: [String], name: [String], count: [Int]) {
        self.name = name
        self.image = image
        self.count = count
    }
    
}

struct profile: Codable {
    var image: [String]
    var name: [String]
    
    init( image: [String], name: [String]) {
        self.name = name
        self.image = image
    }
    
}

struct showWorker: Codable {
    var wName: [String]
    var wService: [String]
    var wHeader: [String]
    
    init( wName: [String], wService: [String], wHeader: [String] ) {
        self.wName = wName
        self.wService = wService
        self.wHeader = wHeader
    }
    
}

struct projectDetails: Codable {
    var section: [String]
    var header: [[String]]
    var subheader: [[String]]
    
    init( section: [String], header: [[String]], subheader: [[String]] ) {
        self.section = section
        self.header = header
        self.subheader = subheader
    }
    
}

struct showNotes: Codable {
    var nsdate: String
    var nstime: String
    var ntitle: String
    var nid: Int
    var url: String
    var npimage: String
    var npname: String
    var roleId: Int
    var nImageId: [NoteImage]
    init( nsdate: String, nstime: String ,ntitle: String, nid: Int, nImageId: [NoteImage], url: String, npimage: String ,npname: String, roleId: Int){
        self.nsdate = nsdate
        self.nstime = nstime
        self.ntitle = ntitle
        self.nid = nid
        self.nImageId = nImageId
        self.url = url
        self.npname = npname
        self.npimage = npimage
        self.roleId = roleId
    }
    
}

struct showAdminNotes: Codable {
    var nsdate: String
    var nstime: String
    var ntitle: String
    var nid: Int
    var url: String
    var nImageId: [NoteImage]
    init( nsdate: String, nstime: String ,ntitle: String, nid: Int, nImageId: [NoteImage], url: String ){
        self.nsdate = nsdate
        self.nstime = nstime
        self.ntitle = ntitle
        self.nid = nid
        self.nImageId = nImageId
        self.url = url
    }
    
}

struct CommonNote {
    let url: String
    let id: Int
    let note_title: String
    let note: String
    let date: String
    let time: String
    let image: [ImageInfo]
}

struct ImageInfo {
    let id: Int
    let images: String
}



struct showProject: Codable {
    var id: Int
    var name: String
    
    init( id: Int, name: String) {
        self.name = name
        self.id = id
    }
    
}



struct showBreakDetails: Codable {
    var id: Int
    var startDate: String
    var endDate: String
    var duration: String
    
    init( id: Int, startDate: String, endDate: String,duration: String ) {
        self.startDate = startDate
        self.endDate = endDate
        self.duration = duration
        self.id = id
    }
    
}


struct showCheckListDetails: Codable {
    var id: Int
    var employee_id: Int
    var project_id: Int
    var task_id: Int
    var title: String
    var status: Int
    
    init( id: Int, employee_id: Int, title: String,project_id: Int, task_id: Int, status: Int ) {
        self.id = id
        self.employee_id = employee_id
        self.project_id = project_id
        self.task_id = task_id
        self.title = title
        self.status = status
    }
    
}

struct createCheckList: Codable {
    var id: Int
    var title: String
    var status: Int
    
    init( id: Int, title: String, status: Int ) {
        self.id = id
        self.title = title
        self.status = status
    }
    
}



struct breakDurations: Codable {
    var duration: Int
    var time: String
    var id: Int
    
    init( duration: Int, time: String, id: Int) {
        self.duration = duration
        self.time = time
        self.id = id
    }
    
}

struct showCADetails: Codable {
    var isSelected: Bool
    var nameCA: String
    var idCA: Int
    
    init( isSelected: Bool, nameCA: String, idCA: Int ) {
        self.isSelected = isSelected
        self.nameCA = nameCA
        self.idCA = idCA
    }
    
}
struct selectProjectTask: Codable {
    var id: Int
    var name: String
    var location: String
    var manager_id: String
    var manager_name: String
    
    init( id: Int, name: String, location: String, manager_id: String, manager_name: String) {
        self.id = id
        self.name = name
        self.location = location
        self.manager_id = manager_id
        self.manager_name = manager_name
    }
    
}


struct showFilter: Codable {
    var id: [[Int]]
    var name: [[String]]
    var titl: [String]
    var selected: [String]
    
    init( id: [[Int]], name: [[String]], titl: [String], selected: [String]) {
        self.id = id
        self.name = name
        self.titl = titl
        self.selected = selected
    }
    
}


struct selectionDetails: Codable {
    var member_id: String
    var timezone_id: Int
    var project_id: Int
    var label_id: Int
    var watcher_id: String
    
    var member_name: String
    var timezone_name: String
    var project_name: String
    var label_name: String
    var watcher_name: String
    var type: String
    var location: String
    
    init( member_id: String,
          timezone_id: Int,
          project_id: Int,
          label_id: Int,
          watcher_id: String,
          member_name: String,
          timezone_name: String,
          project_name: String,
          label_name: String,
          watcher_name: String, type:String, location: String ) {
        
        self.member_id = member_id
        self.timezone_id = timezone_id
        self.project_id = project_id
        self.label_id = label_id
        self.watcher_id = watcher_id
        self.member_name = member_name
        
        self.timezone_name = timezone_name
        self.project_name = project_name
        self.label_name = label_name
        self.watcher_name = watcher_name
        self.location = location
        self.type = type
        
    }
    
}


struct crewClockedIn: Codable {
    var isSelected: Bool
    var name: String
    var date: String
    var ids: Int
    
    
    init( isSelected: Bool, name: String, date: String, ids: Int) {
        self.isSelected = isSelected
        self.name = name
        self.date = date
        self.ids = ids
    }
    
}

struct crewClockedOut: Codable {
    var isSelected: Bool
    var name: String
    var date: String
    var ids: Int
    
    
    init( isSelected: Bool, name: String, date: String, ids: Int) {
        self.isSelected = isSelected
        self.name = name
        self.date = date
        self.ids = ids
    }
    
}
struct dayWiseData: Codable {
        var startDateTime: String
       var endDateTime: String?
       var totalWorkHours: String
       var totalWorkMin: String
       var totalWorkSec: String
       var day: String
       var breakTime: String
    
    init( startDateTime: String,  endDateTime: String?,totalWorkHours: String, totalWorkMin: String,totalWorkSec: String,   day: String, breakTime: String) {
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.totalWorkHours = totalWorkHours
        self.totalWorkMin = totalWorkMin
        self.totalWorkSec = totalWorkSec
        self.day = day
        self.breakTime = breakTime
    }
    
}


struct projectDetailAdmin: Codable {
    var name: String
    var total_miles: String
    var total_travel_time: String
    var total_spendtime: String
    var total_cost:String
    
    init( total_miles: String, name: String, total_travel_time: String, total_spendtime: String, total_cost:String) {
        self.name = name
        self.total_miles = total_miles
        self.total_travel_time = total_travel_time
        self.total_spendtime = total_spendtime
        self.total_cost = total_cost
    }
    
}


struct crewListing: Codable {
    var name: String
    var email: String
    var phone: String
    var profile_image: String
    var status:String
    
    init( email: String, name: String, phone: String, profile_image: String, status:String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.profile_image = profile_image
        self.status = status
    }
    
}

struct registerListing: Codable {
    var role: Int
    var name: String
    var email: String
    var mobile: String
    var time_tracking:String
    var time_approver: String
    var overtime_status: String
    var mealbreak_policy:String
    var status:Int

    init( role: Int, name: String, email: String, mobile: String, status:Int, time_tracking:String,time_approver: String, overtime_status: String, mealbreak_policy:String ) {
        self.role = role
        self.name = name
        self.email = email
        self.mobile = mobile
        self.time_tracking = time_tracking
        self.time_approver = time_approver
        self.overtime_status = overtime_status
        self.mealbreak_policy = mealbreak_policy
        self.status = status
    }
    
}


struct AppInfo: Codable {
    let status: Int
    let message: String
    let app: AppDetails
}

struct AppDetails: Codable {
    let url: String
    let version: String
    let deviceType: String

    // Define custom coding keys to map snake_case keys to camelCase
    private enum CodingKeys: String, CodingKey {
        case url, version
        case deviceType = "device_type"
    }
}
