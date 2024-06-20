import UIKit
import DropDown

protocol DropDownViewDelegate {
    func dropDownView(view: UIView, selectItem item: String, selectIndex index: Int)
}

class DropDownView: UIView {
    
    var delegate: DropDownViewDelegate?
    
    private let dropDown = DropDown()

    var dropDownList: [String] = [] {
        didSet{ dropDown.dataSource = dropDownList }
    }
    
    var index: Int = 0 {
        didSet {
            if dropDownList.count > 0 {
                print("drop down index \(index) \(dropDownList[index])")
                dropDown.selectRow(at: index, scrollPosition: .middle)
                dropDownLabel.text = dropDownList[index]
                //self.delegate?.uploadFileCell(cell: self, selectIndex: index)
            }
        }
    }
    
    var direction: DropDown.Direction = .bottom
    
    var text: String = "" {
        didSet {
            dropDownLabel.text = text
        }
    }

    private lazy var dropDownLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.text = ""
        label.textColor = .black
        
        return label
    }()
    
    private lazy var arrorDownView: UIImageView = {
        let image = UIImage(systemName: "chevron.down")?.withTintColor(.systemGreen, renderingMode: .alwaysTemplate)
        let imageView = UIImageView(image: image?.imageResize(newSize: CGSize(width: 20.0, height: 20.0)))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        return imageView
    }()
    
    private lazy var dropDownView: UIStackView = {
        //let image = UIImage(systemName: "chevron.down")?.withTintColor(.systemGreen, renderingMode: .alwaysTemplate)
        //let imageView = UIImageView(image: image?.imageResize(newSize: CGSize(width: 20.0, height: 20.0)))
        
        let view = UIStackView(arrangedSubviews: [dropDownLabel, arrorDownView])
        
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .center
        view.distribution = .fill
        
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.isLayoutMarginsRelativeArrangement = true
        
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dropDownTap(_:))))
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        initView()
    }

    func initView() {
        self.cornerRadius = 8
        self.addSubview(dropDownView)
        
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dropDownView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dropDownView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dropDownView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        //dropDownView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        setDropDownMenu()
    }
    
    private func setDropDownMenu() {
        dropDown.anchorView = dropDownView
        
        //dropDown.bottomOffset = CGPoint(x: 0, y: dropButton.bounds.height)
        dropDown.dataSource = dropDownList
        dropDown.bottomOffset = CGPoint(x: 0, y: 38)
        dropDown.dismissMode = .onTap
        dropDown.direction = direction
        
        //index = 0
        // Action triggered on selection
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.index = index
            self?.delegate?.dropDownView(view: self!, selectItem: item, selectIndex: index)
        }
    }
    
    @objc private func dropDownTap(_ sender: UIView) {
        print("drop down select row \(dropDown.indexForSelectedRow)")
        dropDown.show()
    }
}
