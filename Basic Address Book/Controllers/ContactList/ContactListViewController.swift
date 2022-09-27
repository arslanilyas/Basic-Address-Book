//
//  ContactListViewController.swift
//  Basic Address Book
//
//  Created by Apple on 27/09/2022.
//

import UIKit
import SWXMLHash

class ContactListViewController: BaseViewController {
    
    @IBOutlet weak var filterDropDown: DropDown!
    @IBOutlet weak var contactSearchBar: UISearchBar!
    @IBOutlet weak var contactTableView: UITableView!
    
    var isDropDown = false
    var contactList = [ContactModel]()
    var allContacts = [ContactModel]()
    var fileName = "contacts.txt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.readFromXmlFile(fileName: "ab")
        self.configureFilterDropDown()
     
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        self.isDropDown = !isDropDown
        if(self.isDropDown){
            self.filterDropDown.showList()
        }
        else{
            self.filterDropDown.hideList()
        }
    }
    @IBAction func actionExport(_ sender: Any) {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("Contacts.JSON")
            do {
                let allText = self.convertToJSON()
                try allText.write(to: fileURL, atomically: true, encoding: .utf8)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let fileURL = dir.appendingPathComponent("Contacts.JSON")
                    let activityItem: URL = fileURL
                    let activityVC = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
                    self.present(activityVC, animated: true, completion: nil)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactViewController") as! AddContactViewController
        vc.delegate = self
        vc.contactList = self.allContacts
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func configureFilterDropDown(){
        self.filterDropDown.optionArray = ["A to Z" , "Z to A"]
        self.filterDropDown.checkMarkEnabled = false
        self.filterDropDown.selectedRowColor = .lightGray
        filterDropDown.didSelect{(selectedText , index ,id) in
            self.isDropDown = false
            if(index == 0){
                self.allContacts = self.allContacts.sorted { $0.contactName.localizedCaseInsensitiveCompare($1.contactName) == ComparisonResult.orderedAscending}
                self.contactList = self.contactList.sorted { $0.contactName.localizedCaseInsensitiveCompare($1.contactName) == ComparisonResult.orderedAscending}
                self.contactTableView.reloadData()
            }
            else{
                self.allContacts = self.allContacts.sorted { $0.contactName.localizedCaseInsensitiveCompare($1.contactName) == ComparisonResult.orderedDescending}
                self.contactList = self.contactList.sorted { $0.contactName.localizedCaseInsensitiveCompare($1.contactName) == ComparisonResult.orderedDescending}
                self.contactTableView.reloadData()
            }
        }
    }
    
    func parseXmlFromData(data : Data){
        let xml = XMLHash.config {
                            config in
                            config.shouldProcessLazily = false
        }.parse(data)
        for elem in xml["AddressBook"]["Contact"].all {
            self.contactList.append(ContactModel(element: elem))
            self.allContacts.append(ContactModel(element: elem))
        }
        self.contactTableView.reloadData()
    }
    
    func convertToXML() -> String{
        var innerXML = ""
        for each in self.allContacts{
            let xml = "<Contact>\n<CustomerID>\(each.customerID)</CustomerID>\n<CompanyName>\(each.companyName)</CompanyName>\n<ContactName>\(each.contactName)</ContactName>\n<ContactTitle>\(each.companyTitle)</ContactTitle>\n<Address>\(each.address)</Address>\n<City>\(each.city)</City>\n<Email>\(each.email)</Email>\n<PostalCode>\(each.postalCode)</PostalCode>\n<Country>\(each.country)</Country>\n<Phone>\(each.phone)</Phone>\n<Fax>\(each.fax)</Fax>\n</Contact>\n"
            innerXML.append(xml)
        }
        let finalXML = "<AddressBook>\n\(innerXML)\n</AddressBook>"
        return finalXML
    }
    
    func convertToJSON() -> String{
        var stringFile = ""
        for contact in self.allContacts{
            let str = "{\"CustomerID\":\"\(contact.customerID)\",\"CompanyName\":\"\(contact.companyName)\",\"ContactTitle\":\"\(contact.companyTitle)\",\"City\":\"\(contact.city)\",\"Email\":\"\(contact.email)\",\"PostalCode\":\"\(contact.postalCode)\",\"Country\":\"\(contact.country)\",\"Phone\":\"\(contact.phone)\",\"Fax\":\"\(contact.fax)\"},"
           
            stringFile.append(str)
            //self.writeFile(verse: each)
        }
        stringFile.removeLast()
        let finalJSON = "{\"AddressBook\" : [\(stringFile)] }"
        return finalJSON
    }
}

//Mark:- File Manager Funions
extension ContactListViewController{
    
    func checkFile(data : Data) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                let fileExists = try fileURL.checkResourceIsReachable()
                if fileExists {
                    print("File exist")
                    if let fileData = try? Data(contentsOf: fileURL){
                        self.parseXmlFromData(data: fileData)
                    }
                } else {
                    print("File does not exist, create it")
                    writeFile(fileURL: fileURL, data: data)
                }
            } catch {
                writeFile(fileURL: fileURL, data: data)
            }
        }
    }
    
    
    func writeFile(fileURL: URL , data : Data) {
        do {
            try data.write(to: fileURL)
            self.parseXmlFromData(data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateDataToFile(){
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                let fileExists = try fileURL.checkResourceIsReachable()
                if fileExists {
                    print("File exist")
                    do {
                        let allText = self.convertToXML()
                        try allText.write(to: fileURL, atomically: true, encoding: .utf8)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
        
                } else {
                    print("File does not exist, create it")
                }
            } catch {
                print("File does not exist, create it")
            }
        }
    }
    
}

extension ContactListViewController : AddContactViewControllerDelegate{
    func actionSaveContact(contact: ContactModel, isForEdit: Bool, index: Int) {
        if(!isForEdit){
            self.contactList.append(contact)
            self.allContacts.append(contact)
        }
        else{
            let contactID = contact.customerID
            self.contactList[index] = contact
            for ind in 0..<self.allContacts.count{
                if(contactID ==  self.allContacts[ind].customerID){
                    self.allContacts[ind] = contact
                    break;
                }
            }
        }
        self.updateDataToFile()
        self.contactTableView.reloadData()
    }
}

// Mark:- XML Parser Methods
extension ContactListViewController{
    func readFromXmlFile(fileName : String){
        if let path = Bundle.main.url(forResource: fileName, withExtension: "xml") {
            if let data = try? Data(contentsOf: path){
                self.checkFile(data: data)
            }
        }
    }
    
    func moveToContactDetails(index : Int){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
        vc.contactDetails = self.contactList[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showDeletePopup(index : Int){
        self.showAlertView(message: "Are you are you want to delete this contact?", title: "", doneButtonTitle: "Yes", doneButtonCompletion: { action in
            self.deleteContact(selectedContact: index)
        }, cancelButtonTitle: "Cancel") { action in
               self.dismiss(animated: true, completion: nil)
       }
    }
    
    
    func deleteContact(selectedContact : Int){
        let contactID = self.contactList[selectedContact].customerID
        self.contactList.remove(at: selectedContact)
        for index in 0..<self.allContacts.count{
            if(contactID ==  self.allContacts[index].customerID){
                self.allContacts.remove(at: index)
                break;
            }
        }
        self.updateDataToFile()
        self.contactTableView.reloadData()
    }
}



// Mark:- TabelView Methods
extension ContactListViewController : UITableViewDelegate , UITableViewDataSource , ContactDetailTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailTableViewCell", for: indexPath) as! ContactDetailTableViewCell
        cell.configureView(contact: self.contactList[indexPath.row])
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moveToContactDetails(index: indexPath.row)
    }
    
    func actionMenu(cell: ContactDetailTableViewCell) {
        let indexPath = self.contactTableView.indexPath(for: cell)
        self.showMenuSheet(index: indexPath!.row)
    }
}



//Mark:- ActionSheet Methods
extension ContactListViewController{
    func showMenuSheet(index : Int){
        let actionSheet = UIAlertController.init(title: self.contactList[index].contactName, message: self.contactList[index].phone, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "View Info", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in

              self.moveToContactDetails(index: index)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Edit", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactViewController") as! AddContactViewController
                vc.delegate = self
                vc.isForEdit = true
                vc.contactData = self.contactList[index]
                vc.selectedIndex = index
                vc.contactList = self.allContacts
                self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (UIAlertAction) in
            self.showDeletePopup(index: index)
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}



//Mark:- Search Methods
extension ContactListViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.contactList = self.allContacts
        self.contactTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            self.contactList = self.allContacts
            
        }
        else{
            self.contactList = self.allContacts.filter({$0.contactName.lowercased().contains(searchText.lowercased())})
        }
        self.contactTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
