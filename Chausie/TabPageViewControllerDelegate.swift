import CoreGraphics

/// The methods declared by the `TabPageViewControllerDelegate` protocol allow the adopting
/// delegate to respond to messages from the `UIScrollView` class in `TabPageViewController`.
/// The method of this protocol is optional.
public protocol TabPageViewControllerDelegate: class {
    /// Tells the delegate when the user scrolls the inner page view.
    ///
    /// - Parameters:
    ///     - tabPageViewController: A customizable container view controller that manages
    ///                              tab view and page view controller.
    ///     - ratio: The ratio of offset position to width of content.
    func tabPageViewController(_ tabPageViewController: TabPageViewController, didScrollAtRatio ratio: CGFloat)
}

public extension PageViewControllerDelegate {
    func tabPageViewController(_ tabPageViewController: TabPageViewController, didScrollAtRatio ratio: CGFloat) {}
}
