//
//  ContactModel.swift
//  Basic Address Book
//
//  Created by Apple on 27/09/2022.
//

import Foundation
import SWXMLHash

class ContactModel{
   
    var customerID : String
    var companyName : String
    var contactName : String
    var companyTitle : String
    var address : String
    var city : String
    var email : String
    var postalCode : String
    var country : String
    var phone : String
    var fax : String
    
    init(){
        self.customerID = ""
        self.companyName = ""
        self.contactName = ""
        self.companyTitle = ""
        self.address = ""
        self.city = ""
        self.email = ""
        self.postalCode = ""
        self.country = ""
        self.phone = ""
        self.fax = ""
    }
    
    convenience init(element : XMLIndexer){
        self.init()
        self.customerID = element["CustomerID"].element?.text ?? ""
        self.companyName = element["CompanyName"].element?.text ?? ""
        self.contactName = element["ContactName"].element?.text ?? ""
        self.companyTitle = element["ContactTitle"].element?.text ?? ""
        self.address = element["Address"].element?.text ?? ""
        self.city = element["City"].element?.text ?? ""
        self.email = element["Email"].element?.text ?? ""
        self.postalCode = element["PostalCode"].element?.text ?? ""
        self.country = element["Country"].element?.text ?? ""
        self.phone = element["Phone"].element?.text ?? ""
        self.fax = element["Fax"].element?.text ?? ""
    }
}
