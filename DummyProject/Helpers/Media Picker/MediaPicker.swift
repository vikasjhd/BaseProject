


import Foundation
import UIKit
import AVFoundation
import Photos
import MobileCoreServices


//MARK:- MEDIA PICKER CLASS



public class MediaPicker : NSObject {
    
    public static let shared = MediaPicker()
    fileprivate var currentVC : UIViewController?
    
    //MARK: - INTERNAL PROPERTIES
    public var imagePickedBlock: ((UIImage) -> Void)?
    public var filePickedBlock: ((URL) -> Void)?
    

    
    //MARK:- ENUM ATTACHMENT TYPE FOR THIS CLASS
    public enum AttachmentType: String{
        case camera, photoLibrary
    }
    
    
    //MARK:- CLASS CONSTANTS
    struct Constants {
        static let actionFileTypeHeading = "Choose File"
        static let actionFileTypeDescription = ""
        static let camera = "Camera"
        static let phoneLibrary = "Photo Library"
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
    }
    
    
    //MARK: - SHOW CAMERA ON A BUTTON ACTION
    public func showCamera(vc: UIViewController , fileSelectionType : FileSelectionType = .ImageAndVideoBoth){
        currentVC = vc
        self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC! , fileSelectionType: fileSelectionType)
    }
   
    // USAGE:-
    // MediaPicker.shared.showCamera(vc: self)
    
    
    //MARK: - SHOW ATTACHMENT ACTION SHEET FOR VARIOUS OPTIONS
    // This function is used to show the attachment sheet for image, video, photo and file.
    
    public func showAttachmentActionSheet(vc: UIViewController  , fileSelectionType : FileSelectionType = .ImageAndVideoBoth) {
        
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!, fileSelectionType: fileSelectionType)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!,  fileSelectionType: fileSelectionType)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
       
        //BELOW FUNCTIONALITY HANDLE ACTION SHEET FOR IPAD AS ACTION SHEET WILL NOT WORK FOR IPAD
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = vc.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.frame.size.height, width: 0, height: 0)
            // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    
    public  func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController, fileSelectionType : FileSelectionType = .ImageAndVideoBoth){
        currentVC = vc
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        
        case .authorized:
            
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera( fileSelectionType: fileSelectionType)
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary( fileSelectionType: fileSelectionType)
            }
            
        case .denied:
            
            print("permission denied")
            showAlert(title: "Alert", message: "Permission Denied , Please Provide Permission From iPhone's Settings")
            
        case .notDetermined:
            
            
            print("Permission Not Determined")
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera(  fileSelectionType: fileSelectionType)
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary( fileSelectionType: fileSelectionType)
                    }
                    
                }else{
                    print("restriced manually")
                    self.showAlert(title: "Alert", message: "Permission Denied , Please Provide Permission From iPhone's Settings")
                }
            }
            
        case .restricted:
            print("permission restricted")
            self.showAlert(title: "Alert", message: "Permission Denied , Please Provide Permission From iPhone's Settings")
        default:
            break
        }
    }
    
    
    
    
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera
    func openCamera(fileSelectionType : FileSelectionType = .ImageAndVideoBoth){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            DispatchQueue.main.async {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.showsCameraControls = true
                var types = [kUTTypeMovie,kUTTypeImage] as [String]
                if fileSelectionType == .ImageOnly {
                    types = [kUTTypeImage] as [String]
                }
                if fileSelectionType == .VideoOnly {
                    types = [kUTTypeVideo] as [String]
                }
                myPickerController.mediaTypes = types
               
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
        else {
            if let vc = currentVC  {
                Toast.show(message: "Camera Not Available !", controller: vc, color: .red)
            }else {
                PrintToConsole("Camera not found in your device .!")
            }
        }
    }
    
    //MARK: - PHOTO PICKER
    //This function is used to open photo library
    func photoLibrary( fileSelectionType : FileSelectionType = .ImageAndVideoBoth){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            DispatchQueue.main.async {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.mediaTypes = [kUTTypeMovie,kUTTypeImage] as [String]
                var types = [kUTTypeMovie,kUTTypeImage] as [String]
                if fileSelectionType == .ImageOnly {
                    types = [kUTTypeImage] as [String]
                }
                if fileSelectionType == .VideoOnly {
                    types = [kUTTypeVideo] as [String]
                }
                myPickerController.mediaTypes = types
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    //MARK: - Alert For Class usage
    public func showAlert(title : String , message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.currentVC?.present(alert , animated: true, completion: nil)
        }
    }
    
    
}


//MARK:- DELETGATE METHOD FOR MEDIA PICKER

extension MediaPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    //MARK:- CANCELLING THE MEDIA PICKER
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- PICKEING IMAGE
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        currentVC?.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.editedImage ] as? UIImage
            {
                self.imagePickedBlock?(image)
            }
            else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.imagePickedBlock?(image)
            }
            else if let mediaUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                self.filePickedBlock?(mediaUrl)
            }
            
            else{
                PrintToConsole("SOMETHING WENT WRONG !")
                
            }
        })
        
    }
}



//USAGE :-

//MediaPicker.shared.showAttachmentActionSheet(vc: self)
//MediaPicker.shared.filePickedBlock  = { someUrl in
//    PrintToConsole("someUrl \(someUrl.absoluteString)")
//}
//MediaPicker.shared.imagePickedBlock = { image in
//  PrintToConsole("some Image \(image)")
//}
