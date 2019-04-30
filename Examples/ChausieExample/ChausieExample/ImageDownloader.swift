import Foundation

final class ImageDownloader {
    private var currentTask: URLSessionDataTask?

    func download(url: URL, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        currentTask = URLSession.shared.dataTask(with: url) { data, _, error in
            completionHandler(data, error)
        }
        currentTask?.resume()
    }

    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}
