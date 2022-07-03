//import UIKit
//import SnapKit
//
//class ViewController: UIViewController {
//    var similarGestureView: UIView!
//    var similarController: UIViewController!
//    var similarContentViewHeightConstraint: Constraint!
//    var similarContentView: UIView!
//    var prevState: ViewInteractiveAnimationState = .closed
//    var currentState: ViewInteractiveAnimationState = .closed
//    var topController: UIViewController? { self.parent }
//    var animationProgress: CGFloat = 0
//    var transitionAnimator: UIViewPropertyAnimator!
//}
//
//protocol ViewInteractiveAnimatableType: AnyObject {
//    var animationProgress: CGFloat { get set }
//    var transitionAnimator: UIViewPropertyAnimator! { get set }
//    var animationDuration: TimeInterval { get }
//    var animationDirection: ViewOpenInteractiveAnimationDirection { get }
//    var currentState: ViewInteractiveAnimationState { get set }
//
//    func panView(gestureRecognizer: UIPanGestureRecognizer)
//    func panViewChanged(gestureRecognizer: UIPanGestureRecognizer)
//    func panViewEnded(gestureRecognizer: UIPanGestureRecognizer)
//
//    func updateView(for state: ViewInteractiveAnimationState)
//    func animationCompletion(to state: ViewInteractiveAnimationState)
//}
//
//extension ViewInteractiveAnimatableType {
//    var animationDuration: TimeInterval { 0.3 }
//
//    func animate(to state: ViewInteractiveAnimationState) {
//        if let animator = self.transitionAnimator, animator.isRunning || animator.state == .active {
//            return
//        }
//
//        updateView(for: self.currentState)
//
//        self.transitionAnimator = UIViewPropertyAnimator(duration: self.animationDuration, dampingRatio: 1)
//        self.transitionAnimator.addAnimations { [weak self] in self?.updateView(for: state) }
//        self.transitionAnimator.addCompletion { [weak self] position in
//            guard let self = self else { return }
//
//            switch position {
//            case .start: self.currentState = state.opposite
//            case .end: self.currentState = state
//            case .current: break
//            @unknown default: break
//            }
//
//            self.updateView(for: self.currentState)
//
//            if case .end = position {
//                self.animationCompletion(to: state)
//            }
//        }
//        self.transitionAnimator.startAnimation()
//    }
//
//    func updateView(for state: ViewInteractiveAnimationState) {
//        switch state {
//        case .open:
//            self.animatableView.transform = .identity
//
//        case .closed:
//            let translationY: CGFloat = {
//                let multiplier: CGFloat
//
//                switch self.animationDirection {
//                case .fromTop: multiplier = -1
//                case .fromDown: multiplier = 1
//                }
//
//                return self.animatableView.height * multiplier
//            }()
//            self.animatableView.transform = CGAffineTransform(translationX: 0, y: translationY)
//        }
//
//        updateOtherViews(for: state)
//    }
//
//    func panView(gestureRecognizer: UIPanGestureRecognizer) {
//        switch gestureRecognizer.state {
//        case .began: panViewBegan()
//        case .changed: panViewChanged(gestureRecognizer: gestureRecognizer)
//        case .ended: panViewEnded(gestureRecognizer: gestureRecognizer)
//        default: break
//        }
//    }
//
//    func panViewBegan() {
//        animate(to: self.currentState.opposite)
//        self.transitionAnimator.pauseAnimation()
//        self.animationProgress = self.transitionAnimator.fractionComplete
//    }
//
//    func panViewChanged(gestureRecognizer: UIPanGestureRecognizer) {
//        let translation = gestureRecognizer.translation(in: self.animatableView)
//        let fractionComplete: (CGPoint) -> CGFloat = { translation in
//            var fraction: CGFloat = {
//                switch self.animationDirection {
//                case .fromTop: return translation.y / self.animatableView.height
//                case .fromDown: return -translation.y / self.animatableView.height
//                }
//            }()
//
//            if self.currentState == .open {
//                fraction *= -1
//            }
//
//            if self.transitionAnimator.isReversed {
//                fraction *= -1
//            }
//
//            return fraction + self.animationProgress
//        }
//        self.transitionAnimator.fractionComplete = fractionComplete(translation)
//    }
//
//    func panViewEnded(gestureRecognizer: UIPanGestureRecognizer) {
//        let velocity = gestureRecognizer.velocity(in: self.animatableView)
//
//        guard velocity.y != 0 else {
//            self.transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//            return
//        }
//
//        let shouldClose: Bool = {
//            switch self.animationDirection {
//            case .fromTop: return velocity.y < 0
//            case .fromDown: return velocity.y > 0
//            }
//        }()
//
//        switch self.currentState {
//        case .open:
//            let reversed = (!shouldClose && !self.transitionAnimator.isReversed) || (shouldClose && self.transitionAnimator.isReversed)
//
//            if reversed {
//                self.transitionAnimator.isReversed.toggle()
//            }
//
//        case .closed:
//            let reversed = (shouldClose && !self.transitionAnimator.isReversed) || (!shouldClose && self.transitionAnimator.isReversed)
//
//            if reversed {
//                self.transitionAnimator.isReversed.toggle()
//            }
//        }
//
//        self.transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//    }
//
//    func animationCompletion(to state: ViewInteractiveAnimationState) {}
//}
//
//
//
//
//extension ViewInteractiveAnimationState {
//    var opposite: Self {
//        switch self {
//        case .open: return .closed
//        case .closed: return .open
//        }
//    }
//}
//
//extension ViewController: ViewInteractiveAnimatableType {
//
//    var animatableView: UIView {
//        similarContentView
//    }
//
//    var animationDirection: ViewOpenInteractiveAnimationDirection {
//        .fromDown
//    }
//
//
//    internal var similarHeaderHeight: CGFloat { 22 }
//    internal var similarVisibleMinHeight: CGFloat { 44 }
//    internal var similarViewHeight: CGFloat {
//        guard let topView = self.topController?.view else { return 0 }
//        return topView.frame.size.height - topView.safeAreaInsets.top
//    }
//    internal var similarMaxHeight: CGFloat { similarViewHeight + similarHeaderHeight }
//    internal var similarMinHeight: CGFloat {
//        self.view.safeAreaInsets.bottom + similarVisibleMinHeight + similarHeaderHeight
//    }
//
//    internal func updateSimilarControllerHeight() {
//        self.similarController?.view.snp.updateConstraints { $0.height.equalTo(similarViewHeight) }
//    }
//
//    internal func updateSimilarContainerHeight(for state: ViewInteractiveAnimationState? = nil) {
//        let state = state ?? self.currentState
//        let height: CGFloat = {
//            switch state {
//            case .open: return similarMaxHeight
//            case .closed: return similarMinHeight
//            }
//        }()
//        self.similarContentViewHeightConstraint.update(offset: height)
//    }
//
//
//    private func processSimilarGestureView(for state: ViewInteractiveAnimationState) {
//        switch state {
//        case .open:
//            self.similarGestureView.removeFromSuperview()
//
//        case .closed:
//            guard self.similarGestureView.superview == nil else { return }
//
//            self.similarContentView.addSubview(self.similarGestureView)
//            self.similarGestureView.snp.makeConstraints { $0.edges.equalToSuperview() }
//        }
//    }
//}
//
//
//
//
//// MARK: ViewInteractiveAnimatableType
//extension ViewController: ViewInteractiveAnimatableType {
//    @objc
//    func panView(gestureRecognizer: UIPanGestureRecognizer) {
//        switch gestureRecognizer.state {
//        case .began:
//
//            panViewBegan()
//
//        case .changed:
//            panViewChanged(gestureRecognizer: gestureRecognizer)
//
//        case .ended:
//            self.panViewEnded(gestureRecognizer: gestureRecognizer)
//
//        default: break
//        }
//    }
//
//    func panViewBegan() {
//        animate(to: self.currentState.opposite, interactionType: .gesture)
//        self.transitionAnimator.pauseAnimation()
//        self.animationProgress = self.transitionAnimator.fractionComplete
//    }
//
//    func panViewChanged(gestureRecognizer: UIPanGestureRecognizer) {
//        let translation = gestureRecognizer.translation(in: self.animatableView)
//        let fractionComplete: (CGPoint) -> CGFloat = { translation in
//            var fraction = -translation.y / self.similarMaxHeight
//
//            if self.currentState == .open {
//                fraction *= -1
//            }
//
//            if self.transitionAnimator.isReversed {
//                fraction *= -1
//            }
//
//            return fraction + self.animationProgress
//        }
//        self.transitionAnimator.fractionComplete = fractionComplete(translation)
//    }
//
//    func animate(to state: ViewInteractiveAnimationState, interactionType: EventInteractionType) {
//        if let animator = self.transitionAnimator, animator.isRunning || animator.state == .active {
//            return
//        }
//
//        updateView(for: self.currentState)
//
//        self.transitionAnimator = UIViewPropertyAnimator(duration: self.animationDuration, dampingRatio: 1)
//        self.transitionAnimator.addAnimations { [weak self] in self?.updateView(for: state) }
//        self.transitionAnimator.addCompletion { [weak self] position in
//            guard let self = self else { return }
//
//            switch position {
//            case .start: self.currentState = state.opposite
//            case .end: self.currentState = state
//            case .current: break
//            @unknown default: break
//            }
//
//            self.updateView(for: self.currentState)
//            self.updateNavigationBar(for: self.currentState)
//
//            if case .end = position {
//                self.animationCompletion(to: state, interactionType: interactionType)
//            }
//        }
//        self.transitionAnimator.startAnimation()
//    }
//
//    func animationCompletion(to state: ViewInteractiveAnimationState, interactionType: EventInteractionType) {
//        self.processSimilarGestureView(for: state)
//        self.processSimilarStateAnalytics(interactionType: interactionType)
//    }
//
//    func updateView(for state: ViewInteractiveAnimationState) {
//        updateOtherViews(for: state)
//
//        self.updateSimilarContainerHeight(for: state)
//        self.topController?.view.layoutIfNeeded()
//    }
//
//    func updateOtherViews(for state: ViewInteractiveAnimationState) {
//        switch state {
//        case .open:
//            self.actionBar.alpha = 0
//            self.similarContentView.cornerRadius = 0
//
//        case .closed:
//            self.actionBar.alpha = 1
//            self.similarContentView.cornerRadius = 10
//        }
//    }
//}
//
//
//enum ViewInteractiveAnimationState {
//    case closed
//    case open
//}
//
//enum ViewOpenInteractiveAnimationDirection {
//    case fromTop
//    case fromDown
//}
