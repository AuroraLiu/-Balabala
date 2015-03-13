//
//  ViewController.m
//  BalaSimple
//
//  Created by LebinJiang on 15/3/10.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import "LaunchViewController.h"
#include "BalaTabBarRootController.h"
#include "AppDelegate.h"

@interface LaunchViewController ()
@property (strong, nonatomic) BalaTabBarRootController* tabController;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)logTouched:(id)sender;
- (IBAction)signTouched:(id)sender;

- (void) logInRequest;
- (void) registerRequest;
- (NSString*) nickName:(NSString*) email;
@end

@implementation LaunchViewController{
    NSOperationQueue *queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logInRequest {
    if (false) {
        self.tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"BalaTabBar"];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.idTextField.text forKey:@"email"];
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.email = self.idTextField.text;
        appDelegate.password = self.passwordTextField.text;
        
        [self presentViewController: self.tabController
                           animated:YES
                         completion:nil];
        return;
    }

    
    
    NSString* urlString = [NSString stringWithFormat:@"http://192.168.137.54:8017/balabala/login.php?emailAdress=%@&password=%@"
                           , self.idTextField.text
                           , self.passwordTextField.text];
    NSLog(@"URL:%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req =
    [[NSMutableURLRequest alloc] initWithURL:url
                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval:30.0];
    [req setHTTPMethod:@"GET"];
//    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    NSDictionary *logInfo = @{@"action":@"logIn" ,
//                              @"id":self.idTextField.text ,
//                              @"password":self.passwordTextField.text};
    
//    if ([NSJSONSerialization isValidJSONObject:logInfo] == NO) {
//        return;
//    }
//    
//    NSError *jsonWriteError = nil;
//    NSData *payload =
//    [NSJSONSerialization dataWithJSONObject:logInfo
//                                    options:NSJSONWritingPrettyPrinted
//                                      error:&jsonWriteError];
//    [req setHTTPBody:payload];
    
    
    if (queue == nil) {
        queue = [[NSOperationQueue alloc] init];
    }
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
     {
         NSLog(@"start handle long response");
         if (connectionError != nil) {
             NSLog(@"Error during log In");
             return;
         }else{
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                 if (httpResponse.statusCode != 200) {
                     return;
                 }
             }
         }
         NSError *jsonParseError = nil;
         NSDictionary *responseDict =
         [NSJSONSerialization JSONObjectWithData:data
                                         options:0
                                           error:&jsonParseError];
         if (jsonParseError != nil) {
             return;
         }
         NSLog(@"log response:%@",responseDict);
         
         NSLog(@"json:%@",responseDict);
         NSString *dStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"dataString:%@",dStr);
         id result = [responseDict valueForKey:@"result"];
         if (result== nil || [(NSNumber*)result intValue] != 0) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alert =
                 [[UIAlertView alloc] initWithTitle:@"Log In Fail"
                                            message:@"The id or password is wrong,please try again!"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil];
                 [alert show];
             });
             return;
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             self.tabController = [self.storyboard instantiateViewControllerWithIdentifier:@"BalaTabBar"];
             AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
             appDelegate.email = self.idTextField.text;
             appDelegate.password = self.passwordTextField.text;
             [self presentViewController: self.tabController
                                animated:YES
                              completion:nil];
         });
     }];
}

- (NSString*) nickName:(NSString *)email{
    NSArray* list = [email componentsSeparatedByString:@"@"];
    return [list objectAtIndex:0];
}

- (void) registerRequest{
    
    NSString* urlString = [NSString stringWithFormat:@"http://192.168.137.54:8017/balabala/register.php?emailAdress=%@&password=%@&nickname=%@"
                           , self.idTextField.text
                           , self.passwordTextField.text
                           , [self nickName:self.idTextField.text]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req =
    [[NSMutableURLRequest alloc] initWithURL:url
                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval:30.0];
    [req setHTTPMethod:@"GET"];
    if (queue == nil) {
        queue = [[NSOperationQueue alloc] init];
    }
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
     {
         if (connectionError != nil) {
             NSLog(@"Error during log In");
         }else{
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                 if (httpResponse.statusCode != 200) {
                     return;
                 }
             }
         }
         NSError *jsonParseError = nil;
         NSDictionary *responseDict =
         [NSJSONSerialization JSONObjectWithData:data
                                         options:0
                                           error:&jsonParseError];

         NSLog(@"regiser response:%@",responseDict);
         
         NSLog(@"json:%@",responseDict);
         NSString *dStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"dataString:%@",dStr);
         if (jsonParseError != nil) {
             return;
         }
         id result = [responseDict valueForKey:@"result"];
         if (result== nil || [(NSNumber*)result intValue] != 0) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alert =
                 [[UIAlertView alloc] initWithTitle:@"Register Fail"
                                            message:@"The id has been used!"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil];
                 [alert show];
             });
             return;
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alert =
             [[UIAlertView alloc] initWithTitle:@""
                                        message:@"Register success!"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
             [alert show];
         });
     }];
    
}

- (IBAction)logTouched:(id)sender {
    NSLog(@"log In with:\nid:%@\npassword:%@"
          , self.idTextField.text
          , self.passwordTextField.text);
    [self logInRequest];
    
}

- (IBAction)signTouched:(id)sender {
    NSLog(@"sign up with:\nid:%@\npassword:%@"
          , self.idTextField.text
          , self.passwordTextField.text);
    [self registerRequest];
}
@end
