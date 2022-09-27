//
//  ContactDetailsViewController.swift
//  Basic Address Book
//
//  Created by Apple on 27/09/2022.
//

import UIKit
import MessageUI

class ContactDetailsViewController: BaseViewController {

    @IBOutlet weak var lblFax: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPostal: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgContact: UIImageView!
    
    var contactDetails = ContactModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView(){
        self.lblName.text = contactDetails.contactName
        self.lblPhone.text = contactDetails.phone
        self.lblCompanyName.text = contactDetails.companyName
        self.lblTitle.text = contactDetails.companyTitle
        self.lblCountry.text = contactDetails.country
        self.lblCity.text = contactDetails.city
        self.lblAddress.text = contactDetails.address
        self.lblPostal.text = contactDetails.postalCode
        self.lblEmail.text = contactDetails.email
        self.lblFax.text = contactDetails.fax
    }
    
    //To Call On Specific Number
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    //To Share Contact
    func shareContact(){
        let text = "\(self.contactDetails.contactName)\n\(self.contactDetails.phone)"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
//Mark:- Button Actions
    @IBAction func actionShare(_ sender: Any) {
        self.shareContact()
    }
   
    @IBAction func actionEmail(_ sender: Any) {
        self.composeEmail()
    }
    @IBAction func actionMessage(_ sender: Any) {
        self.sendMessage()
    }
    @IBAction func actionCall(_ sender: Any) {
        self.callNumber(phoneNumber: contactDetails.phone)
    }
  
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//Mark:- Compose Email and Messages
extension ContactDetailsViewController :MFMailComposeViewControllerDelegate , MFMessageComposeViewControllerDelegate{
  
    func composeEmail(){
        let recipientEmail = self.contactDetails.email
            let subject = ""
            let body = ""
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([recipientEmail])
                mail.setSubject(subject)
                mail.setMessageBody(body, isHTML: false)
                present(mail, animated: true)
            }
            else {
                self.showAlert(title: "", message: "Unable To Send Email Please Try Again Later!")
            }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func sendMessage(){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [contactDetails.phone]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else{
            self.showAlert(title: "", message: "Unable To Send Message Please Try Again Later!")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
