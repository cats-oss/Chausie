import UIKit

/// A composer that generates tab view and page view controller in
/// tab page view controller.
open class TabPageComposer<TabCell: TabItemCell & UIControl> {
    /// The dataset composed of child view controller and tab view's model.
    public struct Component {
        /// A view controller that conforms to `Pageable`.
        public var child: PageViewController.Child

        /// A model used to make a item in tab view.
        public var cellModel: TabCell.Model

        public init<C: PageViewController.Child>(child: C, cellModel: TabCell.Model) {
            self.child = child
            self.cellModel = cellModel
        }
    }

    /// An array of component composed of child view controller and
    /// tab view's model.
    public var components: [Component]

    /// A generator of tab view.
    internal var tabViewGenerator: () -> TabView

    /// - Parameters:
    ///     - components: An array of component composed of child view
    ///                   controller and tab view's model.
    ///     - tabViewGenerator: A generator of tab view.
    public init(
        components: [Component],
        tabViewGenerator: @escaping ([TabCell.Model]) -> TabView = { cellModels in
            let tabView = TabView()
            tabView.renderCells(
                with: cellModels,
                cellGenerator: { TabCell.make(model: $0) }
            )
            return tabView
        }
        ) {
        self.components = components
        self.tabViewGenerator = {
            tabViewGenerator(components.map { $0.cellModel })
        }
    }
}
