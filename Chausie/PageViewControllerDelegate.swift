import UIKit

/// The methods declared by the `PageViewControllerDelegate` protocol allow the adopting
/// delegate to respond to messages from the `UIScrollView` class in `PageViewController`.
/// The method of this protocol is optional.
public protocol PageViewControllerDelegate: class {
    /// Tells the delegate when the user scrolls the page view.
    ///
    /// - Parameters:
    ///     - pageViewController: The page view object in which the scrolling occurred.
    ///     - ratio: The ratio of offset position to width of content.
    func pageViewController(_ pageViewController: PageViewController, didScrollAtRatio ratio: CGFloat)
}

public extension PageViewControllerDelegate {
    func pageViewController(_ pageViewController: PageViewController, didScrollAtRatio ratio: CGFloat) {}
}
