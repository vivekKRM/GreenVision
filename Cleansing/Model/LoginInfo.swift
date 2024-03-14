//
//  LoginInfo.swift
//  Cleansing
//
//  Created by United It Services on 13/09/23.
//

import Foundation

struct LoginInfo: Codable {
    let status: Int
    let message: String
    let token: String
    let user: User
    let url: String
}

struct User: Codable {
    let id: Int
    let fullname: String
    let email: String
    let mobile_number: String
    let profile_image: String? // Assuming the profile_image can be null
    let role: Int
    
}

struct DefaultInfo: Codable {
    let status: Int
    let message: String
}


struct DashboardInfo: Codable {
    let status: Int
    let message: String
    let url: String
    let data: Dash
}

struct Dash: Codable {
    let name: String
    let email: String
    let latitude: String
    let longitude: String
    let ongoing_projects: Int
    let completed_projects: Int
    let upcoming_projects: Int
//    let total_earning: Float?
    let active_users: Int
    let inactive_users:Int
    let all_projects: Int
    let spend_time: String
    let profile_image: String?
}


struct WorkDashInfo: Codable {
    let status: Int
    let message: String
    let url: String
    let data: WorkDash
}

struct WorkDash: Codable {
    let name: String
    let email: String
    let latitude: String
    let longitude: String
    let ongoing_projects: Int
    let completed_projects: Int
    let upcoming_projects: Int
    let total_earning: Float?
    let all_projects: Int
    let spend_time: String
    let profile_image: String?
}


struct ProfileInfo: Codable {
    let status: Int
    let message: String
    let url: String
    let lang:String
    let data: Prof
}

struct Prof: Codable {
    let fullname: String
    let email: String
    let mobile_number: String
    let profile_image: String?
}


struct GetProjectInfo: Codable {
    let status: Int
    let message: String
    let url: String
    let data: [GetProject]
}

struct GetProject: Codable {
    let id: Int
    let project_name: String
    let emp_id: Int
    let customer_name: String
    let location: String?
    let status: Int
    let start_date: String
    let end_date: String
}

struct GetTaskInfo: Codable {
    let status: Int
    let message: String
    let url: String
    let filter: String
    let data: [GetTask]
}

struct GetTask: Codable {
    let id: Int
    let task_title: String
    let emp_id: Int
    let start_date: String
    let start_time: String
    let end_date: String
    let note_message: String
    let end_time: String
    let `break`: String
    let site_latitude: String
    let site_longitude: String
    let emp_latitude: String
    let emp_longitude: String
    let status: String//String
}

struct TaskDetailInfo: Codable {
    let status: Int
    let message: String
    let data: TaskDetail
    let notes: [Note]
    let admin_note: [Note]
    let breakTimes: [Break]?
    let checklist: [CheckLists]
}

struct TaskDetail: Codable {
    let id: Int
    let task_title: String
    let emp_id: String
    let start_date: String?
    let end_date: String?
    let `break`: String?
    let location: String
    let work_id: Int
    let status: Int
    let hours: Int
    let minute: Int
    let second: Int
}

struct Note: Codable {
    let id: Int?
    let url: String?
    let note_title: String?
    let uploaded_by: String?
    let uploaded_by_profile: String?
    let note: String?
    let date: String?
    let time: String?
    let role: Int?
    let image: [NoteImage]
}

struct CheckLists: Codable {
    let id: Int
    let employee_id: Int
    let project_id: Int
    let task_id: Int
    let title: String
    let status: Int
}

struct Break: Codable {
    let id: Int?
    let duration: String?
    let start_time: String?
    let end_time: String?
}
struct NoteImage: Codable {
    let id: Int?
    let images: String?
}

struct ShowNotesInfo: Codable {
        let status: Int
       let message: String
       let url: String
       let data: [DataObject]
       let images: [ShowNotes]?
}

struct DataObject: Codable {
    let id: Int
    let employee_id: String
    let task_id: Int
    let note_title: String
    let notes: String
}

