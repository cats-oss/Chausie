import UIKit

protocol HasCategory: class {
    var category: Category { get set }
    static func make(category: Category) -> Self
}

extension HasCategory where Self: UIViewController {
    static func make(category: Category) -> Self {
        let controller = Self()
        controller.category = category
        return controller
    }
}

extension HasCategory where Self: UICollectionViewController {
    static func make(collectionViewLayout: UICollectionViewLayout, category: Category) -> Self {
        let controller = Self(collectionViewLayout: collectionViewLayout)
        controller.category = category
        return controller
    }
}
