import CoreGraphics

/// A protocol that a class must adopt allow customization for a item within the tab
/// view’s visible bounds.
public protocol TabItemCell: class {
    /// A type to customize self.
    associatedtype Model

    /// A factory method that make a customized item within tab view by using model.
    static func make(model: Model) -> Self

    /// This method is called when highlight state changes.
    /// This method is optional.
    ///
    /// - Parameters:
    ///     - ratio: The ratio of scroll view's offset position in the range 0.0 to 1.0.
    func updateHighlightRatio(_ ratio: CGFloat)
}

public extension TabItemCell {
    func updateHighlightRatio(_ ratio: CGFloat) {}
}
