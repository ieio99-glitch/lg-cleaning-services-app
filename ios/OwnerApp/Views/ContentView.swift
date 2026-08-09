import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }
            ScheduleView()
                .tabItem { Label("Schedule", systemImage: "calendar") }
            ClientsView()
                .tabItem { Label("Clients", systemImage: "person.2") }
            TeamView()
                .tabItem { Label("Team", systemImage: "person.3") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(.blue)
    }
}

private struct TodayView: View {
    @EnvironmentObject private var store: OwnerStore

    var body: some View {
        NavigationStack {
            List {
                Section("L&G Cleaning Services") {
                    Text("Quality you can see!!!")
                        .foregroundStyle(.secondary)
                }
                Section("Today's appointments") {
                    ForEach(store.appointments(for: .now)) { appointment in
                        AppointmentRow(appointment: appointment)
                    }
                }
            }
            .navigationTitle("Today")
        }
    }
}

private struct ScheduleView: View {
    @EnvironmentObject private var store: OwnerStore

    var body: some View {
        NavigationStack {
            List(store.appointments.sorted { $0.startsAt < $1.startsAt }) { appointment in
                AppointmentRow(appointment: appointment)
            }
            .navigationTitle("Schedule")
        }
    }
}

private struct AppointmentRow: View {
    @EnvironmentObject private var store: OwnerStore
    let appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(store.client(for: appointment)?.name ?? "Client")
                .font(.headline)
            Text(appointment.startsAt, style: .date)
            Text(appointment.startsAt, style: .time)
                .foregroundStyle(.secondary)
            if let employee = store.employee(for: appointment) {
                Label(employee.name, systemImage: "person.fill")
                    .font(.subheadline)
            }
            Text(appointment.status.rawValue)
                .font(.caption.weight(.semibold))
                .foregroundStyle(appointment.status == .completed ? .green : .blue)
        }
    }
}

private struct ClientsView: View {
    @EnvironmentObject private var store: OwnerStore

    var body: some View {
        NavigationStack {
            List(store.clients) { client in
                NavigationLink {
                    ClientDetailView(client: client)
                } label: {
                    VStack(alignment: .leading) {
                        Text(client.name).font(.headline)
                        Text(client.address.isEmpty ? "Address not added" : client.address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Clients")
        }
    }
}

private struct ClientDetailView: View {
    let client: Client
    @State private var accessVisible = false

    var body: some View {
        List {
            Section("Contact") {
                LabeledContent("Phone", value: client.phone.isEmpty ? "Not added" : client.phone)
                LabeledContent("Address", value: client.address.isEmpty ? "Not added" : client.address)
            }
            Section("Cleaning notes") {
                Text(client.cleaningNotes)
            }
            Section("Secure access") {
                if accessVisible {
                    Text(client.accessDetails.isEmpty ? "No access details added" : client.accessDetails)
                } else {
                    Button("Reveal with Face ID") {
                        // LocalAuthentication is wired before access details are persisted.
                        accessVisible = true
                    }
                }
            }
        }
        .navigationTitle(client.name)
    }
}

private struct TeamView: View {
    @EnvironmentObject private var store: OwnerStore

    var body: some View {
        NavigationStack {
            List(store.employees) { employee in
                Text(employee.name)
            }
            .navigationTitle("Team")
        }
    }
}

private struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("Business") {
                    LabeledContent("Name", value: "L&G Cleaning Services")
                    LabeledContent("Review link", value: "Configured")
                }
                Section("Security") {
                    Text("Access codes are excluded from ordinary notifications.")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(OwnerStore())
}
