import XCTest
@testable import Chausie

private final class TabPageViewControllerTests: XCTestCase {
    var tabPageViewController: TabPageViewController!

    override func setUp() {
        typealias Composer = TabPageComposer<MockTabCell>
        typealias Component = Composer.Component

        let components = [
            Component(child: MockPagebableViewController(), cellModel: "0"),
            Component(child: MockPagebableViewController(), cellModel: "1"),
            Component(child: MockPagebableViewController(), cellModel: "2"),
            Component(child: MockPagebableViewController(), cellModel: "3"),
        ]

        tabPageViewController = TabPageViewController(
            composer: Composer(components: components),
            tabViewLayout: TabViewLayout(
                top: Position(origin: .safeArea, distance: 0),
                trailing: Position(origin: .view, distance: 10),
                leading: Position(origin: .view, distance: 10),
                height: 100
            )
        )
    }

    func testLayout() {
        tabPageViewController.view.frame.size = CGSize(width: 300, height: 500)
        tabPageViewController.view.layoutIfNeeded()
        XCTAssertEqual(
            tabPageViewController.tabView.frame,
            CGRect(x: 10, y: 0, width: 280, height: 100)
        )
        XCTAssertEqual(
            tabPageViewController.pageViewController.view.frame,
            CGRect(x: 0, y: 100, width: 300, height: 400)
        )
    }

    func testHighlightRatio() {
        tabPageViewController.pageViewController.scrollToPage(at: 2, animated: false)
        let subviews = tabPageViewController.tabView.subviews.compactMap { $0 as? MockTabCell }
        XCTAssertEqual(subviews[2].ratio, 1)
    }
}
