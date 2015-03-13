//
//  PeoplesController.m
//  BalaSimple
//
//  Created by LebinJiang on 15/3/10.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import "PeoplesController.h"

@interface PeoplesController()
- (IBAction)addAction:(id)sender;
@end

@implementation PeoplesController

- (void) viewDidLoad{
    if (_friends == nil) {
        _friends = [NSMutableArray array];
    }
}

- (void) addFriend:(NSString *)friend{
    [self.friends addObject:friend];
    [self.tableView reloadData];
}

- (IBAction)addAction:(id)sender {
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Add Friend"
                                                       message:@"Enter Your Friend's email"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
    theAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [theAlert show];
}

- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (theAlert.alertViewStyle == UIAlertViewStylePlainTextInput && buttonIndex == 1) {
        [self addFriend:[theAlert textFieldAtIndex:0].text];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* PeopleCellIdentifier = @"PeopleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             PeopleCellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [[(NSString*)self.friends[indexPath.row] componentsSeparatedByString:@"@"] objectAtIndex:0];
    cell.detailTextLabel.text =  self.friends[indexPath.row];
}


@end
