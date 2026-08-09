import Foundation

enum AppointmentStatus: String, CaseIterable, Identifiable {
    case scheduled = "Scheduled"
    case started = "Started"
    case completed = "Completed"
    case cancelled = "Cancelled"

    var id: String { rawValue }
}

struct Client: Identifiable, Hashable {
    let id: UUID
    var name: String
    var phone: String
    var address: String
    var cleaningNotes: String
    var accessDetails: String

    init(id: UUID = UUID(), name: String, phone: String, address: String, cleaningNotes: String, accessDetails: String = "") {
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
        self.cleaningNotes = cleaningNotes
        self.accessDetails = accessDetails
    }
}

struct Employee: Identifiable, Hashable {
    let id: UUID
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

struct Appointment: Identifiable, Hashable {
    let id: UUID
    var clientID: UUID
    var employeeID: UUID?
    var startsAt: Date
    var durationMinutes: Int
    var status: AppointmentStatus
    var requiresBeforePhotos: Bool
    var requiresAfterPhotos: Bool

    init(id: UUID = UUID(), clientID: UUID, employeeID: UUID? = nil, startsAt: Date, durationMinutes: Int, status: AppointmentStatus = .scheduled, requiresBeforePhotos: Bool = true, requiresAfterPhotos: Bool = true) {
        self.id = id
        self.clientID = clientID
        self.employeeID = employeeID
        self.startsAt = startsAt
        self.durationMinutes = durationMinutes
        self.status = status
        self.requiresBeforePhotos = requiresBeforePhotos
        self.requiresAfterPhotos = requiresAfterPhotos
    }
}
