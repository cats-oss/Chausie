import CoreGraphics

/// The layout of tab view.
public struct TabViewLayout {
    public let top: Position
    public let trailing: Position
    public let leading: Position
    public let height: CGFloat

    public init(
        top: Position,
        trailing: Position,
        leading: Position,
        height: CGFloat
        ) {
        self.top = top
        self.trailing = trailing
        self.leading = leading
        self.height = height
    }
}
