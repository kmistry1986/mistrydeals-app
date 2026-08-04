import SwiftUI

// MARK: - Color System
struct DesignColors {
    // Helper to determine if dark mode should be used
    private static func isDarkMode() -> Bool {
        let isDarkOverride = UserDefaults.standard.bool(forKey: "isDarkModeOverride")
        return isDarkOverride
    }

    // Adaptive backgrounds
    static var background: Color {
        if isDarkMode() {
            return Color(red: 0.059, green: 0.059, blue: 0.059)  // #0F0F0F
        } else {
            return Color(red: 1.0, green: 1.0, blue: 1.0)  // #FFFFFF
        }
    }

    static var secondaryBackground: Color {
        if isDarkMode() {
            return Color(red: 0.102, green: 0.102, blue: 0.102)  // #1A1A1A
        } else {
            return Color(red: 0.973, green: 0.969, blue: 0.965)  // #F8F7F6
        }
    }

    static var tertiaryBackground: Color {
        if isDarkMode() {
            return Color(red: 0.165, green: 0.165, blue: 0.165)  // #2A2A2A
        } else {
            return Color(red: 0.898, green: 0.888, blue: 0.882)  // #E5E3E1
        }
    }

    // Adaptive text colors
    static var primary: Color {
        if isDarkMode() {
            return Color(red: 0.961, green: 0.953, blue: 0.945)  // #F5F3F1
        } else {
            return Color(red: 0.102, green: 0.102, blue: 0.102)  // #1A1A1A
        }
    }

    static var secondary: Color {
        if isDarkMode() {
            return Color(red: 0.961, green: 0.953, blue: 0.945).opacity(0.7)  // #F5F3F1
        } else {
            return Color(red: 0.102, green: 0.102, blue: 0.102).opacity(0.7)  // #1A1A1A
        }
    }

    static var tertiary: Color {
        if isDarkMode() {
            return Color(red: 0.961, green: 0.953, blue: 0.945).opacity(0.5)  // #F5F3F1
        } else {
            return Color(red: 0.102, green: 0.102, blue: 0.102).opacity(0.5)  // #1A1A1A
        }
    }

    static var tertiaryText: Color {
        tertiary
    }

    // Accent colors (deals/CTAs)
    static var accent: Color {
        if isDarkMode() {
            return Color(red: 1.0, green: 0.478, blue: 0.420)  // #FF7A6B
        } else {
            return Color(red: 0.847, green: 0.298, blue: 0.235)  // #D84B3C
        }
    }

    static let accentSecondary = Color(red: 0.95, green: 0.4, blue: 0.6)
    static let accentLight = Color(red: 0.3, green: 0.8, blue: 1.0)
    static let accentRed = Color(red: 0.9, green: 0.3, blue: 0.5)

    // Success/Good deal colors
    static var success: Color {
        if isDarkMode() {
            return Color(red: 0.365, green: 0.851, blue: 0.718)  // #5DD9B7
        } else {
            return Color(red: 0.176, green: 0.416, blue: 0.310)  // #2D6A4F
        }
    }

    static let warning = Color(red: 1.0, green: 0.7, blue: 0.2)

    // Borders and dividers
    static var border: Color {
        if isDarkMode() {
            return Color(red: 0.165, green: 0.165, blue: 0.165).opacity(0.6)  // #2A2A2A
        } else {
            return Color(red: 0.898, green: 0.888, blue: 0.882).opacity(0.8)  // #E5E3E1
        }
    }

    static var divider: Color {
        if isDarkMode() {
            return Color(red: 0.165, green: 0.165, blue: 0.165).opacity(0.4)  // #2A2A2A
        } else {
            return Color(red: 0.898, green: 0.888, blue: 0.882).opacity(0.5)  // #E5E3E1
        }
    }
}

// MARK: - Color Extension for Asset Catalog Colors
extension Color {
    // Surface Colors
    static let surfaceBackground = Color("SurfaceBackground")
    static let surfaceElevated = Color("SurfaceElevated")
    static let surfaceThumb = Color("SurfaceThumb")

    // Text Colors
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")

    // Rule Colors
    static let ruleHairline = Color("RuleHairline")
    static let ruleStrong = Color("RuleStrong")

    // Price Colors
    static let priceValue = Color("PriceValue")
    static let priceStruck = Color("PriceStruck")

    // Badge Colors
    static let badgeBackground = Color("BadgeBackground")
    static let badgeLabel = Color("BadgeLabel")

    // Cashback Colors
    static let cashbackBackground = Color("CashbackBackground")
    static let cashbackLabel = Color("CashbackLabel")
    static let cashbackBorder = Color("CashbackBorder")

    // Icon Colors
    static let iconRating = Color("IconRating")
    static let iconDefault = Color("IconDefault")

    // TabBar Colors
    static let tabBarBackground = Color("TabBarBackground")
    static let tabBarLabel = Color("TabBarLabel")
    static let tabBarActiveFill = Color("TabBarActiveFill")
    static let tabBarActiveLabel = Color("TabBarActiveLabel")

    // Action Colors
    static let actionSearchFill = Color("ActionSearchFill")
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
