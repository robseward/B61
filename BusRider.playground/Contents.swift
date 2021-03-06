//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import RxSwift

class MyViewController : UIViewController {
    var buttonInfo: [(String, UIColor)]!
    var buttons: [UIButton]!
    var buttonsAndConstraints: [UIButton : (NSLayoutConstraint, NSLayoutConstraint)]!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationView = UIView()
        self.view.addSubview(locationView)
        locationView.translatesAutoresizingMaskIntoConstraints = false
        locationView.backgroundColor = UIColor.yellow
        let width: CGFloat = 15
        NSLayoutConstraint.activate(
            [locationView.widthAnchor.constraint(equalToConstant: width),
             locationView.heightAnchor.constraint(equalToConstant: width),
             locationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             locationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        locationView.layer.cornerRadius = width/2.0
        
        
        buttonInfo = [("B01", UIColor.blue),
                       ("B02", UIColor.red),
                       ("B03", UIColor.gray),
                       ("B04", UIColor.brown),
                        ("B05", UIColor.blue),
                        ("B06", UIColor.red),
                       ]
        
        buttons = buttonInfo.map { (name, color) -> UIButton in
            let size = CGSize(width: 50, height: 50)
            return createButton(title: name, color: color, size: size)
        }
       
        buttonsAndConstraints = [UIButton : (NSLayoutConstraint, NSLayoutConstraint)]()
        buttons.forEach({ button in
            let constraints = self.addButtonToCenterOfView(button: button)
            buttonsAndConstraints[button] = constraints
            button.alpha = 0
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let locations = buttons.enumerated().map({ index, button -> (UIButton, CGPoint) in
            var offset = CGPoint.zero
            
            let radius: Double = 65
            let angle = (Double.pi / 3.0) * Double(index - 1)
            offset.y = CGFloat(sin(angle) * radius)
            offset.x = CGFloat(cos(angle) * radius)
            
            return (button, offset)
        })
        
        locations.forEach({ (button, offset) in
            print(offset)
            let constraints = buttonsAndConstraints[button]!
            
            UIView.animate(withDuration: 3.3, animations: {
                constraints.0.constant = offset.x
                constraints.1.constant = offset.y
                button.alpha = 1.0
                self.view.layoutIfNeeded()
            })
        })
    }
    

    
    private func createButton(title: String,
                              color: UIColor,
                              size: CGSize) -> UIButton {
        let button = UIButton(frame: CGRect.zero)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.widthAnchor.constraint(equalToConstant: size.width), button.heightAnchor.constraint(equalToConstant: size.height)])
        button.layer.cornerRadius = size.width / 2.0
        return button
    }
    
    /// Returns offset
    private func addButtonToCenterOfView(button: UIButton) -> (NSLayoutConstraint, NSLayoutConstraint) {
        view.addSubview(button)
        let constraints = [button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20), button.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        NSLayoutConstraint.activate(constraints)
        return (constraints[0], constraints[1])
    }
}



class ViewModel {
    
}




PlaygroundPage.current.liveView = MyViewController()
