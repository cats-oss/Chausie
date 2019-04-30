import CoreGraphics
import Foundation

enum URLBuilder {
    /// - SeeAlso: https://lorempixel.com/
    static func build(category: Category, width: CGFloat, height: CGFloat) -> URL {
        let string = "https://lorempixel.com"
            + "/\(Int(width))"
            + "/\(Int(height))/"
            + "\(category)/"
        return URL(string: string)!
    }
}
