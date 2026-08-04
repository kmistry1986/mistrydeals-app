import SwiftUI

// MARK: - Color System (Ink & Signal)
struct DesignColors {
    // Helper to determine if dark mode should be used
    static func isDarkMode() -> Bool {
        let isDarkOverride = UserDefaults.standard.bool(forKey: "isDarkModeOverride")
        return isDarkOverride
    }

    // MARK: - Surface Colors
    // Surface/Background - Light: #F3F2F2, Dark: #201E1D
    static var surfaceBackground: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        } else {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        }
    }

    // Surface/Elevated - Light: #F8F4F4, Dark: #2D2B2B
    static var surfaceElevated: Color {
        if isDarkMode() {
            return Color(red: 0.176, green: 0.169, blue: 0.165)
        } else {
            return Color(red: 0.973, green: 0.957, blue: 0.957)
        }
    }

    // Surface/Thumb - Light: #EAE7E7, Dark: #444141
    static var surfaceThumb: Color {
        if isDarkMode() {
            return Color(red: 0.267, green: 0.255, blue: 0.255)
        } else {
            return Color(red: 0.918, green: 0.906, blue: 0.906)
        }
    }

    // MARK: - Text Colors
    // Text/Primary - Light: #201E1D, Dark: #F3F2F2
    static var textPrimary: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        }
    }

    // Text/Secondary - Light: #7D7979, Dark: #9B9797
    static var textSecondary: Color {
        if isDarkMode() {
            return Color(red: 0.608, green: 0.591, blue: 0.591)
        } else {
            return Color(red: 0.490, green: 0.475, blue: 0.475)
        }
    }

    // MARK: - Rule/Border Colors
    // Rule/Hairline - Light: #D7D3D3, Dark: #444141
    static var ruleHairline: Color {
        if isDarkMode() {
            return Color(red: 0.267, green: 0.255, blue: 0.255)
        } else {
            return Color(red: 0.843, green: 0.827, blue: 0.827)
        }
    }

    // Rule/Strong - Light: #201E1D, Dark: #F3F2F2
    static var ruleStrong: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        }
    }

    // MARK: - Price Colors
    // Price/Value - Light: #AE1800, Dark: #FF563C
    static var priceValue: Color {
        if isDarkMode() {
            return Color(red: 1.0, green: 0.337, blue: 0.235)
        } else {
            return Color(red: 0.682, green: 0.094, blue: 0.0)
        }
    }

    // Price/Struck - Light: #7D7979, Dark: #9B9797
    static var priceStruck: Color {
        if isDarkMode() {
            return Color(red: 0.608, green: 0.591, blue: 0.591)
        } else {
            return Color(red: 0.490, green: 0.475, blue: 0.475)
        }
    }

    // MARK: - Badge Colors (Discount)
    // Badge/Background - Light: #201E1D, Dark: #F3F2F2
    static var badgeBackground: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        }
    }

    // Badge/Label - Light: #F3F2F2, Dark: #201E1D
    static var badgeLabel: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        } else {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        }
    }

    // MARK: - Cashback Colors
    // Cashback/Background - Light: #FFF2EF, Dark: #7C1405
    static var cashbackBackground: Color {
        if isDarkMode() {
            return Color(red: 0.486, green: 0.078, blue: 0.020)
        } else {
            return Color(red: 1.0, green: 0.949, blue: 0.937)
        }
    }

    // Cashback/Label - Light: #AE1800, Dark: #FFC4B8
    static var cashbackLabel: Color {
        if isDarkMode() {
            return Color(red: 1.0, green: 0.769, blue: 0.722)
        } else {
            return Color(red: 0.682, green: 0.094, blue: 0.0)
        }
    }

    // Cashback/Border - Light: #FFC4B8, Dark: #AE1800
    static var cashbackBorder: Color {
        if isDarkMode() {
            return Color(red: 0.682, green: 0.094, blue: 0.0)
        } else {
            return Color(red: 1.0, green: 0.769, blue: 0.722)
        }
    }

    // MARK: - Icon Colors
    // Icon/Rating - Light: #201E1D, Dark: #F3F2F2
    static var iconRating: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        }
    }

    // Icon/Default - Light: #605D5D, Dark: #BAB6B6
    static var iconDefault: Color {
        if isDarkMode() {
            return Color(red: 0.729, green: 0.714, blue: 0.714)
        } else {
            return Color(red: 0.376, green: 0.365, blue: 0.365)
        }
    }

    // MARK: - TabBar Colors
    // TabBar/Background - Light: #F3F2F2, Dark: #201E1D
    static var tabBarBackground: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        } else {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        }
    }

    // TabBar/Label - Light: #605D5D, Dark: #BAB6B6
    static var tabBarLabel: Color {
        if isDarkMode() {
            return Color(red: 0.729, green: 0.714, blue: 0.714)
        } else {
            return Color(red: 0.376, green: 0.365, blue: 0.365)
        }
    }

    // TabBar/ActiveFill - Light: #EC3013, Dark: #FF563C
    static var tabBarActiveFill: Color {
        if isDarkMode() {
            return Color(red: 1.0, green: 0.337, blue: 0.235)
        } else {
            return Color(red: 0.929, green: 0.188, blue: 0.075)
        }
    }

    // TabBar/ActiveLabel - Light: #FFFFFF, Dark: #201E1D
    static var tabBarActiveLabel: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        } else {
            return Color(red: 1.0, green: 1.0, blue: 1.0)
        }
    }

    // MARK: - Action Colors
    // Action/SearchFill - Light: #201E1D, Dark: #F3F2F2
    static var actionSearchFill: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        }
    }

    // MARK: - Input/Form Colors
    // Input background - Light: #F8F4F4, Dark: #2D2B2B
    static var inputBackground: Color {
        if isDarkMode() {
            return Color(red: 0.176, green: 0.169, blue: 0.165)
        } else {
            return Color(red: 0.973, green: 0.957, blue: 0.957)
        }
    }

    // Input border - Light: #201E1D, Dark: #F3F2F2
    static var inputBorder: Color {
        ruleStrong
    }

    // MARK: - Group Headers & Dividers
    // Group header text - Light: #7D7979, Dark: #9B9797
    static var groupHeader: Color {
        if isDarkMode() {
            return Color(red: 0.608, green: 0.591, blue: 0.591)
        } else {
            return Color(red: 0.490, green: 0.475, blue: 0.475)
        }
    }

    // Group divider - Light: #201E1D (2px), Dark: #F3F2F2 (2px)
    static var groupDivider: Color {
        ruleStrong
    }

    // MARK: - Search/Filter Colors
    // Search input placeholder - Light: #7D7979, Dark: #9B9797
    static var placeholder: Color {
        textSecondary
    }

    // Search filter pill inactive - Light: #F3F2F2, Dark: #201E1D
    static var filterInactiveBackground: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        } else {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        }
    }

    // Search filter pill active - Light: #201E1D, Dark: #F3F2F2
    static var filterActiveBackground: Color {
        if isDarkMode() {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        } else {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        }
    }

    // Search filter text active - Light: #F3F2F2, Dark: #201E1D
    static var filterActiveLabel: Color {
        if isDarkMode() {
            return Color(red: 0.125, green: 0.118, blue: 0.114)
        } else {
            return Color(red: 0.953, green: 0.949, blue: 0.949)
        }
    }

    // Search close action - Light: #AE1800, Dark: #FF563C
    static var actionClose: Color {
        priceValue
    }

    // MARK: - Legacy Aliases (for compatibility)
    static var background: Color { surfaceBackground }
    static var secondaryBackground: Color { surfaceElevated }
    static var tertiaryBackground: Color { surfaceThumb }
    static var primary: Color { textPrimary }
    static var secondary: Color { textSecondary }
    static var tertiary: Color { iconDefault }
    static var tertiaryText: Color { iconDefault }
    static var divider: Color { ruleHairline }
    static var border: Color { ruleHairline }

    static let accent = Color(red: 0.929, green: 0.188, blue: 0.075)
    static let accentSecondary = Color(red: 0.95, green: 0.4, blue: 0.6)
    static let accentLight = Color(red: 0.3, green: 0.8, blue: 1.0)
    static let accentRed = Color(red: 0.9, green: 0.3, blue: 0.5)

    static var success: Color {
        if isDarkMode() {
            return Color(red: 0.365, green: 0.851, blue: 0.718)
        } else {
            return Color(red: 0.176, green: 0.416, blue: 0.310)
        }
    }

    static let warning = Color(red: 1.0, green: 0.7, blue: 0.2)
}

// MARK: - Typography
struct DesignTypography {
    static let displayLarge = Font.system(size: 32, weight: .bold, design: .default)
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .default)
    static let displaySmall = Font.system(size: 24, weight: .semibold, design: .default)

    static let headline1 = Font.system(size: 20, weight: .semibold, design: .default)
    static let headline2 = Font.system(size: 18, weight: .semibold, design: .default)
    static let headline3 = Font.system(size: 16, weight: .semibold, design: .default)

    static let price = Font.system(size: 12, weight: .bold, design: .default)

    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)

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
