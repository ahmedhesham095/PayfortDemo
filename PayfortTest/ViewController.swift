//
//  ViewController.swift
//  PayFortDemo
//
//  Created by Holo Technology on 1/23/20.
//  Copyright © 2020 Holo Technology. All rights reserved.
//

import UIKit
class ViewController: UIViewController , PayFortDelegate  {
    var sdktoken = ""
    func sdkResult(_ response: Any!) {
        print(response)
    }
    
    let paycontroller = PayFortController.init(enviroment: KPayFortEnviromentSandBox)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        paycontroller?.hideLoading = false
        paycontroller?.delegate = self
        paycontroller?.isShowResponsePage = true
        paycontroller?.setPayFortCustomViewNib("PayFortView2")

//        let request = NSMutableDictionary.init()
//        request.setValue("1000", forKey: "amount")
//        request.setValue("AUTHORIZATION", forKey: "command")
//        request.setValue("USD", forKey: "currency")
//        request.setValue("email@domain.com", forKey: "customer_email")
//        request.setValue("en", forKey: "language")
//        request.setValue("112233682686", forKey: "merchant_reference")
//        request.setValue("token" , forKey: "sdk_token")
//
//
//        paycontroller?.callPayFort(withRequest: request, currentViewController: self,
//        success: { (requestDic, responeDic) in
//        print("success")
//        },
//        canceled: { (requestDic, responeDic) in
//        print("canceled")
//        },
//        faild: { (requestDic, responeDic, message) in
//        print("faild")
//            print("Alaaa \(responeDic)")
//            print("Alaaa \(message)")
//            print("Alaaa \(requestDic)")
//
//
//        })

        PayfortSevice.requestSdkToken(uuid: paycontroller?.getUDID() ?? "") { (token) in
            self.sdktoken = token as! String
            if self.sdktoken != "" {
                self.ShowPayfort(token: self.sdktoken)
            }
        }

    }

    
    func ShowPayfort( token sdkToken: String) {
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000)
        let merchant_reference = "NWupHCkh1" + "_" + String(format: "%0.2d", currentTime)

        //let user = UserManager.shared.currentUserInfo
        let request = NSMutableDictionary.init()
        // Payfort api :Remember - Before sending the amount value of any transaction
        // you have to multiply the value with the currency decimal code according to ISO code 3.
        let updatedAmount: Float = Float(2750.99)

        request.setValue(updatedAmount*100, forKey: "amount")
        request.setValue("AUTHORIZATION", forKey: "command")//PURCHASE - AUTHORIZATION
        request.setValue("SAR", forKey: "currency")
        request.setValue( "test@chefz.co" , forKey: "customer_email")
        request.setValue("en", forKey: "language")
        request.setValue(merchant_reference, forKey: "merchant_reference")
        request.setValue(sdkToken, forKey: "sdk_token")
        request.setValue("" , forKey: "payment_option")
        request.setValue("" , forKey: "token_name")
        request.setValue("" , forKey: "eci")
        request.setValue("" , forKey: "order_description")
        request.setValue("" , forKey: "customer_ip")
        request.setValue("" , forKey: "customer_name")
        request.setValue("" , forKey: "phone_number")
        request.setValue("" , forKey: "settlement_reference")
        request.setValue("" , forKey: "merchant_extra")
        request.setValue("" , forKey: "merchant_extra1")
        request.setValue("" , forKey: "merchant_extra2")
        request.setValue("" , forKey: "merchant_extra3")
        request.setValue("" , forKey: "merchant_extra4")
        request.setValue("" , forKey: "merchant_extra5")



        DispatchQueue.main.async {

            self.paycontroller?.callPayFort(withRequest: request,
                               currentViewController: self,
                               success: { (_, response) in
                                print("success")
                                print(response)
        }, canceled: { (request, response) in
            print("canceled")
        }, faild: { (requst, response, message) in
            print(request)
            print(message)
            print(response)

        })
        }
//        paycontroller?.callPayFortForApplePay(withRequest: T##NSMutableDictionary!, applePay: T##PKPayment!, currentViewController: T##UIViewController!, success: { ([AnyHashable : Any]?, [AnyHashable : Any]?) in
//
//        }, faild: { ([AnyHashable : Any]?, [AnyHashable : Any]?, String?) in
//
//        })
//
        
    }
    
    
}


