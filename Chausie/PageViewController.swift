import UIKit

/// A type that represents index of content.
public typealias PageIndex = Int

/// A customizable container view controller that manages navigation between pages of content.
public final class PageViewController: UIViewController {
    /// A type that represents a child view controller.
    public typealias Child = UIViewController & Pageable

    /// The delegate object. methods of the delegate are called in response to scroll changes.
    public weak var delegate: PageViewControllerDelegate?

    /// The ratio of offset position to width of content in horizontal direction.
    public var scrollRatio: CGFloat {
        return scrollView.contentOffset.x / scrollView.contentSize.width
    }

    /// The underlying gesture recognizer for pan gestures of inner scrollview.
    /// Access this property when you want to more precisely control which pan gestures are
    /// recognized by the inner scroll view.
    public var panGestureRecognizer: UIPanGestureRecognizer {
        return scrollView.panGestureRecognizer
    }

    /// The visible view controllers
    public var visibleViewControllers: [Child] {
        return Set([visibleIndices.backword, visibleIndices.forward]).map { viewControllers[$0] }
    }

    /// The view controllers displayed by the page view controller.
    public let viewControllers: ContiguousArray<Child>

    /// A index set of child view controller added to the container.
    private struct ChildrenIndices {
        var forward: PageIndex
        var backward: PageIndex
    }

    /// A index set of child view controller displayed in the scrollView.
    private struct VisibleIndices {
        var forward: PageIndex
        var backword: PageIndex

        static func make(initialPageIndex: PageIndex) -> VisibleIndices {
            return VisibleIndices(forward: initialPageIndex, backword: initialPageIndex)
        }
    }

    private let scrollView = PageScrollView()

    /// A minimum index of content.
    private let minPageIndex: PageIndex = 0

    /// A maximum count of child view controller to add to the container.
    private let maxChildrenCount: Int

    /// The distance of index of child view controller added in the forward direction.
    private let forwardDistance: Int

    /// The distance of index of child view controller added in the backward direction.
    private let backwardDistance: Int

    /// A Boolean value indicating whether the size for the container’s view is changing.
    private var isTransitioning = false

    /// A maximum index of content.
    private var maxPageIndex: PageIndex {
        return viewControllers.count - 1
    }

    /// Indices of child view controller added to the container.
    private var childrenIndices: ChildrenIndices

    /// Indices of child view controller displayed in the scrollView.
    private var visibleIndices: VisibleIndices

    /// - Parameters:
    ///     - viewControllers: The view controllers displayed by the page view controller.
    ///     - maxChildrenCount: A maximum count of child view controller to add to the container.
    ///                         child view controllers added to the container is always changed
    ///                         by the scroll position. the default value is 1.
    ///     - initialPageIndex: A index of content to be displayed when the view controller
    ///                         loads the view hierarchy into memory. the default value is 0.
    public required init<S: Sequence>(
        viewControllers: S,
        maxChildrenCount: Int = 1,
        initialPageIndex: PageIndex = 0
        ) where S.Element == Child {
        self.viewControllers = ContiguousArray(viewControllers)
        self.maxChildrenCount = min(maxChildrenCount, self.viewControllers.count)

        forwardDistance = Int(ceil(CGFloat(self.maxChildrenCount  / 2)))
        backwardDistance = self.maxChildrenCount.isEven
            ? Int(CGFloat(self.maxChildrenCount) / 2 - 1)
            : Int(floor(CGFloat(self.maxChildrenCount / 2)))

        let forward = (initialPageIndex - forwardDistance).isNegated
            ? (initialPageIndex + maxChildrenCount).next(to: .backward)
            : min(initialPageIndex + forwardDistance, self.viewControllers.count - 1)
        let backword = initialPageIndex + self.maxChildrenCount > self.viewControllers.count - 1
            ? self.viewControllers.count - maxChildrenCount
            : PageIndex(max(minPageIndex, initialPageIndex - backwardDistance))

        childrenIndices = ChildrenIndices(forward: forward, backward: backword)
        visibleIndices = VisibleIndices.make(initialPageIndex: min(initialPageIndex, self.viewControllers.count - 1))

        super.init(nibName: nil, bundle: nil)

        precondition(
            0...self.viewControllers.count ~= maxChildrenCount,
            """
            Invalid value: `maxChildrenCount` (\(maxChildrenCount)) out of range.
            Check `viewControllers.count` (\(self.viewControllers.count)) or `maxChildrenCount` (\(maxChildrenCount)).
            """
        )

        precondition(
            0...self.viewControllers.count - 1 ~= initialPageIndex,
            """
            Invalid value: `initialPageIndex (\(initialPageIndex))` out of range.
            Check `viewControllers.count` (\(self.viewControllers.count)) or `initialIndex` (\(initialPageIndex)).
            """
        )
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1),
            view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        scrollView.layoutIfNeeded()

        let initialPageIndex = visibleIndices.forward
        scrollView.delegate = self
        scrollView.contentSize.width = scrollView.bounds.width * CGFloat(viewControllers.count)
        scrollView.contentOffset.x = scrollView.bounds.width * CGFloat(initialPageIndex)
        delegate?.pageViewController(self, didScrollAtRatio: scrollRatio)

