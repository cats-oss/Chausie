import Chausie

final class ProgressBorderTabPageComposer<TabCell: TabItemCell & UIControl>: TabPageComposer<TabCell> {
    init(components: [TabPageComposer<TabCell>.Component]) {
        super.init(
            components: components,
            tabViewGenerator: { cellModels in
                let tabView = ProgressBorderTabView()
                tabView.renderCells(with: cellModels, cellGenerator: { TabCell.make(model: $0) })
                return tabView
            }
        )
    }
}
