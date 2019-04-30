import Chausie
import UIKit

final class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, Pageable, HasCategory {

    private let cellIdentifier = String(describing: ImageCollectionViewCell.self)
    private let itemSize = CGSize(width: 200, height: 250)

    var category = Category.cats

    private var horizontalMargin: CGFloat {
        let columnCount: CGFloat = 2
        let totalMargin = collectionView.bounds.width - itemSize.width * columnCount
        let marginCounbt = columnCount + 1
        return totalMargin / marginCounbt
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(
            UINib(nibName: cellIdentifier, bundle: nil),
            forCellWithReuseIdentifier: cellIdentifier
        )

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            collectionView.collectionViewLayout = layout
        }

        collectionView.delegate   = self
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionViewCell
        let url = URLBuilder.build(category: category, width: itemSize.width, height: itemSize.height)
        cell.render(with: url)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: horizontalMargin, bottom: 8, right: horizontalMargin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalMargin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
