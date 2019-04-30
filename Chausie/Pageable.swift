import UIKit

/// The methods declared by the `Pageable` protocol allow the adopting delegate to respond
/// to messages from the `PageViewController` class.
/// The methods of this protocol are all optional.
public protocol Pageable: class {
    /// Tells the delegate that the specified content of index is displayed in
    /// the page view controller.
    ///
    /// - Parameters:
    ///     - pageViewController: The page view object that is adding the content of index.
    ///     - index: The index of content that is displayed in the page view controller.
    func pageViewController(_ pageViewController: PageViewController, didAppearAt index: PageIndex)

    /// Tells the delegate that the specified content of index is disappeared from
    /// the page view controller.
    ///
    /// - Parameters:
    ///     - pageViewController: The page view object that is adding the content of index.
    ///     - index: The index of content that is disappeared from the page view controller.
    func pageViewController(_ pageViewController: PageViewController, didDisappearAt index: PageIndex)

    /// Tells the delegate that when the view controller is added.
    ///
    /// - Parameters:
    ///     - pageViewController: The page view object that is adding the content of index.
    ///     - safeAreaInsets: The insets that you use to determine the safe area for this view.
    func pageViewController(_ pageViewController: PageViewController, actualSafeAreaInsets safeAreaInsets: UIEdgeInsets)
}

public extension Pageable {
    func pageViewController(_ pageViewController: PageViewController, didAppearAt index: PageIndex) {}
    func pageViewController(_ pageViewController: PageViewController, didDisappearAt index: PageIndex) {}
    func pageViewController(_ pageViewController: PageViewController, actualSafeAreaInsets safeAreaInsets: UIEdgeInsets) {}
}
