import Foundation
import Combine

final class OwnerStore: ObservableObject {
    @Published var clients: [Client]
    @Published var employees: [Employee]
    @Published var appointments: [Appointment]

    init() {
        let maria = Client(
            name: "Maria Lopez",
            phone: "(555) 123-4567",
            email: "maria@example.com",
            address: "123 Oak Street, Springfield, IL",
            cleaningNotes: "Prefers morning appointments",
            preferredService: .standard,
            lastServiceDate: Date().addingTimeInterval(-7 * 24 * 3600)
        )
        
        let jordan = Client(
            name: "Jordan Smith",
            phone: "(555) 234-5678",
            email: "jordan@example.com",
            address: "456 Elm Avenue, Springfield, IL",
            cleaningNotes: "Office space",
            preferredService: .deep
        )
        
        let maya = Employee(
            name: "Maya Rodriguez",
            phone: "(555) 111-2222",
            email: "maya@lgcleaning.com",
            role: .teamLead
        )
        
        let alex = Employee(
            name: "Alex Thompson",
            phone: "(555) 222-3333",
            email: "alex@lgcleaning.com",
            role: .cleaner
        )
        
        let taylor = Employee(
            name: "Taylor Brown",
            phone: "(555) 333-4444",
            email: "taylor@lgcleaning.com",
            role: .cleaner
        )
        
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

    func futureAppointments() -> [Appointment] {
        appointments.filter { $0.startsAt > Date() }
            .sorted { $0.startsAt < $1.startsAt }
    }

    func appointmentsForEmployee(_ employeeID: UUID) -> [Appointment] {
        appointments.filter { $0.employeeID == employeeID }
            .sorted { $0.startsAt < $1.startsAt }
    }

    func appointmentsForClient(_ clientID: UUID) -> [Appointment] {
        appointments.filter { $0.clientID == clientID }
            .sorted { $0.startsAt < $1.startsAt }
    }

    func addClient(_ client: Client) {
        clients.append(client)
    }

    func updateClient(_ client: Client) {
        if let index = clients.firstIndex(where: { $0.id == client.id }) {
            clients[index] = client
        }
    }

    func deleteClient(_ clientID: UUID) {
        clients.removeAll { $0.id == clientID }
    }

    func addEmployee(_ employee: Employee) {
        employees.append(employee)
    }

    func updateEmployee(_ employee: Employee) {
        if let index = employees.firstIndex(where: { $0.id == employee.id }) {
            employees[index] = employee
        }
    }

    func deleteEmployee(_ employeeID: UUID) {
        employees.removeAll { $0.id == employeeID }
    }

    func addAppointment(_ appointment: Appointment) {
        appointments.append(appointment)
    }

    func updateAppointment(_ appointment: Appointment) {
        if let index = appointments.firstIndex(where: { $0.id == appointment.id }) {
            appointments[index] = appointment
        }
    }

    func deleteAppointment(_ appointmentID: UUID) {
        appointments.removeAll { $0.id == appointmentID }
    }
}
