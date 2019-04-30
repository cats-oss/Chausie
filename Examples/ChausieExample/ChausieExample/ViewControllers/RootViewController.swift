import Chausie
import UIKit

final class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let controller = TabPageViewController(
            components: [
                TabPageComponent(
                    child: CollectionViewController.make(
                        collectionViewLayout: UICollectionViewFlowLayout(),
                        category: .cats
                    ),
                    cellModel: .cats
                ),
                TabPageComponent(
                    child: TableViewController.make(category: .technics),
                    cellModel: .technics
                ),
                TabPageComponent(
                    child: CollectionViewController.make(
                        collectionViewLayout: UICollectionViewFlowLayout(),
                        category: .fashion
                    ),
                    cellModel: .fashion
                )
            ]
        )

        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
