import SwiftUI

// MARK: - Color System
struct DesignColors {
    // Helper to determine if dark mode should be used
    private static func isDarkMode() -> Bool {
        let isDarkOverride = UserDefaults.standard.bool(forKey: "isDarkModeOverride")
        return isDarkOverride
    }

    // Surface/Background
    static var surfaceBackground: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        } else {
            return Color(red: 0.953, green: 0.949, blue: 0.949)  // #F3F2F2
        }
    }

    // Surface/Elevated
    static var surfaceElevated: Color {
        if isDarkMode() {
            return Color(red: 0.176, green: 0.169, blue: 0.165)  // #2D2B2B
        } else {
            return Color(red: 0.973, green: 0.957, blue: 0.957)  // #F8F4F4
        }
    }

    // Surface/Thumb
    static var surfaceThumb: Color {
        if isDarkMode() {
            return Color(red: 0.267, green: 0.255, blue: 0.255)  // #444141
        } else {
            return Color(red: 0.918, green: 0.906, blue: 0.906)  // #EAE7E7
        }
    }

    // Text/Primary
    static var textPrimary: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.949, blue: 0.949)  // #F3F2F2
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        }
    }

    // Text/Secondary
    static var textSecondary: Color {
        if isDarkMode() {
            return Color(red: 0.608, green: 0.591, blue: 0.591)  // #9B9797
        } else {
            return Color(red: 0.490, green: 0.475, blue: 0.475)  // #7D7979
        }
    }

    // Rule/Hairline
    static var ruleHairline: Color {
        if isDarkMode() {
            return Color(red: 0.267, green: 0.255, blue: 0.255)  // #444141
        } else {
            return Color(red: 0.843, green: 0.827, blue: 0.827)  // #D7D3D3
        }
    }

    // Rule/Strong
    static var ruleStrong: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.949, blue: 0.949)  // #F3F2F2
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        }
    }

    // Adaptive backgrounds (legacy)
    static var background: Color {
        surfaceBackground
    }

    static var secondaryBackground: Color {
        surfaceElevated
    }

    static var tertiaryBackground: Color {
        surfaceThumb
    }

    // Adaptive text colors (legacy)
    static var primary: Color {
        textPrimary
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
            return Color(red: 0.729, green: 0.714, blue: 0.714)  // #BAB6B6
        } else {
            return Color(red: 0.376, green: 0.365, blue: 0.365)  // #605D5D
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
            return Color(red: 0.267, green: 0.255, blue: 0.255).opacity(0.6)  // #444141
        } else {
            return Color(red: 0.843, green: 0.827, blue: 0.827).opacity(0.8)  // #D7D3D3
        }
    }

    static var divider: Color {
        ruleHairline
    }

    // Semantic colors respecting isDarkModeOverride
    static var priceValue: Color {
        if isDarkMode() {
            return Color(red: 1.0, green: 0.337, blue: 0.235)  // #FF563C
        } else {
            return Color(red: 0.682, green: 0.094, blue: 0.0)  // #AE1800
        }
    }

    static var priceStruck: Color {
        if isDarkMode() {
            return Color(red: 0.608, green: 0.591, blue: 0.591)  // #9B9797
        } else {
            return Color(red: 0.490, green: 0.475, blue: 0.475)  // #7D7979
        }
    }

    static var iconRating: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.945, blue: 0.945)  // #F3F2F2
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        }
    }

    static var iconDefault: Color {
        if isDarkMode() {
            return Color(red: 0.729, green: 0.714, blue: 0.714)  // #BAB6B6
        } else {
            return Color(red: 0.376, green: 0.365, blue: 0.365)  // #605D5D
        }
    }

    static var tabBarBackground: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        } else {
            return Color(red: 0.953, green: 0.945, blue: 0.945)  // #F3F2F2
        }
    }

    static var tabBarLabel: Color {
        if isDarkMode() {
            return Color(red: 0.729, green: 0.714, blue: 0.714)  // #BAB6B6
        } else {
            return Color(red: 0.376, green: 0.365, blue: 0.365)  // #605D5D
        }
    }

    static var tabBarActiveFill: Color {
        if isDarkMode() {
            return Color(red: 1.0, green: 0.337, blue: 0.235)  // #FF563C
        } else {
            return Color(red: 0.929, green: 0.188, blue: 0.075)  // #EC3013
        }
    }

    static var tabBarActiveLabel: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        } else {
            return Color(red: 1.0, green: 1.0, blue: 1.0)  // #FFFFFF
        }
    }

    static var cashbackBackground: Color {
        if isDarkMode() {
            return Color(red: 0.486, green: 0.078, blue: 0.020)  // #7C1405
        } else {
            return Color(red: 1.0, green: 0.949, blue: 0.937)  // #FFF2EF
        }
    }

    static var cashbackLabel: Color {
        if isDarkMode() {
            return Color(red: 1.0, green: 0.769, blue: 0.722)  // #FFC4B8
        } else {
            return Color(red: 0.682, green: 0.094, blue: 0.0)  // #AE1800
        }
    }

    static var cashbackBorder: Color {
        if isDarkMode() {
            return Color(red: 0.682, green: 0.094, blue: 0.0)  // #AE1800
        } else {
            return Color(red: 1.0, green: 0.769, blue: 0.722)  // #FFC4B8
        }
    }

    // UI component colors
    static var navPillBackground: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        } else {
            return Color(red: 1.0, green: 1.0, blue: 1.0)  // #FFFFFF
        }
    }

    static var navPillBorder: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.945, blue: 0.945)  // #F3F2F2
        } else {
            return Color(red: 0.0, green: 0.0, blue: 0.0)  // #000000
        }
    }

    static var navPillInactiveText: Color {
        tabBarLabel
    }

    static var navPillActiveText: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        } else {
            return Color(red: 1.0, green: 1.0, blue: 1.0)  // #FFFFFF
        }
    }

    static var searchButtonBackground: Color {
        if isDarkMode() {
            return Color(red: 1.0, green: 0.337, blue: 0.235)  // #FF563C
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        }
    }

    static var searchButtonIcon: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)  // #201E1D
        } else {
            return Color(red: 1.0, green: 1.0, blue: 1.0)  // #FFFFFF
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
