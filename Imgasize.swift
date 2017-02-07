//
//  Imgasize.swift
//  Comics
//
//  Created by Andrey Apet on 19.11.16.
//  Copyright © 2016 Andrey Apet. All rights reserved.
//

import UIKit
import Social
import RealmSwift
import AVKit
import MediaPlayer



class Imagesize: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var editingComicsButton: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
   
    var pagesComics = List<PageDb>()
    var comics = [ComicsDB]()
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var screensOfPages = [UIImage]()
    var currentComicsIndex: Int?
    var videoViewArr = [AVPlayerViewController]()
    
    let imagesOfTemplate = [#imageLiteral(resourceName: "comics1"), #imageLiteral(resourceName: "comics2"), #imageLiteral(resourceName: "comics3"), #imageLiteral(resourceName: "comics4"), #imageLiteral(resourceName: "comics5"), #imageLiteral(resourceName: "comics6"), #imageLiteral(resourceName: "comics7"), #imageLiteral(resourceName: "comics8"), #imageLiteral(resourceName: "comics9"), #imageLiteral(resourceName: "comics10"), #imageLiteral(resourceName: "comics11"), #imageLiteral(resourceName: "comics12"), #imageLiteral(resourceName: "comics14"), #imageLiteral(resourceName: "comics15"), #imageLiteral(resourceName: "comics16"), #imageLiteral(resourceName: "comics17"), #imageLiteral(resourceName: "comics18"), #imageLiteral(resourceName: "Untitled-1")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editingComicsButton.setBackgroundImage(#imageLiteral(resourceName: "editing-edit-icon"), for: .normal)
        navigationItem.title = comics[currentComicsIndex!]["nameComics"] as? String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        print(width)
        print(height)
        configureScrollView()
        configurePageControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.contentSize = CGSize(width: width * CGFloat(pagesComics.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
        let jsonHelper = JSONHelper()
        for i in 0..<pagesComics.count {
            let page = pagesComics[i]
            let pageView = UIView()
            pageView.frame = CGRect(x: CGFloat(i) * scrollView.frame.width, y: 0, width: width, height: height)
            let indexTemplate = page["indexOfTemplate"] as! Int
            let json = jsonHelper.getInfoOfTemplateFromJson(indexTemplate: indexTemplate)
            print(page.areas.count)
            for j in 0..<page.areas.count {
                let area = page.areas[j]
                print(area)
                let x = CGFloat(json[j]!["x"]!) * scrollView.frame.width
                let y = CGFloat(json[j]!["y"]!) * scrollView.frame.height
                print(x)
                let width = CGFloat(json[i]!["width"]!) * scrollView.frame.width
                let height = CGFloat(json[i]!["height"]!) * scrollView.frame.height
                if area["content"] != nil {
                    let imageView = UIImageView()
                    imageView.backgroundColor = UIColor.gray
                    imageView.frame = CGRect(x: x, y: y, width: width, height: height)
                    print(UIImage(data:(area["content"] as! NSData) as Data)?.size as Any)
                    imageView.image = UIImage(data: (area["content"] as! NSData) as Data)
                    pageView.addSubview(imageView)
                }
                if area["path"] as! Int != 0 {
                    let videoView = AVPlayerViewController()
                    videoView.view.frame = CGRect(x: x, y: y, width: width, height: height)
                    let pathDocuments = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                    let pathVideo = "\(pathDocuments)/\(area["path"] as! Int).MOV"
                    let player = AVPlayer(url: NSURL(fileURLWithPath: pathVideo) as URL)
                    videoView.player = player
                    videoViewArr.append(videoView)
                    self.addChildViewController(videoView)
                    let screenImageView = UIImageView()
                    screenImageView.frame = CGRect(x: x, y: y, width: width, height: height)
                    screenImageView.image = makeScreenOfVideo(videURL: NSURL(fileURLWithPath: pathVideo))
                    pageView.addSubview(screenImageView)
                    pageView.addSubview(videoView.view)
                }
            }
            let backgroundImageTemplate = UIImageView()
            backgroundImageTemplate.frame = CGRect(x: 0, y: 0, width: width, height: height)
            backgroundImageTemplate.image = imagesOfTemplate[indexTemplate]
            pageView.addSubview(backgroundImageTemplate)
            for j in 0..<page.elements.count {
                let element = page.elements[j]
                let elemImageView = UIImageView()
                let imageElement = UIImage(data: (element["content"] as! NSData) as Data)
                let x = CGFloat(element["x"] as! Float)
                let y = CGFloat(element["y"] as! Float)
                elemImageView.frame = CGRect(x: x, y: y, width: (imageElement?.size.width)!, height: (imageElement?.size.height)!)
                elemImageView.image = imageElement
                pageView.addSubview(elemImageView)
            }
            let screen = getScreenOfPage(pageView: pageView)
            screensOfPages.append(screen)
            scrollView.addSubview(pageView)
        }
    }
    
    func makeScreenOfVideo(videURL: NSURL) -> UIImage {
        var uiImage = UIImage()
        do {
            let asset = AVURLAsset(url: videURL as URL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            uiImage = UIImage(cgImage: cgImage)
        } catch let Error as NSError {
            print("Error generating: \(Error)")
        }
        return uiImage
    }
    
    func getScreenOfPage(pageView: UIView) -> UIImage {
        hiddenVideoView(hide: true)
        UIGraphicsBeginImageContext(pageView.frame.size)
        pageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageForEditing = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        hiddenVideoView(hide: false)
        return imageForEditing!
    }
    
    func hiddenVideoView(hide: Bool) {
        for videoview in videoViewArr {
            videoview.view.isHidden = hide
        }
    }
    
    func configurePageControl() {
        pageControl.numberOfPages = pagesComics.count
        pageControl.currentPage = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / UIScreen.main.bounds.size.width);
        pageControl.currentPage = Int(currentPage)
    }
    
    @IBAction func changePage2(_ sender: Any) {
        var newFrame = scrollView.frame
        newFrame.origin.x = newFrame.size.width * CGFloat(pageControl.currentPage)
        scrollView.scrollRectToVisible(newFrame, animated: true)
    }
   
    
    @IBAction func shareFB(_ sender: Any) {
        let fbShare = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        for image in screensOfPages {
            fbShare?.add(image)
        }
        self.present(fbShare!, animated: true, completion: nil)
    }

    
    @IBAction func shareTW(_ sender: Any) {
        let twShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        for image in screensOfPages {
            twShare?.add(image)
        }
        self.present(twShare!, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditingImage" {
            let editingVC = segue.destination as! EditingComicsController
            editingVC.images = self.screensOfPages
            editingVC.pageArr = self.pagesComics
            editingVC.comics = self.comics
            editingVC.currentComicsIndex = self.currentComicsIndex
        }
    }
    @IBAction func editingComics(_ sender: Any) {
    }
    
    
}
