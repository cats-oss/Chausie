import XCTest
@testable import Chausie

private final class TabPageViewControllerDelegateTests: XCTestCase {
    func testScrollToPage() {
        typealias Composer = TabPageComposer<MockTabCell>
        typealias Component = Composer.Component

        let components = [
            Component(child: MockPagebableViewController(), cellModel: "0"),
            Component(child: MockPagebableViewController(), cellModel: "1"),
            Component(child: MockPagebableViewController(), cellModel: "2"),
            Component(child: MockPagebableViewController(), cellModel: "3"),
        ]

        let tabPageViewController = TabPageViewController(
            composer: Composer(components: components),
            tabViewLayout: TabViewLayout(
                top: Position(origin: .safeArea, distance: 0),
                trailing: Position(origin: .view, distance: 10),
                leading: Position(origin: .view, distance: 10),
                height: 100
            )
        )

        let delegate = MockDelegate()
        tabPageViewController.delegate = delegate
        tabPageViewController.pageViewController.view.layoutIfNeeded()
        tabPageViewController.view.layoutIfNeeded()

        tabPageViewController.pageViewController.scrollToPage(at: 0, animated: false)
        XCTAssertEqual(delegate.ratio, 0)

        tabPageViewController.pageViewController.scrollToPage(at: 1, animated: false)
        XCTAssertEqual(delegate.ratio, 0.25)

        tabPageViewController.pageViewController.scrollToPage(at: 2, animated: false)
        XCTAssertEqual(delegate.ratio, 0.5)

        tabPageViewController.pageViewController.scrollToPage(at: 3, animated: false)
        XCTAssertEqual(delegate.ratio, 0.75)
    }
}

private final class MockDelegate: TabPageViewControllerDelegate {
    private(set) var ratio: CGFloat?

    func tabPageViewController(_ tabPageViewController: TabPageViewController, didScrollAtRatio ratio: CGFloat) {
        self.ratio = ratio
    }
}
