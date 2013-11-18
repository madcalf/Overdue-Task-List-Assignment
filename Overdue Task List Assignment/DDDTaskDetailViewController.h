//
//  DDDTaskDetailViewController.h
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDTaskDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender;
@end