struct ShowNotes: Codable {
    let id: Int
    let images: String
}


struct WorkStatusInfo: Codable {
    let status: Int
    let message: String
    let url: String
    let data: TaskDetail
    let notes: [Note]
}

struct WorkStatus: Codable {
    let id: Int
    let task_title: String
    let emp_id: String
    let start_date: String
    let start_time: String
    let end_date: String
    let end_time: String
    let `break`: String
    let location: String
    let status: Int
}

struct RouteData: Codable {
    let status: Int
    let data: RouteDataInfo
}

struct RouteDataInfo: Codable {
    let distanceInKm: String
    let distanceInMiles: Double
    let duration: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case distanceInKm = "distance_in_km"
        case distanceInMiles = "distance_in_miles"
        case duration
        case status
    }
}

struct BreakDuration: Codable {
    let status: Int
    let message: String
    let data: [BreakDurationInfo]
}

struct BreakDurationInfo: Codable {
    let id: Int
    let duration: Int
    let status: Int
    let createdAt: String
    let updatedAt: String
    let time: String

    enum CodingKeys: String, CodingKey {
        case id
        case duration
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case time
    }
}
//Get Total Task Hour

struct GetTotalTaskInfo: Codable {
    let status: Int
    let message: String
    let total_hours: Int
    let total_minutes: Int
}

struct TaskResponse: Codable {
    let status: Int
    let message: String
    let task: [Task]
}

struct Task: Codable {
    let id: Int
    let taskTitle: String
    let location: String?
    let manager_id: Int
    let manager_name: String

    enum CodingKeys: String, CodingKey {
        case id
        case taskTitle = "task_title"
        case location
        case  manager_id
        case manager_name
    }
}

struct GetTimeCardNewInfo: Codable {
    let status: Int
    let message: String
//    let url: String
    let filter: String
    let totalTime:String
    let regulartime:String
    let overtime:String
    let timeCards: [GetTaskNew]
}

struct GetTaskNew: Codable {
    let id: Int
    let name: String
    let task_name: String
    let timecard_type: Int
    let hours:String
    let minutes:String
    let short_name: String
    let date: String
    let start_time: String
    let end_time: String
    let `break`: String//Done String on 31 Oct 2:14
    let site_latitude: String
    let site_longitude: String
    let type: String
    let created_by: Int
//    let emp_latitude: String
//    let emp_longitude: String
    let approve: Int
}


struct TimeCardDetailsInfo: Codable {
    let status: Int
    let message: String
    let timeCards: [TimeCardDetails]
}

struct TimeCardDetails: Codable {
    let id: Int
    let task_id: Int
    let timecard_type:Int
    let project_id: Int
    let task_name: String
    let hours: String
    let minutes: String
    let emp_start_longitude: String
    let emp_start_latitude: String
    let emp_end_longitude: String
    let emp_end_latitude: String
    let start_time: String
    let end_time: String
    let site_latitude: String
    let site_longitude: String
    let member_id: Int
    let member_name: String
    let manager_id: Int//int to string on
    let manager_name: String
    let approve: Int
    let notes: [Note]
    let site_start_time: String
    let site_end_time:String
    let location:String
    let `break`: [BreaksDetails]
}

struct BreaksDetails: Codable {
    let id: Int
    let start_date_time: String
    let end_date_time: String
}




struct BreakResponse: Codable {
    let status: Int
    let message: String
    let breaks: [Breakers]
}

struct Breakers: Codable {
    let id: Int
    let start_date_time: String
    let end_date_time: String
}

struct CustomerResponse: Codable {
    let status: Int
    let message: String
    let customer: [Customer]
}

struct Customer: Codable {
    let id: Int
    let name: String
}

struct ManagerResponse: Codable {
    let status: Int
    let message: String
    let manager: [Manager]
}

struct Manager: Codable {
    let id: Int
    let fullname: String
}

struct TimeZoneResponse: Codable {
    let status: Int
    let message: String
    let timezone: [TimeZone]
}

