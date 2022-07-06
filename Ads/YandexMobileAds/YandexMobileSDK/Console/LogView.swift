import UIKit

// MARK: - LoggerType
protocol LoggerType {
    func logEvent(_ event: String)
}

// MARK: - LogView
class LogView: UIView {
    weak var viewControllerDelegate: LogViewControllerDelegate!
    private weak var logStoreData: LogData!

    private var viewState = LogViewState.close {
        didSet {
            isHiddenButton.setImage(isHiddenViewImage, for: .normal)
        }
    }

    private var isHiddenViewImage: UIImage { viewState.imageByState }
    private lazy var isHiddenButton: UIButton = {
        let view = UIButton()
        view.setImage(isHiddenViewImage, for: .normal)
        view.addTarget(self, action:  #selector(tapIsHiddenButton), for: .touchUpInside)
        
        return view
    }()

    private lazy var cleanButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "trash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
        view.addTarget(self, action:  #selector(clean), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var textView: UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.isSelectable = false
        
        text.font = UIFont.systemFont(ofSize: 18)
        
        return text
    }()
    
    private lazy var titleBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4

        return view
    }()

    private lazy var swipeOpen = UISwipeGestureRecognizer(target: self, action: #selector(openView))
    private lazy var swipeClose = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
    

    @discardableResult
    func configured(with logData: LogData) -> Self {
        self.logStoreData = logData

        configure()
        
        return self
    }
}

extension LogView: LoggerType {
    func logEvent(_ event: String) {
        logStoreData.data.append(contentsOf: event)
        textView.text = logStoreData.data
    }
}

private extension LogView {
    func configure() {
        
        textView.text = logStoreData.data

        configureGestures()
        configureIsHiddenButton()
        configureCleanButton()
        configureLogTextView()
        configureTitleBar()
        
        
        viewControllerDelegate?.topOffset = 80
        viewControllerDelegate?.initLogView()
    }
    
    func configureGestures() {
        swipeOpen.direction = .up
        addGestureRecognizer(swipeOpen)
        
        swipeClose.direction = .down
        addGestureRecognizer(swipeClose)
    }
    
    func configureIsHiddenButton() {
        addSubview(isHiddenButton)
        isHiddenButton.translatesAutoresizingMaskIntoConstraints = false
        isHiddenButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        isHiddenButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        isHiddenButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        isHiddenButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func configureCleanButton() {
        addSubview(cleanButton)
        cleanButton.translatesAutoresizingMaskIntoConstraints = false
        cleanButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cleanButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cleanButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cleanButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cleanButton.alpha = 0
    }

    func configureLogTextView() {
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.cleanButton.bottomAnchor, constant: 20).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    func configureTitleBar() {
        addSubview(titleBar)

        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    @objc
    func openView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }

            self.viewControllerDelegate?.openLogView()
            self.viewState = .open
            self.cleanButton.alpha = 1
        }
    }
        
    @objc
    func closeView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }

            self.viewControllerDelegate?.closeLogView()
            self.viewState = .close
            self.cleanButton.alpha = 0
        }
    }
    
    @objc
    func tapIsHiddenButton() {
        viewState == .open ? closeView() : openView()
    }
    
    @objc
    func clean() {
        textView.text = String()
    }
}

// MARK: - LogViewState
enum LogViewState {
    case open
    case close
    
    var imageByState: UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        switch self {
        case .open:
            return UIImage(systemName: "chevron.down.circle.fill", withConfiguration: configuration)!
        case .close:
            return UIImage(systemName: "chevron.up.circle.fill", withConfiguration: configuration)!
        }
    }
    
    func toggle() -> Self {
        self == .open ? .close : .open
    }
}


