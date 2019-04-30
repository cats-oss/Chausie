import XCTest
@testable import Chausie

private final class PageViewControllerDelegateTests: XCTestCase {
    func testScrollToPage() {
        let viewControllers = ContiguousArray<PageViewController.Child>((0...5).map { _ in MockPagebableViewController() })
        let pageViewController = PageViewController(
            viewControllers: viewControllers,
            maxChildrenCount: 3,
            initialPageIndex: 0
        )

        let delegate = MockDelegate()
        pageViewController.delegate = delegate
        pageViewController.view.layoutIfNeeded()

        pageViewController.scrollToPage(at: 0, animated: false)
        XCTAssertEqual(delegate.ratio, 0)

        pageViewController.scrollToPage(at: 5, animated: false)
        XCTAssertEqual(delegate.ratio, 1 - (CGFloat(1) / 6))

        pageViewController.scrollToPage(at: 3, animated: false)
        XCTAssertEqual(delegate.ratio, 1 - (CGFloat(1) / 2))
    }
}

private final class MockDelegate: PageViewControllerDelegate {
    private(set) var ratio: CGFloat?

    func pageViewController(_ pageViewController: PageViewController, didScrollAtRatio ratio: CGFloat) {
        self.ratio = ratio
    }
}
