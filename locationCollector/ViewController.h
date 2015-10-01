//
//  ViewController.h
//  locationCollector
//
//  Created by Fadi Kfoury on 9/4/15.
//  Copyright (c) 2015 Fadi Kfoury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@property (weak, nonatomic) IBOutlet UILabel *lblInfoMain;
@property (weak, nonatomic) IBOutlet UILabel *lblAccelerometer;

@end

