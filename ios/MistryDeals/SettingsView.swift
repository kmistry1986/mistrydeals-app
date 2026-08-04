import SwiftUI

// Custom toggle style with colored knob
struct ColoredToggleStyle: ToggleStyle {
    @AppStorage("isDarkModeOverride") private var isDarkModeOverride = false

    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ?
                    (isDarkModeOverride ? Color(red: 1.0, green: 0.337, blue: 0.235) : Color(red: 0.929, green: 0.188, blue: 0.075)) :
                    Color.gray.opacity(0.3))
                .frame(width: 50, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isDarkModeOverride ? Color.white.opacity(0.3) : Color.black.opacity(0.2), lineWidth: 1)
                        .frame(width: 50, height: 30)
                )
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? Color(red: 0.929, green: 0.188, blue: 0.075) : Color.white)
                        .frame(width: 26, height: 26)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
        }
        .buttonStyle(.plain)
    }
}

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkModeOverride") private var isDarkModeOverride: Bool = true
    @State private var showFeedbackForm = false
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkModeOverride") private var isDarkModeOverrideWatch = false

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                Text("Settings")
                    .font(DesignTypography.headline1)
                    .foregroundColor(DesignColors.textPrimary)

                Spacer()

                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DesignColors.iconDefault)
                }
            }
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.top, DesignSpacing.lg)
            .padding(.bottom, DesignSpacing.lg)
            .frame(maxWidth: .infinity)
            .background(DesignColors.surfaceBackground)
            .borderBottom(DesignColors.ruleStrong, width: 2)
            .padding(.top, 48)

            ScrollView {
                VStack(spacing: 0) {
                    // Dark Mode Section
                    VStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Dark Mode")
                                        .font(DesignTypography.headline3)
                                        .foregroundColor(DesignColors.textPrimary)

                                    Text("Adjust display theme")
                                        .font(DesignTypography.caption1)
                                        .foregroundColor(DesignColors.textSecondary)
                                }

                                Spacer()

                                Toggle("", isOn: $isDarkModeOverride)
                                    .toggleStyle(ColoredToggleStyle())
                            }
                        .padding(.horizontal, DesignSpacing.lg)
                        .padding(.vertical, DesignSpacing.lg)
                        .frame(maxWidth: .infinity)
                        .background(DesignColors.surfaceBackground)
                        .borderBottom(DesignColors.ruleHairline)
                    }

                    // Share Feedback Section
                    VStack(spacing: 0) {
                        Button(action: { showFeedbackForm = true }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Share Feedback")
                                        .font(DesignTypography.headline3)
                                        .foregroundColor(DesignColors.textPrimary)

                                    Text("Send us your feedback")
                                        .font(DesignTypography.caption1)
                                        .foregroundColor(DesignColors.iconDefault)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(DesignColors.iconDefault)
                            }
                            .padding(.horizontal, DesignSpacing.lg)
                            .padding(.vertical, DesignSpacing.lg)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(DesignColors.surfaceBackground)
                        .borderBottom(DesignColors.ruleHairline)
                    }

                    // App Version Section
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Version")
                                    .font(DesignTypography.headline3)
                                    .foregroundColor(DesignColors.textPrimary)
                            }

                            Spacer()

                            Text("v\(appVersion)")
                                .font(DesignTypography.caption1)
                                .foregroundColor(DesignColors.iconDefault)
                        }
                        .padding(.horizontal, DesignSpacing.lg)
                        .padding(.vertical, DesignSpacing.lg)
                        .frame(maxWidth: .infinity)
                        .background(DesignColors.surfaceBackground)
                        .borderBottom(DesignColors.ruleHairline)
                    }

                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignColors.surfaceBackground)
        .ignoresSafeArea()
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showFeedbackForm) {
            FeedbackFormView(isPresented: $showFeedbackForm)
        }
    }
}

struct FeedbackFormView: View {
    @Binding var isPresented: Bool
    @State private var feedbackText = ""
    @State private var email = ""
    @State private var isLoading = false
    @State private var showSuccessMessage = false

    var body: some View {
        ZStack {
            DesignColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Send Feedback")
                        .font(DesignTypography.headline1)
                        .foregroundColor(DesignColors.textPrimary)

                    Spacer()

                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color("AccentColor"))
                    }
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.vertical, DesignSpacing.lg)
                .frame(maxWidth: .infinity)
                .background(DesignColors.surfaceBackground)
                .borderBottom(DesignColors.ruleHairline)

                ScrollView {
                    VStack(spacing: DesignSpacing.lg) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(DesignTypography.caption1)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignColors.textPrimary)

                            TextField("your@email.com", text: $email)
                                .textFieldStyle(.plain)
                                .foregroundColor(DesignColors.textPrimary)
                                .padding(DesignSpacing.md)
                                .background(DesignColors.surfaceThumb)
                                .cornerRadius(DesignRadius.sm)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Feedback")
                                .font(DesignTypography.caption1)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignColors.textPrimary)

                            TextEditor(text: $feedbackText)
                                .textFieldStyle(.plain)
                                .foregroundColor(DesignColors.textPrimary)
                                .padding(DesignSpacing.md)
                                .background(DesignColors.surfaceThumb)
                                .cornerRadius(DesignRadius.sm)
                                .frame(height: 150)
                        }

                        if showSuccessMessage {
                            Text("Thank you for your feedback!")
                                .font(DesignTypography.bodySmall)
                                .foregroundColor(Color("AccentColor"))
                                .frame(maxWidth: .infinity)
                                .padding(DesignSpacing.md)
                                .background(Color("AccentColor").opacity(0.2))
                                .cornerRadius(DesignRadius.sm)
                        }

                        Button(action: submitFeedback) {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Submit")
                                    .font(DesignTypography.headline3)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignSpacing.md)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color("AccentColor"),
                                    Color("AccentColor").opacity(0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(DesignRadius.md)
                        .disabled(email.isEmpty || feedbackText.isEmpty || isLoading)

                        Spacer()
                    }
                    .padding(DesignSpacing.lg)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func submitFeedback() {
        isLoading = true
        // Simulate submission - in production would hit Supabase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            showSuccessMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isPresented = false
            }
        }
    }
}

#Preview {
    SettingsView()
}
