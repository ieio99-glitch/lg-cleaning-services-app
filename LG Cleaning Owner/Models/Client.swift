import Foundation

// MARK: - Models

struct Client: Identifiable, Hashable {
    let id: UUID
    var name: String
    var phone: String
    var email: String
    var address: String
    var cleaningNotes: String
    var accessDetails: String
    var preferredService: CleaningService
    var lastServiceDate: Date?
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        phone: String = "",
        email: String = "",
        address: String = "",
        cleaningNotes: String = "",
        accessDetails: String = "",
        preferredService: CleaningService = .standard,
        lastServiceDate: Date? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.address = address
        self.cleaningNotes = cleaningNotes
        self.accessDetails = accessDetails
        self.preferredService = preferredService
        self.lastServiceDate = lastServiceDate
        self.isActive = isActive
    }
}

struct Employee: Identifiable, Hashable {
    let id: UUID
    var name: String
    var phone: String
    var email: String
    var role: EmployeeRole
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        phone: String = "",
        email: String = "",
        role: EmployeeRole = .cleaner,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.role = role
        self.isActive = isActive
    }
}

struct Appointment: Identifiable, Hashable {
    let id: UUID
    var clientID: UUID
    var employeeID: UUID?
    var startsAt: Date
    var durationMinutes: Int
    var status: AppointmentStatus
    var serviceType: CleaningService
    var requiresBeforePhotos: Bool
    var requiresAfterPhotos: Bool
    var notes: String

    init(
        id: UUID = UUID(),
        clientID: UUID,
        employeeID: UUID? = nil,
        startsAt: Date,
        durationMinutes: Int,
        status: AppointmentStatus = .scheduled,
        serviceType: CleaningService = .standard,
        requiresBeforePhotos: Bool = true,
        requiresAfterPhotos: Bool = true,
        notes: String = ""
    ) {
        self.id = id
        self.clientID = clientID
        self.employeeID = employeeID
        self.startsAt = startsAt
        self.durationMinutes = durationMinutes
        self.status = status
        self.serviceType = serviceType
        self.requiresBeforePhotos = requiresBeforePhotos
        self.requiresAfterPhotos = requiresAfterPhotos
        self.notes = notes
    }

    var endsAt: Date {
        startsAt.addingTimeInterval(TimeInterval(durationMinutes * 60))
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(startsAt)
    }

    var isFuture: Bool {
        startsAt > Date()
    }
}
