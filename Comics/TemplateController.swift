//
//  TemplateController.swift
//  Comics
//
//  Created by Andrey Apet on 15.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreImage
import MobileCoreServices
import RealmSwift
import AVKit
import MediaPlayer


class TemplateController : UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var mainView: UIView!
    
    var currentImage : UIImage!
    var imageViewArr = [UIImageView]()
    var scrollViewArr = [UIScrollView]()
    var indexTemplate : Int?
    var numberAreasInTemplate = 0
    
    let indexLayerButton = 5
    let indexLayerElement = 4
    let indexLauerContent = 3
    let indexLayerBackgroundTemplate = 2
    var imageTempArr = [UIImage]()
    var CurrentFilterForImageArr = [Int:Int]()
    var filtersOfImage = [Int:Array<UIImage?>]()
    var originalImageInImageView = [Int:UIImage]()
    let context = CIContext(options: nil)
    
    var videoViewArr = [AVPlayerViewController]()
    var urlOfVideo = [Int:Any]()
    
    var imageViewOfElementsArr = [UIImageView]()
    var imageinElementArr = [UIImage]()
    var numberOfElements = 100
    var location = CGPoint(x: 0, y: 0)

    var longHeightImageArr = [Int:Bool]()
    
    var pagesArr = [CurrentTemplate]()
    var currentPage = 1
    
    let filters = ["CIPhotoEffectProcess", "CIEdges", "CIHexagonalPixellate", "CIPhotoEffectFade", "CIPhotoEffectNoir", "CIPhotoEffectTransfer", "CILinearToSRGBToneCurve", "CIColorPosterize", "CIUnsharpMask"]
    var _currentFilter = 0
    var currentFilter: Int {
        get { return _currentFilter}
        set {
            if (newValue>filters.count-1) {
                _currentFilter = 0
            } else {
                if (newValue < 0) {
                    _currentFilter = filters.count - 1
                } else {
                    _currentFilter = newValue
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundTemplateImage"))
    }
    
    func clearImageInTemplate(sender: UIButton) {
        let currentTag = (sender.tag)
        imageViewArr[currentTag].image = nil
        sender.removeFromSuperview()
    }
    
    func importPictureOrChangeFilter(sender: UITapGestureRecognizer) {
        let currentTag = sender.view!.tag
        if imageViewArr[currentTag].image == nil {
            let picker = UIImagePickerController()
            picker.view.tag = currentTag
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .photoLibrary                  //PhotoLibrary
            picker.mediaTypes = ["public.image"]
            if indexTemplate! < 12 {
                picker.mediaTypes.append("public.movie")
            }
            present(picker, animated: true, completion: nil)
            } else {
                changeNextFilter(currentTag: currentTag)
            }
    }
    
    func createDelImageButton(currentTag: Int) {
        let x = scrollViewArr[currentTag].frame.origin.x
        let y = scrollViewArr[currentTag].frame.origin.y
        let buttonClearFilter = UIButton()
        buttonClearFilter.tag = currentTag
        buttonClearFilter.frame = CGRect(x: 10+x, y: 10+y, width: 30, height: 30)
        buttonClearFilter.addTarget(self, action: #selector(TemplateController.clearImageInTemplate(sender:)), for: .touchUpInside)
        buttonClearFilter.setImage(UIImage(named: "90"), for: .normal)
        buttonClearFilter.layer.zPosition = 1
        view.addSubview(buttonClearFilter)
    }		
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let currentTag = picker.view.tag
        CurrentFilterForImageArr[currentTag] = 0
        filtersOfImage[currentTag] = [UIImage]()
        for _ in 0...filters.count {
            filtersOfImage[currentTag]?.append(nil)
        }
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType == kUTTypeImage {
            var newImage: UIImage
            if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                newImage = possibleImage
            } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                newImage = possibleImage
            } else {
                return
            }
            currentImage = newImage
            originalImageInImageView[currentTag] = currentImage
            imageViewArr[currentTag].image = currentImage
            scrollViewArr[currentTag].contentSize = newImage.size
            let scrollViewFrame = scrollViewArr[currentTag].frame
            let scaleWidth = scrollViewFrame.size.width / currentImage.size.width
                print("scaleWidth:\(scaleWidth)")
            let scaleHeight = scrollViewFrame.size.height / currentImage.size.height
                print("scaleHeight:\(scaleHeight)")
            let k = max(scaleHeight, scaleWidth)
            
            scrollViewArr[currentTag].minimumZoomScale = 1
            scrollViewArr[currentTag].maximumZoomScale = 10
            scrollViewArr[currentTag].zoomScale = 1
            imageViewArr[currentTag].frame = CGRect(x: 0,y: 0,width: currentImage.size.width * k,height: currentImage.size.height * k)
            
            scrollViewArr[currentTag].setZoomScale(1, animated: false)
            centerScrollViewContents(currentTag: currentTag)
            createDelImageButton(currentTag: currentTag)
            dismiss(animated: true, completion: nil)
        }
        if mediaType == kUTTypeMovie {
            urlOfVideo[currentTag] = (info[UIImagePickerControllerMediaURL])
            let player = AVPlayer(url: (urlOfVideo[currentTag] as! NSURL) as URL)
            videoViewArr[currentTag].player = player
            changeImageViewToVideoPlayerInArea(currentTag: currentTag, isSetVideo: true)
            dismiss(animated: true, completion: nil)
            createClearVideoButton(currentTag: currentTag)
        }
    }
    
    func changeImageViewToVideoPlayerInArea(currentTag: Int, isSetVideo: Bool) {
        videoViewArr[currentTag].view.isHidden = !isSetVideo
        scrollViewArr[currentTag].isHidden = isSetVideo
    }
    
    func createClearVideoButton(currentTag: Int) {
        let buttonClearVideo = UIButton()
        buttonClearVideo.tag = currentTag
        let x = scrollViewArr[currentTag].frame.origin.x
        let y = scrollViewArr[currentTag].frame.origin.y
        buttonClearVideo.frame = CGRect(x: x + 10, y: y + 10, width: 30, height: 30)
        buttonClearVideo.addTarget(self, action: Selector(("clearVideo:")), for: .touchUpInside)
        buttonClearVideo.setImage(#imageLiteral(resourceName: "90"), for: .normal)
        buttonClearVideo.layer.zPosition = 1
        view.addSubview(buttonClearVideo)
    }
    
    func clearVideo(sender: Any) {
        let currentTag = (sender as AnyObject).tag
        changeImageViewToVideoPlayerInArea(currentTag: currentTag!, isSetVideo: false)
        videoViewArr[currentTag!].player = nil
        (sender as AnyObject).removeFromSuperview()
    }
    
    func centerScrollViewContents(currentTag : Int) {
        let boundeSize = scrollViewArr[currentTag].bounds
        var contentsFrame = imageViewArr[currentTag].frame
        if contentsFrame.size.width < boundeSize.width {
            contentsFrame.origin.x = (boundeSize.width - contentsFrame.size.width) / 2
        } else {
            contentsFrame.origin.x = 0
        }
        if contentsFrame.size.height < boundeSize.height {
            contentsFrame.origin.y = (boundeSize.height - contentsFrame.size.height) / 2
        } else {
            contentsFrame.origin.y = 0
        }
        imageViewArr[currentTag].frame = contentsFrame
    }
    
    func scrollViewDidZoom(_scrollView: UIScrollView) {
        centerScrollViewContents(currentTag: _scrollView.tag)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewArr[scrollView.tag]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setParams (segue: UIStoryboardSegue){
        let TempVC = segue.source as? SelectTemplateController
        indexTemplate = (TempVC?.indexTemplate)!
        imageTempArr = (TempVC!.images)
        setTemplateFromJson()
    }
    
    @IBAction func setElement (segue: UIStoryboardSegue) {
        if indexTemplate != nil {
            let ElementsVC = segue.source as? ElementsTemplateController
            let indexElement = (ElementsVC!.indexElement)!
            imageinElementArr = (ElementsVC?.imagesElement)!
            setElements(indexElement: indexElement)
        }
    }
    
    func setElements (indexElement:Int) {
        print("Add Element")
        let imageElementView = UIImageView()
        imageElementView.frame = CGRect(x: 20,y: 20,width: 130,height: 130)
        imageElementView.image = imageinElementArr[indexElement]
        imageElementView.tag = numberOfElements
        imageElementView.isUserInteractionEnabled = true
        imageViewOfElementsArr.append(imageElementView)
        
        if [4, 8, 10, 11, 13, 18, 22].contains(indexElement) {
            longHeightImageArr[numberOfElements] = true
        } else {
            longHeightImageArr[numberOfElements] = false
        }
        numberOfElements += 1
        let textView = UITextView()
        textView.text = "..."
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.frame = CGRect(x: 40, y: 50, width: 40, height: 40)
        textView.isUserInteractionEnabled = true
        textView.delegate = self
        textView.font = UIFont(name: "Bradley Hand", size: 20)
        textView.textAlignment = NSTextAlignment.center
        imageElementView.addSubview(textView)
        view.addSubview(imageElementView)
        if indexElement > 3 {
            textView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > (textView.text?.characters.count)! {
            return false
        }
        print("Range: \(range.location) ,string: \(text.characters.count) ,textfield: \(textView.text?.characters.count)")
        let newLimit = (textView.text?.characters.count)! + text.characters.count - range.length
        if newLimit == 3 {
            textView.frame.size.width = 80
            textView.frame.size.height = 15
            textView.font = UIFont (name: "Bradley Hand", size: 20)
        }
        if newLimit == 6 {
            textView.font = UIFont(name: "Bradley Hand", size: 15)
        }
        if newLimit == 15 {
                textView.frame.size.width = 90
                textView.frame.size.height = 20
                textView.font = UIFont(name: "Bradley Hand", size: 10)
        }
        return newLimit <= 33
    }
    
    var kwidth: CGFloat = 0
    var kheight: CGFloat = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var Tag = touches.first!.view!.tag
        if Tag >= 100 {
            Tag -= 100
            let touch: UITouch! = touches.first! as UITouch
            location = touch.location(in: self.view)
            kwidth = imageViewOfElementsArr[Tag].center.x - location.x
            kheight = imageViewOfElementsArr[Tag].center.y - location.y
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var Tag = touches.first!.view!.tag
        if Tag >= 100 {
            Tag -= 100
            let limit: CGFloat?
            if (self.longHeightImageArr[Tag] == true) {
                limit = 65
            } else {
                limit = 35
            }
            let touch: UITouch! = touches.first! as UITouch
            location = touch.location(in: self.view)
            print(self.view.frame.height)
            print(Tag)
            if location.y + kheight > limit! {
                imageViewOfElementsArr[Tag].center.x = location.x + kwidth
                imageViewOfElementsArr[Tag].center.y = location.y + kheight
            }
            if location.y + kheight > self.view.frame.height {
                imageViewOfElementsArr[Tag].removeFromSuperview()
            }
        }
    }
    
    
    func ChangeFilter(currentTag: Int) -> UIImage {
        currentFilter = CurrentFilterForImageArr[currentTag]! + 1
        if let filteredImage = filtersOfImage[currentTag]![currentFilter] {
            CurrentFilterForImageArr[currentTag] = currentFilter
            return filteredImage
        } else {
            print(currentFilter)
            let inputImage = CIImage(image: originalImageInImageView[currentTag]!)
            let filteredImage = inputImage?.applyingFilter(filters[currentFilter], withInputParameters: nil)
            let renderedImage = context.createCGImage(filteredImage!, from: (filteredImage?.extent)!)
            CurrentFilterForImageArr[currentTag] = currentFilter
            let image =  UIImage(cgImage: renderedImage!)
            filtersOfImage[currentTag]![currentFilter] = image
            return image
        }
    }
    
    func changeNextFilter(currentTag: Int) {
        imageViewArr[currentTag].image = ChangeFilter(currentTag: currentTag)
    }
    
    func clearFilter(sender: UILongPressGestureRecognizer) {
        let currentTag = sender.view?.tag
        imageViewArr[currentTag!].image = originalImageInImageView[currentTag!]
    }
    
    func delArrsAndViewOnReChangeTemplate() {
        for v in view.subviews {
            v.removeFromSuperview()
        }
        filtersOfImage = [Int:Array<UIImage?>]()
        CurrentFilterForImageArr = [Int:Int]()
        imageViewArr = []
        scrollViewArr = []
        imageViewOfElementsArr = []
        numberOfElements = 100
        originalImageInImageView = [Int:UIImage]()
        longHeightImageArr = [Int:Bool]()
        videoViewArr = []
    }
    
    func setTemplateFromJson () {
        delArrsAndViewOnReChangeTemplate()
        let jsonHelper = JSONHelper()
        let json = jsonHelper.getInfoOfTemplateFromJson(indexTemplate: indexTemplate!)
        numberAreasInTemplate = json.count
        for i in 0..<numberAreasInTemplate {
            let imageView = UIImageView()
            let scrollView = UIScrollView()
            let videoView = AVPlayerViewController()
            let selfFrameView = self.view.frame
            let x = CGFloat(json[i]!["x"]!) * selfFrameView.width
            let y = CGFloat(json[i]!["y"]!) * selfFrameView.height
            let width = CGFloat(json[i]!["width"]!) * selfFrameView.width
            let height = CGFloat(json[i]!["height"]!) * selfFrameView.height
            print("Height:\(height)")
            videoView.view.frame = CGRect(x: x, y: y, width: width, height: height)
            videoView.view.isHidden = true
            videoView.view.tag = i
            videoViewArr.append(videoView)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.importPictureOrChangeFilter(sender:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.clearFilter(sender:)))
            scrollView.frame = CGRect(x: x, y: y, width: width, height: height)
            scrollView.delegate = self
            scrollView.tag = i
            scrollViewArr.append(scrollView)
            imageView.isUserInteractionEnabled = true
            imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            imageView.contentMode = UIViewContentMode.scaleToFill
            imageView.addGestureRecognizer(longPressGestureRecognizer)
            imageView.addGestureRecognizer(tapGestureRecognizer)
            imageView.tag = i
            imageViewArr.append(imageView)
            scrollView.addSubview(imageView)
            view.insertSubview(videoView.view, at: indexLauerContent)
            view.insertSubview(scrollView, at: indexLauerContent)
        }
        let imageViewBackground = UIImageView()
        imageViewBackground.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        print("Height2: \(self.view.frame.height)")
        print("Height3: \(view.frame.height)")
        imageViewBackground.image = imageTempArr[indexTemplate!]
        view.addSubview(imageViewBackground)
    }
    
    func saveComicsToDB(nameComics: String) {
        savePageInfo(index: currentPage)
        let comicsDB = ComicsDB()
        for page in pagesArr {
            loadPageInfo(currPage: page)
            if indexTemplate != nil {
                let tempDb = PageDb()
                for i in 0..<numberAreasInTemplate {
                    let area = Area()
                    if isImageArea(indexArea: i) {
                        area.content = UIImagePNGRepresentation(getScreenOfImageViewInArea(indexArea: i)) as NSData?
                        print("SaveImage")
                    } else {
                        if isVideoInArea(indexArea: i) {
                            area.path = saveLocalVideo(localPatch: urlOfVideo[i] as! NSURL)
                            print("SaveVideo")
                        }
                      }
                    tempDb.areas.append(area)
                }
                for i in 0..<imageViewOfElementsArr.count {
                    if imageViewOfElementsArr[i].center.y < self.view.frame.height {
                        let element = Elementdb()
                        element.x = Float(imageViewOfElementsArr[i].frame.origin.x)
                        element.y = Float(imageViewOfElementsArr[i].frame.origin.y)
                        element.content = UIImagePNGRepresentation(getScreenOfElement(indexElement: i)) as NSData?
                        tempDb.elements.append(element)
                    }
                }
                print(indexTemplate!)
                tempDb.indexOfTemplate = indexTemplate!
                comicsDB.pages.append(tempDb)
                }
            }
        comicsDB.nameComics = nameComics
        comicsDB.width = Float(view.frame.width)
        comicsDB.height = Float(view.frame.height)
        let helperDB = ComicsDBHelper()
        helperDB.saveComics(comicsDB: comicsDB)
        clearAfterSave()
        performSegue(withIdentifier: "clearAfterSave", sender: nil)
        indexTemplate = nil
        }
    
     func clearAfterSave() {
        delArrsAndViewOnReChangeTemplate()
        pagesArr = []
        currentPage = 1
        }
    
    @IBAction func saveToDB(segue: UIStoryboardSegue) {
        let alert = UIAlertController(title: "Enter Name", message: "Enter name:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "MyComics"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let name = alert.textFields![0] as UITextField
            self.saveComicsToDB(nameComics: name.text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveLocalVideo (localPatch: NSURL) -> Int {
        let videoID = Int(arc4random_uniform(600)+1)
        let pathDocuments = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let pathVideo = "\(pathDocuments)/\(videoID).MOV"
        let videoData = NSData(contentsOf: localPatch as URL)
        videoData?.write(toFile: pathVideo, atomically: false)
        print(pathVideo)
        return videoID
    }
    
    func getScreenOfImageViewInArea(indexArea: Int) ->UIImage {
        UIGraphicsBeginImageContextWithOptions(scrollViewArr[indexArea].bounds.size, true, UIScreen.main.scale)
        let offset: CGPoint = scrollViewArr[indexArea].contentOffset
        UIGraphicsGetCurrentContext()!.translateBy(x: -offset.x, y: -offset.y);
        scrollViewArr[indexArea].layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func getScreenOfElement(indexElement: Int) -> UIImage {
        UIGraphicsBeginImageContext(imageViewOfElementsArr[indexElement].frame.size)
        imageViewOfElementsArr[indexElement].layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func isVideoInArea(indexArea: Int) -> Bool {
        if videoViewArr[indexArea].view.isHidden == false {
            return true
        } else {
            return false
        }
    }
    
    func isImageArea(indexArea: Int) -> Bool {
        if scrollViewArr[indexArea].isHidden == false {
            return true
        } else {
            return false
        }
    }
    
    func savePageInfo(index: Int) {
        var currPage = CurrentTemplate()
        print(index-1)
        print(pagesArr.count)
        if index - 1 < pagesArr.count {
            currPage = pagesArr[index-1]
        }
        currPage.filtersOfImage = filtersOfImage
        currPage.imageViewArr = imageViewArr
        currPage.imageViewOfElementsArr = imageViewOfElementsArr
        currPage.indexOfTemplate = indexTemplate
        currPage.originalImageInImageView = originalImageInImageView
        currPage.scrollViewArr = scrollViewArr
        currPage.urlOfVideo = urlOfVideo
        currPage.videoViewArr = videoViewArr
        currPage.CurrentFilterForImageArr = CurrentFilterForImageArr
        currPage.numberAreasInTemplate = numberAreasInTemplate
        currPage.numberOfElements = numberOfElements
        
        if index-1<pagesArr.count {
            pagesArr[index-1] = currPage
        } else {
            pagesArr.append(currPage)
        }
    }
    
    func loadPageInfo (currPage:CurrentTemplate) {
        filtersOfImage = currPage.filtersOfImage
        imageViewArr = currPage.imageViewArr
        imageViewOfElementsArr = currPage.imageViewOfElementsArr
        indexTemplate = currPage.indexOfTemplate
        originalImageInImageView = currPage.originalImageInImageView
        scrollViewArr = currPage.scrollViewArr
        urlOfVideo = currPage.urlOfVideo
        videoViewArr = currPage.videoViewArr
        CurrentFilterForImageArr = currPage.CurrentFilterForImageArr
        numberAreasInTemplate = currPage.numberAreasInTemplate!
        numberOfElements = currPage.numberOfElements!
    }
    
    func changePage(index: Int) {
        delArrsAndViewOnReChangeTemplate()
        let currPage = pagesArr[index-1]
        loadPageInfo(currPage: currPage)
        if indexTemplate != nil {
            for i in 0..<numberAreasInTemplate {
                view.addSubview(videoViewArr[i].view)
                view.addSubview(scrollViewArr[i])
                if videoViewArr[i].view.isHidden == false
                {
                    print("\(i): video")
                    createClearVideoButton(currentTag: i)
                }
                if imageViewArr[i].image != nil {
                    print("\(i): photo")
                    createDelImageButton(currentTag: i)
                }
            }
            let imageViewBackGround = UIImageView()
            imageViewBackGround.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            imageViewBackGround.image = imageTempArr[indexTemplate!]
            view.addSubview(imageViewBackGround)
        }
        for i in 0..<numberOfElements-100 {
            if imageViewOfElementsArr[i].center.y <= self.view.frame.height {
                view.addSubview(imageViewOfElementsArr[i])
            }
        }
    }
    
    @IBAction func changeNextPage(segue: UIStoryboardSegue) {
        let handVC = segue.source as? HandlingController
        savePageInfo(index: handVC!.currentPageTemplate - 1)
        delArrsAndViewOnReChangeTemplate()
        if handVC!.currentPageTemplate <= handVC!.maxPagesTemplate {
            changePage(index: (handVC?.currentPageTemplate)!)
        }else {
            indexTemplate = nil
        }
        currentPage = (handVC?.currentPageTemplate)!
    }
    
    @IBAction func changeBackPage(segue: UIStoryboardSegue) {
        let handVC = segue.source as? HandlingController
        savePageInfo(index: handVC!.currentPageTemplate + 1)
        delArrsAndViewOnReChangeTemplate()
        changePage(index: handVC!.currentPageTemplate)
        currentPage = (handVC?.currentPageTemplate)!
    }

}
