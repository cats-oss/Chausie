import Chausie

typealias TabPageComponent = TabPageComposer<TabItemButton>.Component

extension TabPageViewController {
    convenience init<Cell: TabItemCell & UIControl>(
        components: [TabPageComposer<Cell>.Component],
        maxChildrenCount: Int = 1,
        initialPageIndex: PageIndex = 0,
        tabViewLayout: TabViewLayout = .default
        ) {
        self.init(
            composer: ProgressBorderTabPageComposer<Cell>(components: components),
            tabViewLayout: tabViewLayout,
            maxChildrenCount: maxChildrenCount,
            initialPageIndex: initialPageIndex
        )
    }
}
