

//MARK:- Custom Navigation to Navigation Controller


import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    override func viewDidLoad() {
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        addPanGesture(viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if operation == .pop {
            return NavigationPopTransition()
        }else{
            return nil
        }

    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController.isKind(of: NavigationPopTransition.self) {
            return interactivePopTransition
        }else{
            return nil
        }
    }
    
    private func addPanGesture(_ viewController: UIViewController){
        let popRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(recognizer:)))
        viewController.view.addGestureRecognizer(popRecognizer)
    }
    
    @objc func handlePanRecognizer(recognizer: UIPanGestureRecognizer){
        var progress = recognizer.translation(in: self.view).x / self.view.bounds.size.width
        progress = min(1, max(0, progress))
        print(progress)
        if recognizer.state == .began {
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.popViewController(animated: true)
        }else if recognizer.state == .changed {
            interactivePopTransition.update(progress)
        }else if recognizer.state == .ended || recognizer.state == .cancelled {
            if progress > 0.2 {
                interactivePopTransition.finish()
            }else{
                interactivePopTransition.cancel()
            }
            interactivePopTransition = nil
        }
    }
}
//USAGE : Direct assign as a Class to Navigation Controller


class NavigationPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        toViewController.view.frame = CGRect(x: -100, y: toViewController.view.frame.origin.y, width: fromViewController.view.frame.size.width , height: fromViewController.view.frame.size.height)
        
        let dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height))
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0.7
        
        toViewController.view.addSubview(dimmingView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        
                        dimmingView.alpha = 0
                        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
                        fromViewController.view.frame = CGRect(x: toViewController.view.frame.size.width, y: fromViewController.view.frame.origin.y, width: fromViewController.view.frame.size.width, height: fromViewController.view.frame.size.height)
                        
        }) { finished in
            
            dimmingView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
}

