//
//  myBrainLocationCollector.h
//  locationCollector
//
//  Created by Fadi Kfoury on 9/18/15.
//  Copyright (c) 2015 Fadi Kfoury. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myBrainLocationCollector : NSObject
{
  

    //a block for pending requests/fail to support the retry functionality
    void (^pendingRequestBlock)(void);
    void (^failBlock)(NSString*error);
}

-(void) sendLocationDataToServerWithData:(NSDictionary*) data andFblock:( void(^) (NSString*error)) fBlock andSblock:(void(^)(NSDictionary*response))sBlock;




-(void) quertStockDataWithFBlock:( void(^) (NSString*error)) fBlock andSblock:(void(^)(NSDictionary*response))sBlock;
@end
