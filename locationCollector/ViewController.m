//
//  ViewController.m
//  locationCollector
//
//  Created by Fadi Kfoury on 9/4/15.
//  Copyright (c) 2015 Fadi Kfoury. All rights reserved.
//

#import "ViewController.h"
#import "myBrainLocationCollector.h"

@interface ViewController ()

{
    CLLocationManager * myManager;
    
    
    CMMotionManager *motionManager;
    
    float lastLat;
    float lastLong;
    float lastAccX;
    float lastAccY;
    float lastAccZ;
    float batteryLife;
    NSString * groupUniqueID;
    NSString * groupDescription;

    
    NSMutableArray * arrayOfPoints;
    
    BOOL isCurrentlySendingLocationToServer;
    
    myBrainLocationCollector * myBrain;
    
}
@end

@implementation ViewController
@synthesize lblInfo,lblAccelerometer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myManager = [CLLocationManager new];
    myManager.delegate = self;
    
    
    isCurrentlySendingLocationToServer = NO;
    
//Please Customize these two parameters so that data will be seperable in your Data Base
    
    groupUniqueID = @"KFOURY_TAG";
    
    groupDescription = @"Go Bears!!";
    
    
    arrayOfPoints = [NSMutableArray new];
    
    myBrain = [myBrainLocationCollector new];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startLocationMechanismActivated:(id)sender
{
   
  
    if ([myManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [myManager requestAlwaysAuthorization];
    }
    
    [myManager startUpdatingLocation];
    
    
 
    ////Accelerometer
    
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 1;
    
    if ([motionManager isAccelerometerAvailable])
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                lblAccelerometer.text = [NSString stringWithFormat:@"%.2f, %.2f, %.2f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z ];
       
                
                lastAccX = accelerometerData.acceleration.x;
                lastAccY = accelerometerData.acceleration.y;
                lastAccZ = accelerometerData.acceleration.z;
                //add code to push data to server
                
                //HW TO BE CONTINUED
                
                
                
            });
        }];
    } else
        NSLog(@"not active");
    
    /////
    
    
    
    
}


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation * firstLocation = [locations firstObject];
    
    
    lastLat = firstLocation.coordinate.latitude;
    lastLong = firstLocation.coordinate.longitude;
    
    lblInfo.text= [NSString stringWithFormat:@"%f ::: %f",firstLocation.coordinate.latitude,firstLocation.coordinate.longitude];
   
    
    
    //time stamp is missing
    NSDictionary * locationData = @{@"lat":[NSNumber numberWithFloat:lastLat],@"long":[NSNumber numberWithFloat:lastLong],@"acc_x":[NSNumber numberWithFloat:lastAccX],@"acc_y":[NSNumber numberWithFloat:lastAccY],@"acc_z":[NSNumber numberWithFloat:lastAccZ], @"bat":[NSNumber numberWithFloat:batteryLife],@"tag":groupDescription,@"issuer_id":groupUniqueID};
    
    [arrayOfPoints addObject:locationData];
    
    
      [self uploadLocation];
    
}


//-(void) pushLocation
//{
//    
//    
//  
//    
//    [self uploadLocation];
//    
//    
//    
//}

-(void) uploadLocation
{
    //if we are not in the middle of sending something to the server then we initialize the uploadLocationMethod Again
    
    
    if (!isCurrentlySendingLocationToServer)
    
    {
        

        isCurrentlySendingLocationToServer = YES;
   
    if (arrayOfPoints.count > 0)
    {
        
        //push the last point
        
        NSDictionary * pointToBeSent = [arrayOfPoints objectAtIndex:0];
        //if the call succeeds then remove the first 10 objects and try to push again
        
        
        [myBrain sendLocationDataToServerWithData:pointToBeSent andFblock:^(NSString *error) {
            
            UIAlertView * theAlert = [[UIAlertView alloc] initWithTitle:@"Could not transmit data" message:@"Please check your internet connection" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            
            [theAlert show];
            
            
            
        } andSblock:^(NSDictionary *response) {
            [arrayOfPoints removeObjectAtIndex:0];
            
            isCurrentlySendingLocationToServer = NO;
            [self uploadLocation];
            
            
            
            
        }];
        
        
        
        
        
        
        
       
    }else
    {
        isCurrentlySendingLocationToServer = NO;
    }
        
    }
    
}
@end
