import UIKit

class ViewController: UIViewController {

    private let service = BaiduMobStat.default()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var eventButton: UIButton!
    @IBAction func eventButtonClicked(_ sender: Any) {
        print("Start log event...")
        service.logEvent("First event", attributes: [:])
    }
}

