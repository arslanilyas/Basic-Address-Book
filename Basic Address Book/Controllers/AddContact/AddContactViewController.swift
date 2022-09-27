//
//  AddContactViewController.swift
//  Basic Address Book
//
//  Created by Apple on 27/09/2022.
//

import UIKit

protocol AddContactViewControllerDelegate : AnyObject{
    func actionSaveContact(contact : ContactModel  , isForEdit : Bool , index : Int)
}

class AddContactViewController: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtfFax: UITextField!
    @IBOutlet weak var txtfEmail: UITextField!
    @IBOutlet weak var txtfPostal: UITextField!
    @IBOutlet weak var txtfAddress: UITextField!
    @IBOutlet weak var txtfCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtfTitle: UITextField!
    @IBOutlet weak var txtfCompany: UITextField!
    @IBOutlet weak var txtfPhone: UITextField!
    @IBOutlet weak var txtfName: UITextField!
   
    var contactList = [ContactModel]()
    var contactData = ContactModel()
    var isForEdit = false
    var selectedIndex = 0
    weak var delegate : AddContactViewControllerDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.isForEdit){
            self.configureView()
            self.lblTitle.text = "Edit Contact"
        }
    }
    
    func configureView(){
        self.txtfName.text =  contactData.contactName
        self.txtfPhone.text =  contactData.phone
        self.txtfCompany.text = contactData.companyName
        self.txtfTitle.text =  contactData.companyTitle
        self.txtCountry.text = contactData.country
        self.txtfCity.text = contactData.city
        self.txtfAddress.text = contactData.address
        self.txtfPostal.text = contactData.postalCode
        self.txtfEmail.text = contactData.email
        self.txtfFax.text = contactData.fax
    }
    

    func saveContact(){
        if(!self.isForEdit){
            contactData.customerID = UUID().uuidString
        }
        contactData.contactName = self.txtfName.text ?? ""
        contactData.phone = self.txtfPhone.text ?? ""
        contactData.companyName = self.txtfCompany.text ?? "N/A"
        contactData.companyTitle = self.txtfTitle.text ?? "N/A"
        contactData.country = self.txtCountry.text ?? "N/A"
        contactData.city = self.txtfCity.text ?? "N/A"
        contactData.address = self.txtfAddress.text ?? "N/A"
        contactData.postalCode = self.txtfPostal.text ?? "N/A"
        contactData.email = self.txtfEmail.text ?? "N/A"
        contactData.fax = self.txtfFax.text ?? "N/A"
        
        delegate?.actionSaveContact(contact: contactData, isForEdit: self.isForEdit, index: self.selectedIndex)
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if(self.txtfName.text == ""){
            self.showAlert(title: "", message: "Please Enter Name")
        }
        else if(txtfPhone.text == ""){
            self.showAlert(title: "", message: "Please Enter Number")
        }
        else{
            let isDuplicate = self.contactList.filter({$0.contactName.lowercased() == self.txtfName.text?.lowercased()})
            if(isDuplicate.count > 0 && !isForEdit){
                self.showAlert(title: "", message: "Contact already exists with this name")
            }
            else{
               self.saveContact()
            }
        }
    }
}
