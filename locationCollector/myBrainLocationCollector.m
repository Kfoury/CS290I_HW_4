//
//  myBrainLocationCollector.m
//  locationCollector
//
//  Created by Fadi Kfoury on 9/18/15.
//  Copyright (c) 2015 Fadi Kfoury. All rights reserved.
//

#import "myBrainLocationCollector.h"

@implementation myBrainLocationCollector

-(void) sendLocationDataToServerWithData:(NSDictionary*) data andFblock:( void(^) (NSString*error)) fBlock andSblock:(void(^)(NSDictionary*response))sBlock

{
    
    [self initialzeRequestWithURLPath:@"push_location_data_290I" andXbody:data andFBlock:^(NSString *error)
     {
         fBlock(error);
         
     } andSblock:^(NSDictionary *response)
     {
         if ([[response allKeys] containsObject:@"response_int"])
         {
             if ([[response objectForKey:@"response_int"] intValue] > 0) {
                 sBlock(response);
             }
             else
             {
                 fBlock(@"-1");
             }
         }else
         {
             fBlock(@"-1");
         }
         
     } andConnectionCritical:NO andRBlock:nil];
    
    
}
-(void) initialzeRequestWithURLPath:(NSString*) str andXbody:(NSDictionary*) dictionary  andFBlock:( void(^) (NSString*error)) fBlock andSblock:(void(^)(NSDictionary*response))sBlock andConnectionCritical:(BOOL)  isConnectionCritical andRBlock:(void(^) ()  )RBlock
{
    
    
    NSString * baseURL = @"http://fadikf.pythonanywhere.com";
    
    
    NSURL * url = [[NSURL URLWithString: baseURL] URLByAppendingPathComponent:str];
    
    
    NSError * myErrro;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"charset" forHTTPHeaderField:@"utf-8"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&myErrro];
    
    
    NSString * stringOfDataToOutput =   [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&myErrro] encoding:NSUTF8StringEncoding  ];
    
    
    request.timeoutInterval = 1000;
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         if (error != nil)
         {
             
               fBlock(@"-1");
             
             if (isConnectionCritical)
             {
                 
                                //An intersting problem that can be solved pretty easily, thanks to blocks
                 
             }else
             {
                 fBlock(@"-1");
             }
             
           
         }else
         {
             
             
             
             if([data length] >= 1)
             {
                 NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 
                 NSLog([NSString stringWithFormat:@"%@", myString]);
                 NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
                 // Do computations here
                 sBlock(responseDictionary);
                 
                 
             }else
             {
                 fBlock(@"0");
             }
             
             
         }
         
         
     }];
    
    
}



@end
