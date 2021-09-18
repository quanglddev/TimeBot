//
//  MissionTVCell.swift
//  TimeBot
//
//  Created by QUANG on 3/13/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import BEMCheckBox
import ChameleonFramework

protocol CheckBoxDelegate {
    func checkBoxDidChange(cell: MissionTVCell, isChecked: Bool)
}

class MissionTVCell: UITableViewCell, BEMCheckBoxDelegate {
    
    //MARK: Outlets
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var cbIsDone: BEMCheckBox!
    @IBOutlet var lblBody: UILabel!
    
    @IBOutlet var seperatorView: UIView!
    @IBOutlet var lblBodyHeightConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    var cbDelegate: CheckBoxDelegate?
    
    var weekCollection = [[Mission]]()
    
    var frameIsAdded = false
    
    let customFont = UIFont(name: "Helvetica", size: 17.0)
    
    class var defaultHeight: CGFloat { get { return 76 } }
    
    var mission: Mission? {
        didSet {
            self.updateUI()
        }
    }
    
    func checkHeight() {
        if let mission = mission {
            lblBody.isHidden = (frame.size.height < heightForView(text: (mission.body!), font: customFont!, width: lblBody.frame.width) + 76)
            //lblBody.isHidden = frame.size.height < height(withConstrainedWidth: lblBody.frame.size.width, font: customFont!) + 76
        }
    }
    
    func watchFrameChanges() {
        if !frameIsAdded {
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            checkHeight()
            frameIsAdded = true
        }
    }
    
    func ignoreFrameChanges() {
        if frameIsAdded {
            removeObserver(self, forKeyPath: "frame")
            frameIsAdded = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    deinit {
        print("deinit called");
        ignoreFrameChanges()
    }
    
    func updateUI() {
        if let mission = mission {
            lblTitle.text = mission.title
            lblTime.text = 0.hourFrom(minuteth: mission.start)
            if let body = mission.body {
                lblBody.text = "\(0.hourFrom(minuteth: mission.start)) - \(0.hourFrom(minuteth: mission.end))\n\n" + body
            }
            else if mission.body?.replacingOccurrences(of: " ", with: "") == "" {
                lblBody.text = "\(0.hourFrom(minuteth: mission.start)) - \(0.hourFrom(minuteth: mission.end))\n\n" + "No description."
            }
            else {
                lblBody.text = "\(0.hourFrom(minuteth: mission.start)) - \(0.hourFrom(minuteth: mission.end))\n\n" + "No description."
            }
            cbIsDone.setOn(mission.isDone, animated: false)
            backgroundColor = mission.color
            lblTitle.textColor = ContrastColorOf(mission.color, returnFlat: false)
            lblTime.textColor = ContrastColorOf(mission.color, returnFlat: false)
            lblBody.textColor = ContrastColorOf(mission.color, returnFlat: false)
            seperatorView.backgroundColor = ContrastColorOf(mission.color, returnFlat: false)
            cbIsDone.onTintColor = ContrastColorOf(mission.color, returnFlat: false)
            cbIsDone.onCheckColor = ContrastColorOf(mission.color, returnFlat: false)
            //cbIsDone.tintColor = ContrastColorOf(mission.color, returnFlat: false)
            cbIsDone.onAnimationType = .oneStroke
            cbIsDone.offAnimationType = .bounce
            
            lblBody.frame = CGRect(x: lblBody.frame.origin.x, y: lblBody.frame.origin.y, width: lblBody.frame.width, height: heightForView(text: mission.body!, font: customFont!, width: lblBody.frame.width))
            lblBody.sizeToFit()
        }
        else {
            
        }
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = "".boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }

    //MARK: Defaults
    override func awakeFromNib() {
        super.awakeFromNib()
        cbIsDone.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        DispatchQueue.main.async {
            self.cbIsDone.setOn(self.cbIsDone.on, animated: true)
            if self.mission != nil {
                self.mission?.isDone = self.cbIsDone.on
                self.cbDelegate?.checkBoxDidChange(cell: self, isChecked: self.cbIsDone.on)
            }
        }
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        //Update Score
    }
}