struct TimeZone: Codable {
    let id: Int
    let name: String
}

struct MembersResponse: Codable {
    let status: Int
    let message: String
    let members: [Members]
}

struct Members: Codable {
    let id: Int
    let fullname: String
}


struct ProjectResponse: Codable {
    let status: Int
    let message: String
    let projects: [Project]
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case projects = "project"
    }
}

struct Project: Codable {
    let id: Int
    let projectName: String
    let customerName: String
    let location: String
    let cost: Double
    let latitude: String
    let longitude: String
    let spendTime: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectName = "project_name"
        case customerName = "customer_name"
        case location
        case latitude
        case longitude
        case cost
        case spendTime = "spendTime"
    }
}


struct ProjectResponseAdmin: Codable {
    let status: Int
    let message: String
    let project: ProjectAdmin
}

struct ProjectAdmin: Codable {
    let id: Int
    let projectName: String
    let managerID: String
    let customerID: Int
    let location: String
    let customerName: String
    let street: String
    let managerName: String
    let latitude: String
    let longitude: String

    enum CodingKeys: String, CodingKey {
        case id
        case projectName = "project_name"
        case managerID = "manager_id"
        case customerID = "customer_id"
        case location
        case street
        case customerName = "customer_name"
        case managerName = "manager_name"
        case latitude
        case longitude
    }
}


struct AdminTaskResponse: Codable {
    let status: Int
    let message: String
    let filter: String
    let data: [AdminTask]
}

struct AdminTask: Codable {
    let taskId: Int
       let title: String
       let location: String
       let startDateTime: String
       let shortName: [ShortName]
       let dueDateTime: String
       let totalChecklist: Int
       let status: String
       let checkedChecklist: Int
       let totalNotes: Int

       enum CodingKeys: String, CodingKey {
           case taskId = "task_id"
           case shortName = "short_name"
           case title, location, startDateTime = "start_date_time", dueDateTime = "due_date_time"
           case totalChecklist = "total_checklist", status, checkedChecklist = "checked_checklist", totalNotes = "total_notes"
       }
}

struct ShortName: Codable {
       let short_name: String
       let background_color: String
       let text_color: String
}





struct AddAdminTasks: Codable {
    let status: Int
    let message: String
    let task: AddAdminTask
}

struct AddAdminTask: Codable {
    let taskId: Int
    let title: String
    let startDateTime: String
    let dueDateTime: String
    let timeZone: String
    let location: String
    let latitude: String
    let longitude: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case taskId = "task_id"
        case title
        case startDateTime = "start_date_time"
        case dueDateTime = "due_date_time"
        case timeZone = "time_zone"
        case location
        case latitude
        case longitude
        case status
    }
}



struct DetailAdminTasks: Codable {
    let status: Int
    let message: String
    let task: DetailAdminTask
}
struct DetailAdminTask: Codable {
        let title: String
       let projectId: Int
       let projectName: String
       let memberId: String
       let memberName: String
       let managerId: Int
       let managerName: String
       let location: String
       let startDateTime: String
       let dueDateTime: String
       let formatedstartDateTime: String
       let formateddueDateTime: String
       let status: Int
       let timezone: String
        let notes: [Note]
       let latitude: String
       let longitude: String
       let checklist: [ChecklistItem]

    enum CodingKeys: String, CodingKey {
           case title
           case projectId = "project_id"
           case projectName = "project_name"
           case memberId = "member_id"
           case memberName = "member_name"
           case managerId = "manager_id"
           case managerName = "manager_name"
           case location
            case notes
            case status
           case startDateTime = "start_date_time"
           case dueDateTime = "due_date_time"
            case formatedstartDateTime = "formated_start_date_time"
        case formateddueDateTime = "formated_due_date_time"
           case timezone
           case latitude
           case longitude
           case checklist
       }
}
struct ChecklistItem: Codable {
    let title: String
    let status: Int
    let id: Int
}

