import UIKit

/// A customizable container view controller that manages tab view and page view controller.
open class TabPageViewController: UIViewController, PageViewControllerDelegate {
    /// The delegate object. methods of the delegate are called in response to scroll changes.
    public weak var delegate: TabPageViewControllerDelegate?

    /// The tab view that the controller manages.
    public let tabView: TabView

    /// The page view controller that the controller manages.
    public let pageViewController: PageViewController

    /// The layout of inner tab view.
    private let tabViewLayout: TabViewLayout

    /// - Parameters:
    ///     - composer: A composer that generates tab view and page view controller.
    ///     - tabViewLayout: The layout of tab view.
    ///     - maxChildrenCount: A maximum count of child view controller to add to the container.
    ///                         child view controllers added to the container is always changed
    ///                         by the scroll position. the default value is 1.
    ///     - initialPageIndex: A index of content to be displayed when the view controller
    ///                         loads the view hierarchy into memory. the default value is 0.
    public required init<TabCell: TabItemCell & UIControl>(
        composer: TabPageComposer<TabCell>,
        tabViewLayout: TabViewLayout,
        maxChildrenCount: Int = 1,
        initialPageIndex: PageIndex = 0
        ) {

        precondition(
            0...composer.components.count ~= maxChildrenCount,
            """
            Invalid value: `maxChildrenCount` (\(maxChildrenCount)) out of range.
            Check `composer.components.count` (\(composer.components.count)) or `maxChildrenCount` (\(maxChildrenCount)).
            """
        )

        precondition(
            0...composer.components.count - 1 ~= initialPageIndex,
            """
            Invalid value: `initialPageIndex (\(initialPageIndex))` out of range.
            Check `composer.components.count` (\(composer.components.count)) or `initialIndex` (\(initialPageIndex)).
            """
        )

        self.pageViewController = PageViewController(
            viewControllers: composer.components.map { $0.child },
            maxChildrenCount: maxChildrenCount,
            initialPageIndex: initialPageIndex
        )
        self.tabView = composer.tabViewGenerator()
        self.tabViewLayout = tabViewLayout

        super.init(nibName: nil, bundle: nil)

        tabView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabView)
        tabView.selectedCell = { [weak pageViewController] _, index in
            pageViewController?.scrollToPage(at: index, animated: true)
        }

        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(
                equalTo: view.topAnchor(for: tabViewLayout.top.origin),
                constant: tabViewLayout.top.distance
            ),
            tabView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor(for: tabViewLayout.trailing.origin),
                constant: -tabViewLayout.trailing.distance
            ),
            tabView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor(for: tabViewLayout.leading.origin),
                constant: tabViewLayout.leading.distance
            ),
            tabView.heightAnchor.constraint(
                equalToConstant: tabViewLayout.height
            )
        ])

        // Needs to lays out before `pageViewController` starts to scrolling.
        tabView.layoutIfNeeded()

        pageViewController.delegate = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(pageViewController)
        pageViewController.view.frame = view.bounds
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        let pageview: UIView = pageViewController.view
        NSLayoutConstraint.activate([
            pageview.topAnchor.constraint(
                equalTo: tabView.bottomAnchor,
                constant: 0
            ),
            pageview.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: 0
            ),
            pageview.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 0
            ),
            pageview.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: 0
            )
        ])
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let tabViewWidth = view.bounds.size.width
            - inset(for: tabViewLayout.leading).left + tabViewLayout.leading.distance
            - inset(for: tabViewLayout.trailing).right + tabViewLayout.trailing.distance
        if tabViewWidth != tabView.bounds.width {
            tabView.layoutIfNeeded()
            tabView.highlightCells(withRatio: pageViewController.scrollRatio)
        }
    }

    open func pageViewController(_ pageViewController: PageViewController, didScrollAtRatio ratio: CGFloat) {
        tabView.highlightCells(withRatio: ratio)
        delegate?.tabPageViewController(self, didScrollAtRatio: ratio)
    }

    private func inset(for position: Position) -> UIEdgeInsets {
        switch position.origin {
        case .layoutMargin:
            return view.layoutMargins

        case .safeArea:
            return view.safeAreaInsets

        case .view:
            return .zero
        }
    }
}

private extension UIView {
    /// Returns `NSLayoutYAxisAnchor` by using `Position.Origin`.
    func topAnchor(for origin: Position.Origin) -> NSLayoutYAxisAnchor {
        switch origin {
        case .layoutMargin:
            return layoutMarginsGuide.topAnchor

        case .safeArea:
            return safeAreaLayoutGuide.topAnchor

        case .view:
            return topAnchor
        }
    }

    /// Returns `NSLayoutXAxisAnchor` by using `Position.Origin`.
    func trailingAnchor(for origin: Position.Origin) -> NSLayoutXAxisAnchor {
        switch origin {
        case .layoutMargin:
            return layoutMarginsGuide.trailingAnchor

        case .safeArea:
            return safeAreaLayoutGuide.trailingAnchor

        case .view:
            return trailingAnchor
        }
    }

    /// Returns `NSLayoutYAxisAnchor` by using `Position.Origin`.
    func bottomAnchor(for origin: Position.Origin) -> NSLayoutYAxisAnchor {
        switch origin {
        case .layoutMargin:
            return layoutMarginsGuide.bottomAnchor

        case .safeArea:
            return safeAreaLayoutGuide.bottomAnchor

        case .view:
            return bottomAnchor
        }
    }

    /// Returns `NSLayoutXAxisAnchor` by using `Position.Origin`.
    func leadingAnchor(for origin: Position.Origin) -> NSLayoutXAxisAnchor {
        switch origin {
        case .layoutMargin:
            return layoutMarginsGuide.leadingAnchor

        case .safeArea:
            return safeAreaLayoutGuide.leadingAnchor

        case .view:
            return leadingAnchor
        }
    }
}
