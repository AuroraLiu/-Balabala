//
//  MessagesController.m
//  BalaSimple
//
//  Created by LebinJiang on 15/3/10.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "MessagesController.h"
#import "Message.h"
#include "LocalMessage.h"
#include "AppDelegate.h"
#include "TextCell.h"
#include "ImageCell.h"

@interface MessagesController()<UIImagePickerControllerDelegate, UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *nagivationItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)addAction:(id)sender;
- (void)fetchAction:(id)sender;
- (void) sendMessage:(NSString*) msg;
- (void) fetchMessage;

@end

@implementation MessagesController{
    NSOperationQueue* queue;
    UIImage* selectedImage;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    if (_messages == nil) {
        _messages = [[NSMutableArray alloc] init];
    }
    [self fetchAction:nil];
//    UIPanGestureRecognizer *recognizer =
//    [[UIPanGestureRecognizer alloc]initWithTarget:self
//                                             action:@selector(fetchAction:)];
//    [self.view addGestureRecognizer:recognizer];
//    self.tableView.tableHeaderView = self.activityIndicator;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void) addTextMessage:(NSString *)message{
    LocalMessage* msg = [[LocalMessage alloc] initWithText:message];
    [self.messages addObject:msg];
    [self.tableView reloadData];
    [self sendMessage:message];
}

- (void) addImageMessage:(UIImage*) image imageURL:(NSURL*) url{
    LocalMessage* msg = [[LocalMessage alloc] initWithImage:image imageURL:url];
    [self.messages addObject:msg];
    [self.tableView reloadData];
    NSLog(@"Send Image!");
}

- (void) sendMessage:(NSString *)msg{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* urlString = [NSString stringWithFormat:@"http://192.168.137.54:8017/balabala/newBala.php?emailAdress=%@&content=%@"
                           , appDelegate.email
                           , msg];
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
             return;
         }else{
             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                 if (httpResponse.statusCode != 200) {
                     return;
                 }
             }
         }
         NSLog(@"Send Msg:%@",msg);
     }];
}

- (void)fetchAction:(id)sender{
    NSLog(@"Fetch Up");
    [self fetchMessage];
}

- (void) fetchMessage{
    [self.activityIndicator startAnimating];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* urlString = [NSString stringWithFormat:@"http://192.168.137.54:8017/balabala/fetchBalas.php?emailAdress=%@"
                           , appDelegate.email];
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
         NSArray *msgs =
         [NSJSONSerialization JSONObjectWithData:data
                                         options:0
                                           error:&jsonParseError];
         if (jsonParseError != nil) {
             return;
         }
         NSLog(@"log response:%@",msgs);
         

         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.activityIndicator stopAnimating];
             [self.messages removeAllObjects];
             for (NSDictionary *msg in msgs) {
                 LocalMessage *localMessage = [[LocalMessage alloc] init];
                 localMessage.tag = MessageTypeText;
                 localMessage.text = [msg valueForKey:@"BalaContent"];
                 if ((NSNull *)localMessage.text == [NSNull null]) {
                    localMessage.tag = MessageTypeImage;
                     
                 }
                 localMessage.email = [msg valueForKey:@"BalerEmail"];
                 
                 if ([msg valueForKey:@"Photo"] != [NSNull null])
                     localMessage.imageURL = [NSURL URLWithString:[msg valueForKey:@"Photo"]];
                 if ([msg valueForKey:@"Portrait"] != [NSNull null]) {
                     localMessage.portriatURL =[NSURL URLWithString: [msg valueForKey:@"Portrait"]];
                 }

                 [self.messages addObject:localMessage];
             }
             [self.tableView reloadData];
         });
     }];
}

- (IBAction)addAction:(id)sender {
    
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"Text",@"Image",@"Camera",@"Fetch",nil];
    
    
    [actionSheet showInView:self.tableView];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %@ (index:%ld)button was tapped.",
          [actionSheet buttonTitleAtIndex:buttonIndex],
          buttonIndex);
    @try {
    switch (buttonIndex) {
        case 0:
        {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Add Message"
                                                               message:@"Enter New Message"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:@"OK",nil];
            theAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [theAlert show];

        }
            break;
        case 1:
        case 2:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.sourceType = (buttonIndex == 1)
//            ? UIImagePickerControllerSourceTypePhotoLibrary
//            : UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

            imagePicker.delegate = self;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

            [self presentViewController:imagePicker animated:YES completion:nil];
        
        }
            break;
        case 3:
        {
            [self fetchAction:nil];
        }
            break;
        default:
            break;
    }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        ;
    }
}


- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (theAlert.alertViewStyle == UIAlertViewStylePlainTextInput && buttonIndex == 1) {
        [self addTextMessage:[theAlert textFieldAtIndex:0].text];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* TextMessageCell = @"TextMessageCell";
    static NSString* ImageMessageCell = @"ImageMessageCell";
    NSString* cellIndentifer = TextMessageCell;
    LocalMessage* msg = self.messages[indexPath.row];
    if(msg.tag == MessageTypeImage){
        cellIndentifer = ImageMessageCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIndentifer];
    
    if (cell == nil) {
        switch (msg.tag) {
            case MessageTypeText:
                cell = [[TextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifer];
                break;
            case MessageTypeImage:
                cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifer];
                break;
            default:
                cell = [[TextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifer];
                break;
        }
    }
    [cell setValue:self forKey:@"messageController"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    UITableViewCell* cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    height = [(NSNumber*)[cell valueForKey:@"height"] doubleValue];
//    LocalMessage* msg = self.messages[indexPath.row];
//    switch (msg.tag) {
//        case MessageTypeText:
//        {
//            TextCell* cell = (TextCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//            height = [cell height];
//        }
//            break;
//        case MessageTypeImage:
//        {
//            ImageCell* cell = (ImageCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//            height = [cell height];
//        }
//            break;
//        default:
//            height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
//            break;
//    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SystemSoundID audioSoundID;
    
    NSString *audioLocalPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:audioLocalPath], &audioSoundID);
    
    AudioServicesPlaySystemSound (audioSoundID);
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    LocalMessage* msg = self.messages[indexPath.row];
    switch (msg.tag) {
        case MessageTypeText:
        {
            cell.textLabel.text = msg.text;
            TextCell* textCell = (TextCell*)cell;
            textCell.message = msg;
        }
            break;
        case MessageTypeImage:
        {
            ImageCell* imageCell = (ImageCell*)cell;
            imageCell.message = msg;
            [imageCell loadImage];
        }
            break;
        default:
            break;
    }
    
}

#pragma mask ImagePicker
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];    
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    selectedImage = image;
//    NSURL* imageURL = [info objectForKey:UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
