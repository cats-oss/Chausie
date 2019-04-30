import UIKit

final class ImageTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentImageView: UIImageView! {
        didSet {
            contentImageView.layer.cornerRadius = 30
        }
    }

    private let downloader = ImageDownloader()

    override func prepareForReuse() {
        super.prepareForReuse()
        contentImageView.image = nil
        downloader.cancel()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .black
    }

    func render(with url: URL) {
        downloader.download(url: url) { [weak self] data, error in
            guard let me = self else { return }

            DispatchQueue.main.async {
                guard let image = data.map(UIImage.init(data:)), error == nil else {
                    me.contentImageView.image = nil
                    return
                }

                me.contentImageView.image = image
            }
        }
    }
}
