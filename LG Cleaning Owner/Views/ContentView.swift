import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }

            ScheduleView()
                .tabItem { Label("Schedule", systemImage: "calendar") }

            GoogleCalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar.badge.plus") }

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

// MARK: - Today View
private struct TodayView: View {
    @EnvironmentObject private var store: OwnerStore

    var todaysAppointments: [Appointment] {
        store.appointments(for: .now)
    }

    var body: some View {
        NavigationStack {
            if todaysAppointments.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)

                    Text("No appointments today")
                        .font(.title2.bold())

                    Text("You have a clear schedule. Great job staying organized!")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .navigationTitle("Today")
            } else {
                List {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("L&G Cleaning Services")
                                .font(.headline)
                            Text("Quality you can see!!!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }

                    Section("Today's Appointments") {
                        ForEach(todaysAppointments) { appointment in
                            NavigationLink {
                                AppointmentDetailView(appointment: appointment)
                            } label: {
                                AppointmentRow(appointment: appointment)
                            }
                        }
                    }

                    Section {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(.blue)
                            Text("\(todaysAppointments.count) appointment\(todaysAppointments.count == 1 ? "" : "s") today")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .navigationTitle("Today")
            }
        }
    }
}

// MARK: - Schedule View
private struct ScheduleView: View {
    @EnvironmentObject private var store: OwnerStore

    var body: some View {
        NavigationStack {
            List(store.appointments.sorted { $0.startsAt < $1.startsAt }) { appointment in
                NavigationLink {
                    AppointmentDetailView(appointment: appointment)
                } label: {
                    AppointmentRow(appointment: appointment)
                }
            }
            .navigationTitle("Schedule")
        }
    }
}

// MARK: - Appointment Row
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

// MARK: - Clients View
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

// MARK: - Client Detail View
private struct ClientDetailView: View {
    let client: Client
    @State private var accessVisible = false

    var body: some View {
        List {
            Section("Contact") {
                LabeledContent("Name", value: client.name)
                LabeledContent("Phone", value: client.phone.isEmpty ? "Not added" : client.phone)
                LabeledContent("Email", value: client.email.isEmpty ? "Not added" : client.email)
                LabeledContent("Address", value: client.address.isEmpty ? "Not added" : client.address)
            }
            Section("Service") {
                LabeledContent("Preferred Service", value: client.preferredService.rawValue)
            }
            Section("Cleaning notes") {
                Text(client.cleaningNotes)
            }
            Section("Secure access") {
                if accessVisible {
                    Text(client.accessDetails.isEmpty ? "No access details added" : client.accessDetails)
                } else {
                    Button("Reveal with Face ID") {
                        accessVisible = true
                    }
                }
            }
        }
        .navigationTitle(client.name)
    }
}

// MARK: - Team View
private struct TeamView: View {
    @EnvironmentObject private var store: OwnerStore
    @State private var searchText = ""
    @State private var showingNewMemberSheet = false
    @State private var editingMember: Employee?
    @State private var filterRole: EmployeeRole? = nil

