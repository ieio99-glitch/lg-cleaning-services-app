import SwiftUI
import GoogleSignIn
import UIKit

struct GoogleCalendarView: View {
    @State private var isConnected = false
    @State private var statusMessage = "Connect your L&G Cleaning Google Calendar."
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "calendar")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)
                
                Text("L&G Cleaning Calendar")
                    .font(.title2.bold())
                
                Text(statusMessage)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                Button {
                    connectGoogleCalendar()
                } label: {
                    Label(
                        isConnected ? "Google Calendar Connected" : "Connect Google Calendar",
                        systemImage: isConnected
                        ? "checkmark.circle.fill"
                        : "person.crop.circle.badge.plus"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isConnected)
                .padding(.horizontal)
            }
            .navigationTitle("Calendar")
        }
    }
    
    private func connectGoogleCalendar() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController
        else {
            statusMessage = "Could not open Google sign-in. Please try again."
            return
        }
        
        let calendarScope = "https://www.googleapis.com/auth/calendar.events.owned"
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController,
            hint: nil,
            additionalScopes: [calendarScope]
        ) { result, error in
            if let error {
                statusMessage = "Google sign-in failed: \(error.localizedDescription)"
                return
            }
            
            if result != nil {
                isConnected = true
                statusMessage = "Your L&G Cleaning Google Calendar is connected."
            }
        }
    }
    
}
