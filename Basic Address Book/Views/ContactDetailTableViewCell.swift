//
//  ContactDetailTableViewCell.swift
//  Basic Address Book
//
//  Created by Apple on 27/09/2022.
//

import UIKit

protocol ContactDetailTableViewCellDelegate : AnyObject{
    func actionMenu(cell : ContactDetailTableViewCell)
}

class ContactDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblName: UILabel!
    weak var delegate : ContactDetailTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(contact : ContactModel){
        self.lblName.text = contact.contactName
        self.lblPhone.text = contact.phone
        self.selectionStyle = .none
    }

    @IBAction func actionMenu(_ sender: Any) {
        delegate?.actionMenu(cell: self)
    }
}
