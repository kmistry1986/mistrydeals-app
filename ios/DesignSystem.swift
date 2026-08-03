import SwiftUI

struct DesignSystem {
    struct Colors {
        // MARK: - Light Mode
        static let lightMode = LightModeColors()

        // MARK: - Dark Mode
        static let darkMode = DarkModeColors()
    }
}

struct LightModeColors {
    // MARK: Surfaces & Backgrounds
    let background = Color(red: 1.0, green: 1.0, blue: 1.0)              // #FFFFFF
    let surface = Color(red: 0.973, green: 0.969, blue: 0.965)           // #F8F7F6
    let cardBackground = Color(red: 0.973, green: 0.969, blue: 0.965)    // #F8F7F6

    // MARK: Accents & CTAs
    let accent = Color(red: 0.847, green: 0.298, blue: 0.235)            // #D84B3C (Coral)
    let accentHover = Color(red: 0.722, green: 0.227, blue: 0.180)       // #B83A2E

    // MARK: Status & Semantic
    let success = Color(red: 0.176, green: 0.416, blue: 0.310)           // #2D6A4F (Forest Green)
    let successHover = Color(red: 0.122, green: 0.298, blue: 0.208)      // #1F4C35

    // MARK: Text Hierarchy
    let text = TextColorsPalette(
        primary: Color(red: 0.102, green: 0.102, blue: 0.102),           // #1A1A1A
        secondary: Color(red: 0.400, green: 0.400, blue: 0.400),         // #666666
        muted: Color(red: 0.600, green: 0.600, blue: 0.600)              // #999999
    )

    // MARK: Borders & Dividers
    let border = Color(red: 0.898, green: 0.888, blue: 0.882)            // #E5E3E1
    let borderStrong = Color(red: 0.831, green: 0.820, blue: 0.812)      // #D3D1CF
}

struct DarkModeColors {
    // MARK: Surfaces & Backgrounds
    let background = Color(red: 0.059, green: 0.059, blue: 0.059)        // #0F0F0F
    let surface = Color(red: 0.102, green: 0.102, blue: 0.102)           // #1A1A1A
    let cardBackground = Color(red: 0.102, green: 0.102, blue: 0.102)    // #1A1A1A

    // MARK: Accents & CTAs
    let accent = Color(red: 1.0, green: 0.478, blue: 0.420)              // #FF7A6B (Light Coral)
    let accentHover = Color(red: 0.902, green: 0.365, blue: 0.318)       // #E65D51

    // MARK: Status & Semantic
    let success = Color(red: 0.365, green: 0.851, blue: 0.718)           // #5DD9B7 (Mint)
    let successHover = Color(red: 0.271, green: 0.772, blue: 0.612)      // #45C49C

    // MARK: Text Hierarchy
    let text = TextColorsPalette(
        primary: Color(red: 0.961, green: 0.953, blue: 0.945),           // #F5F3F1
        secondary: Color(red: 0.722, green: 0.714, blue: 0.698),         // #B8B6B2
        muted: Color(red: 0.478, green: 0.471, blue: 0.459)              // #7A7875
    )

    // MARK: Borders & Dividers
    let border = Color(red: 0.165, green: 0.165, blue: 0.165)            // #2A2A2A
    let borderStrong = Color(red: 0.227, green: 0.227, blue: 0.227)      // #3A3A3A
}

struct TextColorsPalette {
    let primary: Color
    let secondary: Color
    let muted: Color
}

// MARK: - Environment Helper
struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: ColorScheme = .dark
}

extension EnvironmentValues {
    var appTheme: ColorScheme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Typography (Keep existing)
struct DesignTypography {
    // Display
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .default)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .default)
    static let displaySmall = Font.system(size: 24, weight: .semibold, design: .default)

    // Headline
    static let headline1 = Font.system(size: 20, weight: .semibold, design: .default)
    static let headline2 = Font.system(size: 18, weight: .semibold, design: .default)
    static let headline3 = Font.system(size: 16, weight: .semibold, design: .default)

    // Body
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)

    // Caption
    static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Spacing (Keep existing)
struct DesignSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

// MARK: - Corner Radius (Keep existing)
struct DesignRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let full: CGFloat = 999
}
