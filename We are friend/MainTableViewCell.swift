    //
    //  MainTableViewCell.swift
    //  We are friend
    //
    //  Created by おのしょうき on 2023/02/05.
    //

    import UIKit

    class MainTableViewCell: UITableViewCell {
        @IBOutlet var mainBackguround: UIView!
        @IBOutlet var shadowLayer: UIView!
        
        
        @IBOutlet weak var label: UILabel!
        @IBOutlet weak var button1: UIButton!
        @IBOutlet weak var button2: UIButton!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }


        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
    }
class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}