struct EmployeeResponse: Codable {
    let status: Int
    let message: String
    let invite_data: [EmployeeInvite]
    let emp_data: [EmployeeData]
}

struct EmployeeInvite: Codable {
    let role: Int
    let name: String
    let email: String
    let mobile: String
    let time_tracking: String
    let time_approver: String
    let overtime_status: String
    let overtime_policy: String
    let mealbreak_policy: String
    let status: Int
}

struct EmployeeData: Codable {
    let name: String
    let email: String
    let phone: String
    let profile_image: String
    let status: String
}


struct InviteResponse: Codable {
    let status: Int
    let message: String
    let invite: [Invite]
}

struct Invite: Codable {
    let role: Int
    let name: String
    let email: String
    let mobile: String
    let timeTracking: String
    let timeApprover: String
    let overtimeStatus: String
    let overtimePolicy: String
    let mealbreakPolicy: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case role, name, email, mobile, status
        case timeTracking = "time_tracking"
        case timeApprover = "time_approver"
        case overtimeStatus = "overtime_status"
        case overtimePolicy = "overtime_policy"
        case mealbreakPolicy = "mealbreak_policy"
    }
}


struct DayWiseData: Codable {
    let startDateTime: String
    let endDateTime: String?
    let totalWorkHours: String
    let totalWorkMin: String
    let totalWorkSec: String
    let day: String
    let breakTime: String

    enum CodingKeys: String, CodingKey {
        case startDateTime = "start_date_time"
        case endDateTime = "end_date_time"
        case totalWorkHours = "total_work_hours"
        case totalWorkMin = "total_work_min"
        case totalWorkSec = "total_work_sec"
        case day
        case breakTime = "break"
    }
}

struct ApiResponse: Codable {
    let status: Int
    let message: String
    let dayWiseData: [DayWiseData]
}



struct WorkRespons: Codable {
    let status: Int
    let message: String
    let data: WorkData
}

struct WorkData: Codable {
    let id: Int
    let startTime: String
    let endTime: String?
    let status: Int
//    let duration: Int?
    let workId: Int
    let hours: Int
    let minute: Int
    let second: Int

    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case status
//        case duration
        case workId = "work_id"
        case hours
        case minute
        case second
    }
}


struct ApiRespons: Codable {
    let status: Int
    let message: String
    let data: WorkDatas
    let breakTimes: [BreakTime]?
}

struct WorkDatas: Codable {
    let start_time: String
    let end_time: String?
    let work_id: Int
    let `break`: String
    let status: Int
    let hours: Int
    let minute: Int
    let second: Int
    let start_latitude: String
    let start_longitude: String
    let end_latitudde: String?
    let end_longitude: String?
    let location: String
    let site_start_time: String
    let site_end_time: String
    let site_duration: String
}

struct BreakTime: Codable {
    let id: Int
    let duration: String
    let start_time: String
    let end_time:String
}


struct ProjectDetails: Codable {
    let status: Int
    let message: String
    let dateFilter: String
    let totalMiles: String
    let totalTravelTime: String
    let totalSpendTime: String
    let totalCost: String
    let latitude: String
    let longitude: String
    let location: String
    let data: [UserData]

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case dateFilter = "date_filter"
        case totalMiles = "total_miles"
        case totalTravelTime = "total_travel_time"
        case totalSpendTime = "total_spendtime"
        case totalCost = "total_cost"
        case latitude
        case longitude
        case location
        case data
    }
}

struct UserData: Codable {
    let name: String
    let total_miles: String
    let total_travel_time: String
    let total_spendtime: String
    let total_cost: String
}


struct LanguageResponse: Codable {
    let status: Int
    let message: String
    let languages: [Language]
    
    private enum CodingKeys: String, CodingKey {
        case status, message, languages = "lang"
    }
}

struct Language: Codable {
    let id: Int
    let name: String
    let shortName: String
    let status: Int
    let createdAt: String
    let updatedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, shortName = "short_name", status, createdAt = "created_at", updatedAt = "updated_at"
    }
}
