import UIKit

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

protocol LoggerType {
    func logEvent(_ event: String)
}

class LogView: UIView {
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
        configureIsHidden()
    }
    
    func configureIsHidden() {
        let image = LogViewState.open.imageByState
        let isHiddenView = UIButton()
        isHiddenView.setImage(image, for: .normal)
        isHiddenView.addTarget(self, action:  #selector(isHiddenViewAction), for: .touchUpInside)
        
        addSubview(isHiddenView)
        isHiddenView.translatesAutoresizingMaskIntoConstraints = false
        isHiddenView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        isHiddenView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    
    @objc
    func isHiddenViewAction() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.removeFromSuperview()
            self.layoutIfNeeded()
            })

    }
}
