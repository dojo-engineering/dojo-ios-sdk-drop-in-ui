import Foundation

public enum Currency: Equatable {
    case eur
    case gbp
    case other(String)
    
    public var code: String {
        switch self {
        case .eur: return "EUR"
        case .gbp: return "GBP"
        case let .other(code): return code
        }
    }
    
    public init(value: String) {
        switch value {
        case Currency.eur.code:
            self = .eur
        case Currency.gbp.code:
            self = .gbp
        default:
            self = .other(value)
        }
    }

    func currencySymbol(locale: Locale = .current) -> String {
        let components: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: code
        ]
        let identifier = Locale.identifier(fromComponents: components)
        return Locale(identifier: identifier).currencySymbol ?? ""
    }
}
