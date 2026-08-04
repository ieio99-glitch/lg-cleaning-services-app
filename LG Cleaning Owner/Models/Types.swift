import Foundation

enum AppointmentStatus: String, CaseIterable, Identifiable {
    case scheduled = "Scheduled"
    case started = "Started"
    case completed = "Completed"
    case cancelled = "Cancelled"

    var id: String { rawValue }
}

enum CleaningService: String, CaseIterable, Identifiable {
    case standard = "Standard Cleaning"
    case deep = "Deep Cleaning"
    case carpet = "Carpet Cleaning"
    case windows = "Window Cleaning"
    case moveIn = "Move-In/Out"
    case postConstruction = "Post-Construction"

    var id: String { rawValue }
}

enum EmployeeRole: String, CaseIterable, Identifiable {
    case cleaner = "Cleaner"
    case teamLead = "Team Lead"
    case supervisor = "Supervisor"

    var id: String { rawValue }
}
