import Foundation
import Combine

final class OwnerStore: ObservableObject {
    @Published var clients: [Client]
    @Published var employees: [Employee]
    @Published var appointments: [Appointment]

    init() {
        let maria = Client(name: "Maria Lopez", phone: "", address: "", cleaningNotes: "Demo client — replace with a real client in the app.")
        let jordan = Client(name: "Jordan Smith", phone: "", address: "", cleaningNotes: "Demo client — replace with a real client in the app.")
        let maya = Employee(name: "Maya")
        let alex = Employee(name: "Alex")
        let taylor = Employee(name: "Taylor")
        clients = [maria, jordan]
        employees = [maya, alex, taylor]
        appointments = [
            Appointment(clientID: maria.id, employeeID: maya.id, startsAt: .now.addingTimeInterval(3600), durationMinutes: 120),
            Appointment(clientID: jordan.id, employeeID: alex.id, startsAt: .now.addingTimeInterval(10800), durationMinutes: 180)
        ]
    }

    func client(for appointment: Appointment) -> Client? {
        clients.first { $0.id == appointment.clientID }
    }

    func employee(for appointment: Appointment) -> Employee? {
        guard let employeeID = appointment.employeeID else { return nil }
        return employees.first { $0.id == employeeID }
    }

    func appointments(for date: Date) -> [Appointment] {
        appointments.filter { Calendar.current.isDate($0.startsAt, inSameDayAs: date) }
            .sorted { $0.startsAt < $1.startsAt }
    }
}
