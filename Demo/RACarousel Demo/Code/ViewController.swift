//
//  ViewController.swift
//  RACarousel Demo
//
//  Created by Piotr Suwara on 24/12/18.
//  Copyright © 2018 Piotr Suwara. All rights reserved.
//

import UIKit
import RACarousel

struct ViewControllerConstants {
    public static let buttonCarouselRow = 1
    public static let imageCarouselRow = 2
    public static let containerRows = [2]
    public static let numberOfRows = 3
    public static let buttonsViewCellIdentifier = "ButtonsViewCellIdentifier"
    public static let imageViewCellIdentifier  = "ImageViewCellIdentifier"
    public static let tableViewCellIdentifier = "UITableViewCell"
    public static let buttonsCarouselCellRowHeight: CGFloat = 200.0
    public static let imageCarouselCellRowHeight: CGFloat = 300.0
    public static let normalCellRowHeight: CGFloat = 50.0
    public static let topRowMargin: CGFloat = 0.6
    public static let gradientColors: [UIColor] = [
        UIColor(red: 53/255, green: 136/255, blue: 206/255, alpha: 1),
        UIColor(red: 155/255, green: 211/255, blue: 230/255, alpha: 1)]
}

final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ButtonsCarouselViewCellDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var whiteBottomView: UIView!
    
    var buttonsCarouselViewCell: ButtonsCarouselViewCell?
    var imageCarouselViewCell: ImageCarouselViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        styleViews()
        configureViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientView.layer.sublayers?[0].frame = gradientView.layer.bounds
    }
    
    private func styleViews() {
        // Setup gradient view (cyan -> dark blue)
        gradientView.applyGradient(withColors: ViewControllerConstants.gradientColors)
    }
    
    private func configureViews() {
        configureTableView()
    }
    
    private func configureTableView() {
        // Register custom cell for carousel
        tableView.separatorColor = UIColor.gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        
        tableView.register(UINib(nibName: "ButtonsCarouselViewCell", bundle: nil), forCellReuseIdentifier: ViewControllerConstants.buttonsViewCellIdentifier)
        tableView.register(UINib(nibName: "ImageCarouselViewCell", bundle: nil), forCellReuseIdentifier: ViewControllerConstants.imageViewCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewControllerConstants.tableViewCellIdentifier)
        
        // Setup table view controls
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        //whiteBottomView.isHidden = true
    }

    // MARK: -
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch row {
        case 0:
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.clear
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: tableView.bounds.size.width, bottom: 0.0, right: 0.0)
            return cell
        
        case ViewControllerConstants.buttonCarouselRow:
            let cell: ButtonsCarouselViewCell = tableView.dequeueReusableCell(withIdentifier: ViewControllerConstants.buttonsViewCellIdentifier) as! ButtonsCarouselViewCell
            cell.backgroundColor = UIColor.clear
            
            cell.carousel.panEnabled = false
            cell.carousel.swipeEnabled = true
            cell.delegate = self
            
            buttonsCarouselViewCell = cell
            
            return cell
            
        case ViewControllerConstants.imageCarouselRow:
            let cell: ImageCarouselViewCell = tableView.dequeueReusableCell(withIdentifier: ViewControllerConstants.imageViewCellIdentifier) as! ImageCarouselViewCell
            
            cell.carousel.panEnabled = false
            cell.carousel.swipeEnabled = false
            
            imageCarouselViewCell = cell
            
            return cell
            
        default:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ViewControllerConstants.tableViewCellIdentifier)!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewControllerConstants.numberOfRows
    }
    
    // MARK: -
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.backgroundView = nil
            cell.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            let height = view.bounds.height
            let margin = ViewControllerConstants.topRowMargin * height
            return margin
        case ViewControllerConstants.buttonCarouselRow:
            return ViewControllerConstants.buttonsCarouselCellRowHeight
        case ViewControllerConstants.imageCarouselRow:
            return ViewControllerConstants.imageCarouselCellRowHeight
        default:
            return ViewControllerConstants.normalCellRowHeight
        }
    }
    
    // MARK: -
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        whiteBottomView.frame = CGRect(origin: CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.contentOffset.y + /*scrollView.frame.height*/0), size: whiteBottomView.frame.size)
        let minScale:CGFloat = 1.1
        let maxScale:CGFloat = 2.0
        
        let offset = tableView.contentOffset.y
        let height = tableView.contentSize.height
        
        var scale = (1.0 / height) * offset
        
        scale = scale * (maxScale - minScale)
        scale += minScale
        
        imageView.applyScale(scale)
    }
    
    // MARK: -
    // MARK: ButtonsCarouselViewCell
    
    func buttonCarousel(_ carousel: ButtonsCarouselViewCell, buttonPressed button: UIButton) {
    }
    
    func buttonCarousel(_ carousel: ButtonsCarouselViewCell, willScrollToIndex index: Int) {
        // Pass the message to the image carousel
        imageCarouselViewCell?.carousel.scroll(toItemAtIndex: index, animated: true)
    }
}