    var filteredAndSortedMembers: [Employee] {
        var members = store.employees

        if !searchText.isEmpty {
            members = members.filter { employee in
                employee.name.localizedCaseInsensitiveContains(searchText) ||
                employee.phone.localizedCaseInsensitiveContains(searchText) ||
                employee.email.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let role = filterRole {
            members = members.filter { $0.role == role }
        }

        return members.sorted { $0.name < $1.name }
    }

    var body: some View {
        NavigationStack {
            if store.employees.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)

                    Text("No team members yet")
                        .font(.title2.bold())

                    Text("Add your first team member to get started")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button(action: { showingNewMemberSheet = true }) {
                        Label("Add Team Member", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .navigationTitle("Team")
            } else {
                List {
                    ForEach(filteredAndSortedMembers) { employee in
                        NavigationLink {
                            TeamMemberDetailView(employee: employee)
                        } label: {
                            TeamMemberRow(employee: employee)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                store.deleteEmployee(employee.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                editingMember = employee
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search team members")
                .navigationTitle("Team")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Filter by Role", selection: $filterRole) {
                                Text("All Roles").tag(EmployeeRole?(nil))
                                ForEach(EmployeeRole.allCases) { role in
                                    Text(role.rawValue).tag(EmployeeRole?(role))
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showingNewMemberSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewMemberSheet) {
            TeamMemberFormView(isPresented: $showingNewMemberSheet)
        }
        .sheet(isPresented: Binding(
            get: { editingMember != nil },
            set: { if !$0 { editingMember = nil } }
        )) {
            if let member = editingMember {
                TeamMemberFormView(isPresented: Binding(
                    get: { editingMember != nil },
                    set: { if !$0 { editingMember = nil } }
                ))
            }
        }
    }
}

// MARK: - Team Member Row
private struct TeamMemberRow: View {
    @EnvironmentObject private var store: OwnerStore
    let employee: Employee

    var appointmentCount: Int {
        store.appointmentsForEmployee(employee.id).count
    }

    var nextAppointment: Appointment? {
        store.appointmentsForEmployee(employee.id)
            .filter { $0.startsAt > Date() }
            .sorted { $0.startsAt < $1.startsAt }
            .first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(employee.name)
                        .font(.headline)
                    Label(employee.role.rawValue, systemImage: "briefcase.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                HStack(spacing: 2) {
                    Image(systemName: employee.isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(employee.isActive ? .green : .gray)
                    Text(employee.isActive ? "Active" : "Inactive")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !employee.phone.isEmpty {
                Label(employee.phone, systemImage: "phone.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                Label("\(appointmentCount) appointment\(appointmentCount == 1 ? "" : "s")", systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(.blue)

                if let next = nextAppointment {
                    Label(next.startsAt.formatted(date: .abbreviated, time: .omitted), systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Team Member Form View
private struct TeamMemberFormView: View {
    @EnvironmentObject private var store: OwnerStore
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var role: EmployeeRole = .cleaner
    @State private var isActive = true

    let employee: Employee?

    init(isPresented: Binding<Bool>, employee: Employee? = nil) {
        self._isPresented = isPresented
        self.employee = employee
        if let emp = employee {
            _name = State(initialValue: emp.name)
            _phone = State(initialValue: emp.phone)
            _email = State(initialValue: emp.email)
            _role = State(initialValue: emp.role)
            _isActive = State(initialValue: emp.isActive)
        }
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }

                Section("Role") {
                    Picker("Position", selection: $role) {
                        ForEach(EmployeeRole.allCases) { r in
                            Text(r.rawValue).tag(r)
                        }
                    }
                }

                Section("Status") {
                    Toggle("Active", isOn: $isActive)
                }
            }
            .navigationTitle(employee == nil ? "New Team Member" : "Edit Team Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveMember()
                    }
                    .disabled(!isValid)
                }
            }
            .onAppear {
                if let employee = employee {
                    name = employee.name
                    phone = employee.phone
                    email = employee.email
                    role = employee.role
                    isActive = employee.isActive
                }
            }
        }
    }

    private func saveMember() {
        if let employee = employee {
            let updated = Employee(
                id: employee.id,
                name: name,
                phone: phone,
                email: email,
                role: role,
                isActive: isActive
            )
            store.updateEmployee(updated)
        } else {
            let newEmployee = Employee(
                name: name,
                phone: phone,
                email: email,
                role: role,
                isActive: isActive
            )
            store.addEmployee(newEmployee)
        }
        isPresented = false
    }
}

private struct TeamMemberDetailView: View {
    @EnvironmentObject private var store: OwnerStore
    let employee: Employee
    @State private var isEditing = false

    var appointmentHistory: [Appointment] {
        store.appointmentsForEmployee(employee.id)
            .sorted { $0.startsAt > $1.startsAt }
    }

    var upcomingAppointments: [Appointment] {
        appointmentHistory.filter { $0.startsAt > Date() }
    }

    var pastAppointments: [Appointment] {
        appointmentHistory.filter { $0.startsAt <= Date() }
    }

    var completedAppointments: Int {
        store.appointmentsForEmployee(employee.id).filter { $0.status == .completed }.count
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Contact Information") {
                    LabeledContent("Name", value: employee.name)
                    if !employee.phone.isEmpty {
                        LabeledContent("Phone", value: employee.phone)
                    }
                    if !employee.email.isEmpty {
                        LabeledContent("Email", value: employee.email)
                    }
                }

                Section("Position") {
                    LabeledContent("Role", value: employee.role.rawValue)
                    LabeledContent("Status", value: employee.isActive ? "Active" : "Inactive")
                }

                Section("Performance") {
                    LabeledContent("Total Appointments", value: "\(appointmentHistory.count)")
                    LabeledContent("Completed", value: "\(completedAppointments)")
                    if appointmentHistory.count > 0 {
                        let percentage = (Double(completedAppointments) / Double(appointmentHistory.count) * 100)
                        LabeledContent("Completion Rate", value: String(format: "%.0f%%", percentage))
                    }
                }

                if !upcomingAppointments.isEmpty {
                    Section("Upcoming Assignments") {
                        ForEach(upcomingAppointments) { appointment in
                            NavigationLink {
                                AppointmentDetailView(appointment: appointment)
                            } label: {
                                appointmentRowForTeamMember(appointment)
                            }
                        }
                    }
                }

                if !pastAppointments.isEmpty {
                    Section("Assignment History") {
                        ForEach(pastAppointments.prefix(5)) { appointment in
                            appointmentRowForTeamMember(appointment)
                        }
                        if pastAppointments.count > 5 {
                            Text("\(pastAppointments.count - 5) more appointment\(pastAppointments.count - 5 == 1 ? "" : "s")")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section {
                    Button("Edit Team Member", systemImage: "pencil") {
                        isEditing = true
                    }
                    .tint(.blue)
                }
            }
            .navigationTitle(employee.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isEditing) {
            TeamMemberFormView(isPresented: $isEditing, employee: employee)
        }
    }

    private func appointmentRowForTeamMember(_ appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let client = store.client(for: appointment) {
                Text(client.name)
                    .font(.subheadline.weight(.semibold))
            }
            HStack(spacing: 12) {
                Text(appointment.startsAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(formatTime(appointment.startsAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                StatusBadgeSmall(status: appointment.status)
            }
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Settings View
private struct SettingsView: View {
    @State private var showingBusinessInfo = false
    @State private var businessName = "L&G Cleaning Services"
    @State private var businessPhone = "(555) 999-0000"
    @State private var businessEmail = "info@lgcleaning.com"
    @State private var businessAddress = "123 Main Street, Springfield, IL"
    @State private var notifyOnNewAppointments = true
    @State private var notifyOnCompletion = true
    @State private var notifyReminders = true

    var body: some View {
        NavigationStack {
            List {
                Section("Business Information") {
                    LabeledContent("Business Name", value: businessName)
                    LabeledContent("Phone", value: businessPhone)
                    LabeledContent("Email", value: businessEmail)
                    LabeledContent("Address", value: businessAddress)
                    Button("Edit Business Info", systemImage: "pencil") {
                        showingBusinessInfo = true
                    }
                    .tint(.blue)
                }

                Section("Notifications") {
                    Toggle("New Appointments", isOn: $notifyOnNewAppointments)
                    Toggle("Appointment Completion", isOn: $notifyOnCompletion)
                    Toggle("Appointment Reminders", isOn: $notifyReminders)
                }

                Section("Security") {
                    Label("Access codes are excluded from notifications", systemImage: "lock.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section("App Information") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Support") {
                    Link("Contact Support", destination: URL(string: "mailto:support@lgcleaning.com")!)
                    Link("Help & FAQ", destination: URL(string: "https://example.com/help")!)
                }

                Section("About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("L&G Cleaning Services Manager")
                            .font(.headline)
                        Text("Your complete solution for managing cleaning business appointments, clients, and team members.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $showingBusinessInfo) {
            BusinessInfoEditView(
                isPresented: $showingBusinessInfo,
                name: $businessName,
                phone: $businessPhone,
                email: $businessEmail,
                address: $businessAddress
            )
        }
    }
}

// MARK: - Business Info Edit View
private struct BusinessInfoEditView: View {
    @Binding var isPresented: Bool
    @Binding var name: String
    @Binding var phone: String
    @Binding var email: String
    @Binding var address: String
    @State private var tempName: String = ""
    @State private var tempPhone: String = ""
    @State private var tempEmail: String = ""
    @State private var tempAddress: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Business Details") {
                    TextField("Business Name", text: $tempName)
                    TextField("Phone", text: $tempPhone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $tempEmail)
                        .keyboardType(.emailAddress)
                    TextField("Address", text: $tempAddress)
                }
            }
            .navigationTitle("Edit Business Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        name = tempName
                        phone = tempPhone
                        email = tempEmail
                        address = tempAddress
                        isPresented = false
                    }
                }
            }
            .onAppear {
                tempName = name
                tempPhone = phone
                tempEmail = email
                tempAddress = address
            }
        }
    }
}

// MARK: - Appointment Detail View
private struct AppointmentDetailView: View {
    @EnvironmentObject private var store: OwnerStore
    let appointment: Appointment

    var client: Client? {
        store.client(for: appointment)
    }

    var employee: Employee? {
        store.employee(for: appointment)
    }

    var body: some View {
        List {
            Section("Client Information") {
                if let client = client {
                    LabeledContent("Name", value: client.name)
                    if !client.phone.isEmpty {
                        LabeledContent("Phone", value: client.phone)
                    }
                    if !client.address.isEmpty {
                        LabeledContent("Address", value: client.address)
                    }
                }
            }

            Section("Appointment Details") {
                LabeledContent("Service", value: appointment.serviceType.rawValue)
                LabeledContent("Date", value: appointment.startsAt.formatted(date: .abbreviated, time: .omitted))
                LabeledContent("Time", value: timeRange)
                LabeledContent("Duration", value: "\(appointment.durationMinutes) minutes")
                LabeledContent("Status", value: appointment.status.rawValue)
            }

            if let employee = employee {
                Section("Assignment") {
                    LabeledContent("Assigned To", value: employee.name)
                    LabeledContent("Role", value: employee.role.rawValue)
                }
            }
        }
        .navigationTitle("Appointment")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var timeRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let start = formatter.string(from: appointment.startsAt)
        let end = formatter.string(from: appointment.endsAt)
        return "\(start) - \(end)"
    }
}

// MARK: - Status Badge (Small)
private struct StatusBadgeSmall: View {
    let status: AppointmentStatus

    var backgroundColor: Color {
        switch status {
        case .scheduled:
            return .blue.opacity(0.1)
        case .started:
            return .orange.opacity(0.1)
        case .completed:
            return .green.opacity(0.1)
        case .cancelled:
            return .red.opacity(0.1)
        }
    }

    var foregroundColor: Color {
        switch status {
        case .scheduled:
            return .blue
        case .started:
            return .orange
        case .completed:
            return .green
        case .cancelled:
            return .red
        }
    }

    var body: some View {
        Text(status.rawValue)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}

#Preview {
    ContentView()
        .environmentObject(OwnerStore())
}
