//
//  ViewController.swift
//  人脸识别测试
//
//  Created by Queen_B on 16/10/27.
//  Copyright © 2016年 Queen_B. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var PersonPic: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        PersonPic.image = UIImage.init(named: "123.png")
//        PersonPic.image = UIImage.init(named: "111.png")

        print(PersonPic.frame.size.width)
        
//        detect()
    }
    func detect() {
        guard let personciImage = CIImage(image:PersonPic.image!)else{
            return
        }
        let accuracy = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
        let faceDetector = CIDetector.init(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        // 获得图片的大小
       let ciImageSize = personciImage.extent.size
        
        for face in faces as! [CIFaceFeature]{
            print("Found bounds are\(face.bounds)")
        // 获得imageView的大小
            let IMGViewSize = PersonPic.frame.size
            // 计算图片等比适应imageView时的缩放比例
            let scale = min(IMGViewSize.width / ciImageSize.width, IMGViewSize.height / ciImageSize.height)
            print("屏幕宽:%f,图片View宽:%f,图片宽:%f",UIScreen.main.bounds.size.width,IMGViewSize.width,ciImageSize.width,self.view.frame.size)// 这里屏幕宽是414,但是imgView的宽度是1000,ciimage宽度为408,按imageView的宽度来算缩放比确实算不对.
            // 计算图片的偏移量:imageView的宽度 - 原图按比例缩放后的宽度;然后除以2就是偏移量
            let offsetX = (IMGViewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (IMGViewSize.height - ciImageSize.height * scale) / 2
            // 原图的脸框按比例缩放.计算位置frame.赋值为脸框
            let transformY = CGAffineTransform.init(scaleX: scale, y: scale)
            var  changedF = face.bounds.applying(transformY)
            changedF.origin.y = IMGViewSize.height - offsetY - changedF.origin.y - changedF.height
            changedF.origin.x += offsetX
            
            let faceBox = UIView.init(frame: changedF)
            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.red.cgColor
            faceBox.backgroundColor = UIColor.clear
            PersonPic.addSubview(faceBox)
            
            if face.hasLeftEyePosition {
                print("left eye bounds are \(face.leftEyePosition)")
            }
            if face.hasRightEyePosition {
                print("right eye bounds are \(face.rightEyePosition)")
            }
        }
    }
    override func viewDidLayoutSubviews() {
        detect()
        print("******\(PersonPic.frame.size.width)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

