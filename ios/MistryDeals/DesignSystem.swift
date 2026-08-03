import SwiftUI

// MARK: - Color System
struct DesignColors {
    // Primary backgrounds
    static let background = Color(red: 0.06, green: 0.06, blue: 0.14)
    static let secondaryBackground = Color(red: 0.09, green: 0.09, blue: 0.18)
    static let tertiaryBackground = Color(red: 0.12, green: 0.11, blue: 0.22)

    // Text colors
    static let primary = Color.white
    static let secondary = Color.white.opacity(0.7)
    static let tertiary = Color.white.opacity(0.5)
    static let tertiaryText = Color.white.opacity(0.5)

    // Accent colors
    static let accent = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let accentSecondary = Color(red: 0.95, green: 0.4, blue: 0.6)
    static let accentLight = Color(red: 0.3, green: 0.8, blue: 1.0)
    static let accentRed = Color(red: 0.9, green: 0.3, blue: 0.5)
    static let success = Color(red: 0.2, green: 0.9, blue: 0.6)
    static let warning = Color(red: 1.0, green: 0.7, blue: 0.2)

    // Borders and dividers
    static let border = Color.white.opacity(0.1)
    static let divider = Color.white.opacity(0.08)
}

// MARK: - Typography
struct DesignTypography {
    // Display
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .default)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .default)
    static let displaySmall = Font.system(size: 24, weight: .semibold, design: .default)

    // Headline
    static let headline1 = Font.system(size: 20, weight: .semibold, design: .default)
    static let headline2 = Font.system(size: 18, weight: .semibold, design: .default)
    static let headline3 = Font.system(size: 16, weight: .semibold, design: .default)

    // Price
    static let price = Font.system(size: 12, weight: .bold, design: .default)

    // Body
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)

    // Caption
    static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
}

// MARK: - Spacing
struct DesignSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

// MARK: - Corner Radius
struct DesignRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let full: CGFloat = 999
}
