import UIKit

// MARK: - LogViewState
enum LogViewState {
    case open
    case close
    
    var imageByState: UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        switch self {
        case .open:
            return UIImage(systemName: "arrow.up.doc", withConfiguration: configuration)!
        case .close:
            return UIImage(systemName: "arrow.down.doc", withConfiguration: configuration)!
        }
    }
    
    func toggle() -> Self {
        self == .open ? .close : .open
    }
}

//// MARK: - LogViewDirection
//enum LogViewDirection {
//    case top
//    case bottom
//
//    var openSwipeDirection: UISwipeGestureRecognizer.Direction {
//        switch self {
//        case .top:
//            return .down
//        case .bottom:
//            return .up
//        }
//    }
//
//    var closeSwipeDirection: UISwipeGestureRecognizer.Direction {
//        switch self {
//        case .top:
//            return .up
//        case .bottom:
//            return .down
//        }
//    }
//}

// MARK: - LoggerType
protocol LoggerType {
//    var logViewPosition: LogViewDirection { get }

    func logEvent(_ event: String)
}

//extension LoggerType {
//    var logViewPosition: LogViewDirection {
//        .bottom
//    }
//}


// MARK: - LogView
class LogView: UIView {
    weak var viewControllerDelegate: LogViewControllerDelegate?

    private var viewState = LogViewState.close {
        didSet {
            isHiddenView.setImage(isHiddenViewImage, for: .normal)
        }
    }
    private var isHiddenViewImage: UIImage { viewState.imageByState }
    private lazy var isHiddenView: UIButton = {
        let isHiddenView = UIButton()
        isHiddenView.setImage(isHiddenViewImage, for: .normal)
        isHiddenView.addTarget(self, action:  #selector(tapIsHiddenButton), for: .touchUpInside)
        
        return isHiddenView
    }()
    private lazy var swipeOpen = UISwipeGestureRecognizer(target: self, action: #selector(openView))
    private lazy var swipeClose = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
    

    @discardableResult
    func configured() -> Self {
        configure()
        
        return self
    }
}

extension LogView: LoggerType {
    func logEvent(_ event: String) {
        print(event)
    }
}

private extension LogView {
    func configure() {
        self.backgroundColor = .red
        
        configureGestures()
        configureIsHidden()
        
        viewControllerDelegate?.topOffset = 100
        viewControllerDelegate?.initLogView()
    }
    
    func configureGestures() {
        swipeOpen.direction = .up
        addGestureRecognizer(swipeOpen)
        
        swipeClose.direction = .down
        addGestureRecognizer(swipeClose)
    }
    
    func configureIsHidden() {
        addSubview(isHiddenView)
        isHiddenView.translatesAutoresizingMaskIntoConstraints = false
        isHiddenView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        isHiddenView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        isHiddenView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        isHiddenView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
    @objc
    func openView() {
        viewControllerDelegate?.openLogView()
        viewState = .open
    }
        
    @objc
    func closeView() {
        viewControllerDelegate?.closeLogView()
        viewState = .close
    }
    
    @objc
    func tapIsHiddenButton() {
        viewState == .open ? closeView() : openView()
    }
}