        let initailIndices: CountableClosedRange<PageIndex> = {
            let lowerBound = initialPageIndex + forwardDistance > maxPageIndex
                ? viewControllers.count - maxChildrenCount
                : initialPageIndex - backwardDistance
            let upperBound = lowerBound - backwardDistance < minPageIndex
                ? maxChildrenCount - 1
                : initialPageIndex + forwardDistance
            return max(minPageIndex, lowerBound)...min(maxPageIndex, upperBound)
        }()

        viewControllers
            .lazy
            .enumerated()
            .filter { initailIndices.contains($0.0) }
            .prefix(maxChildrenCount)
            .forEach { offset, viewController in
                viewController.view.frame = CGRect(
                    origin: CGPoint(x: CGFloat(offset) * scrollView.bounds.width, y: 0),
                    size: scrollView.bounds.size
                )
                notifySafeAreaInsets(viewController)
                addChildToScrollView(viewController)
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        (visibleIndices.backword...visibleIndices.forward).forEach { index in
            viewControllers[index].pageViewController(self, didAppearAt: index)
        }
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        (visibleIndices.backword...visibleIndices.forward).forEach { index in
            viewControllers[index].pageViewController(self, didDisappearAt: index)
        }
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard scrollView.bounds.width > 0 else { return }

        isTransitioning = true

        let currentScrollRatio: CGFloat = {
            let offsetX = min(scrollView.contentOffset.x, scrollView.bounds.width * CGFloat(viewControllers.count))
            let ratio = Int(offsetX / scrollView.bounds.width)
            return max(0, CGFloat(ratio))
        }()

        coordinator.animate(alongsideTransition: { _ in
            let contentWidth = size.width

            if self.scrollView.contentSize.width != contentWidth * CGFloat(self.viewControllers.count) {
                self.scrollView.contentSize.width = contentWidth * CGFloat(self.viewControllers.count)

                // - Workaround: The offset position shift if use `scrollView.contentOffset.x = x`
                //               instead of `setContentOffset(_:animated:)`.
                self.scrollView.setContentOffset(CGPoint(x: contentWidth * CGFloat(currentScrollRatio), y: 0), animated: false)
            }

            self.viewControllers
                .enumerated()
                .forEach { offset, viewController in

                    self.notifySafeAreaInsets(viewController)

                    if self.scrollView.subviews.contains(where: { $0 == viewController.view }) {
                        viewController.view.frame.origin.x = contentWidth * CGFloat(offset)
                    }
                    else {

                        // only child view controller added to the container updates the frame.
                        viewController.view.frame.size = self.scrollView.bounds.size
                    }
            }
        }, completion: { _ in
            self.isTransitioning = false
        })
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !isTransitioning && !scrollView.isInteracting {
            scrollView.contentOffset.x = scrollView.bounds.width * CGFloat(visibleIndices.forward)
        }
    }

    /// Scrolls the page view contents until the specified index of content is visible.
    ///
    /// - Parameters:
    ///     - index: A index of content to scroll into view.
    ///     - animated: Specify true to animate the scrolling behavior or false to adjust
    ///                 the scroll view’s visible content immediately.
    public func scrollToPage(at index: PageIndex, animated: Bool) {
        precondition(index <= maxPageIndex, "`index` out of range. Please set `index` within the range of `viewControllers`")

        let contentOffset = CGPoint(x: scrollView.bounds.width * CGFloat(index), y: 0)
        scrollView.setContentOffset(contentOffset, animated: animated)

        if !animated {
            _scrollViewDidScroll(scrollView)
        }
    }

    /// Adds the specified view controller as a child of the current view controller
    /// and a view of child view controller to scrollView. The specified view controller's view
    /// is added to the scrollView.
    private func addChildToScrollView(_ childController: UIViewController) {
        addChild(childController)
        scrollView.addSubview(childController.view)
        childController.didMove(toParent: self)
    }

    /// Removes the view controller from its parent and unlinks the view from its superview
    /// and its window, and removes it from the responder chain.
    private func removeFromScrollView(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }

    /// Notifies the specified view controller that the insets that you use to determine
    /// the safe area for this view.
    private func notifySafeAreaInsets(_ viewController: Child) {
        viewController.pageViewController(self, actualSafeAreaInsets: view.safeAreaInsets)
    }
}

