import CoreGraphics

/// The position composed of `origin` and `distance`.
public struct Position {
    /// The origin position
    public enum Origin {
        case layoutMargin
        case safeArea
        case view
    }

    /// the origin of the position.
    public let origin: Origin

    /// The distance from the origin.
    public let distance: CGFloat

    public init(origin: Origin, distance: CGFloat) {
        self.origin = origin
        self.distance = distance
    }
}
