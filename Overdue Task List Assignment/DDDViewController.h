//
//  DDDViewController.h
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DDDAddTaskViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender;
@end