extension PageViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _scrollViewDidScroll(scrollView)
    }

    private func _scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.width > 0 else { return }

        delegate?.pageViewController(self, didScrollAtRatio: scrollRatio)

        guard !isTransitioning else { return }

        sendLifecycleEvent()
        layoutChildren()
    }

    /// Notifies the certain view controllers that event when child view controller
    /// about to appeared or disappeared in the scrollView.
    private func sendLifecycleEvent() {
        enum LifeSycle {
            case didAppear
            case didDisappear
        }

        let flooredPageIndex = PageIndex(scrollView.contentOffset.x / scrollView.bounds.width)
        let ceiledPageIndex = PageIndex(ceil(scrollView.contentOffset.x / scrollView.bounds.width))

        guard visibleIndices.forward != ceiledPageIndex || visibleIndices.backword != flooredPageIndex else {
            return
        }

        if ceiledPageIndex != visibleIndices.forward && minPageIndex...maxPageIndex ~= ceiledPageIndex {
            defer {
                visibleIndices.forward = ceiledPageIndex
            }

            let lifesycle: LifeSycle = visibleIndices.forward < ceiledPageIndex ? .didAppear : .didDisappear

            switch lifesycle {
            case .didAppear:
                viewControllers[ceiledPageIndex].pageViewController(self, didAppearAt: ceiledPageIndex)
            case .didDisappear:
                viewControllers[visibleIndices.forward].pageViewController(self, didDisappearAt: visibleIndices.forward)
            }
        }

        if flooredPageIndex != visibleIndices.backword && minPageIndex...maxPageIndex ~= flooredPageIndex {
            defer {
                visibleIndices.backword = flooredPageIndex
            }

            let lifesycle: LifeSycle = visibleIndices.backword > flooredPageIndex ? .didAppear : .didDisappear

            switch lifesycle {
            case .didAppear:
                viewControllers[flooredPageIndex].pageViewController(self, didAppearAt: flooredPageIndex)
            case .didDisappear:
                viewControllers[visibleIndices.backword].pageViewController(self, didDisappearAt: visibleIndices.backword)
            }
        }
    }

    /// Adds and removes a certain view controller as a child depending on the scroll offset.
    private func layoutChildren() {
        guard maxChildrenCount < viewControllers.count else { return }

        enum Action {
            case addChild
            case removeFromParent
        }

        let forwardOffset = scrollView.contentOffset.x + scrollView.bounds.width * CGFloat(forwardDistance)
        let forwardIndex = PageIndex(ceil(forwardOffset / scrollView.bounds.width))
        let newForwardIndex = max(minPageIndex, min(maxPageIndex, forwardIndex))

        if newForwardIndex != childrenIndices.forward {
            defer {
                childrenIndices.forward = newForwardIndex
            }

            let action: Action = newForwardIndex > childrenIndices.forward ? .addChild : .removeFromParent
            switch action {
            case .addChild:
                let backword = (newForwardIndex - maxChildrenCount).next(to: .forward)
                let lowerBound = max(backword, childrenIndices.forward.next(to: .forward))
                (max(minPageIndex, lowerBound)...newForwardIndex).forEach(addChild)

            case .removeFromParent:
                let backword = (childrenIndices.forward - maxChildrenCount).next(to: .forward)
                let lowerBound = max(backword, newForwardIndex.next(to: .forward))
                (newForwardIndex.next(to: .forward)...childrenIndices.forward).forEach { removeFromScrollView(viewControllers[$0]) }
            }
        }

        let backwardOffset = scrollView.contentOffset.x - scrollView.bounds.width * CGFloat(backwardDistance)
        let backwardIndex = PageIndex((backwardOffset / scrollView.bounds.width))
        let ajustedIndex = backwardIndex + maxChildrenCount > viewControllers.count
            ? self.viewControllers.count - maxChildrenCount
            : backwardIndex
        let newBackwardIndex = max(minPageIndex, ajustedIndex)

        if newBackwardIndex != childrenIndices.backward {
            defer {
                childrenIndices.backward = newBackwardIndex
            }

            let action: Action = newBackwardIndex < childrenIndices.backward ? .addChild : .removeFromParent
            switch action {
            case .addChild:
                let forward = (childrenIndices.backward + maxChildrenCount).next(to: .backward)
                let upperBound = min(forward, childrenIndices.backward.next(to: .backward))
                (newBackwardIndex...upperBound).forEach(addChild)

            case .removeFromParent:
                let currentForward = min((childrenIndices.backward + maxChildrenCount).next(to: .backward), maxPageIndex)
                let upperBound = min(currentForward, newBackwardIndex.next(to: .backward))
                (childrenIndices.backward...upperBound).forEach { removeFromScrollView(viewControllers[$0]) }
            }
        }
    }

    private func addChild(at index: PageIndex) {
        let viewController = viewControllers[index]
        viewController.view.frame = CGRect(
            origin: CGPoint(x: scrollView.bounds.width * CGFloat(index), y: 0),
            size: scrollView.bounds.size
        )
        notifySafeAreaInsets(viewController)
        addChildToScrollView(viewController)
    }
}

private final class PageScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        delaysContentTouches = false
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}

private extension PageIndex {
    enum Direction: Int {
        case forward  = 1
        case backward = -1
    }

    func next(to direction: Direction) -> PageIndex {
        return self + direction.rawValue
    }
}

private extension BinaryInteger {
    var isEven: Bool {
        return self % 2 == 0
    }
}

private extension Comparable where Self: Numeric {
    var isNegated: Bool {
        return self < 0
    }
}

private extension UIScrollView {
    var isInteracting: Bool {
        return isDragging && !isDecelerating || isTracking
    }
}
