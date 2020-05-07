//
//  AddTransactionsVC.swift
//  IOU
//
//  Created by Mark Debbane on 5/7/20.
//  Copyright © 2020 IOU. All rights reserved.
//

import UIKit
import ISPageControl

class AddTransPageVC: UIPageViewController {

  var pageControl: ISPageControl?
  private(set) lazy var orderedViewControllers: [UIViewController] = {
    return [self.newViewController(name: "Amount"),
              self.newViewController(name: "Users"),
              self.newViewController(name: "Details"),
              self.newViewController(name: "Confirmation")]
  }()

  private func newViewController(name: String) -> UIViewController {
      return UIStoryboard(name: "Main", bundle: nil) .
        instantiateViewController(withIdentifier: "\(name)VC")
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      dataSource = self
      if let firstViewController = orderedViewControllers.first {
          setViewControllers([firstViewController],
              direction: .forward,
              animated: true,
              completion: nil)
      }
      
      let frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 70, width: UIScreen.main.bounds.width, height: 50)
      pageControl = ISPageControl(frame: frame, numberOfPages: orderedViewControllers.count)
      pageControl?.radius = 6
      pageControl?.padding = 10
      pageControl?.inactiveTintColor = .lightGray
      pageControl?.currentPageTintColor = UIColor.appColor(.highlight) ?? .orange
      pageControl?.borderWidth = 0
      pageControl?.borderColor = UIColor.clear
      self.view.addSubview(pageControl!)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddTransPageVC: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
               return nil
           }
           
          let previousIndex = viewControllerIndex - 1
           
           // User is on the first view controller and swiped left to loop to
           // the last view controller.
           guard previousIndex >= 0 else {
               return orderedViewControllers.last
           }
           
           guard orderedViewControllers.count > previousIndex else {
               return nil
           }
           
           return orderedViewControllers[previousIndex]
    
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      
    guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
         return nil
     }
     
    
     let nextIndex = viewControllerIndex + 1
     let orderedViewControllersCount = orderedViewControllers.count
     
     // User is on the last view controller and swiped right to loop to
     // the first view controller.
     guard orderedViewControllersCount != nextIndex else {
         return orderedViewControllers.first
     }
     
     guard orderedViewControllersCount > nextIndex else {
         return nil
     }
     
     return orderedViewControllers[nextIndex]

  }
  
    
}
