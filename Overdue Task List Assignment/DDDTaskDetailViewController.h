//
//  DDDTaskDetailViewController.h
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDDTaskDetailViewControllerDelegate <NSObject>
@required
-(void)didEditTask:(DDDTask *)aTask;
@end

@interface DDDTaskDetailViewController : UIViewController <DDDEditTaskViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *DateLabel;
@property (strong, nonatomic) DDDTask * task;
@property (weak, nonatomic) id delegate;

// Not sure we need this unless we intend to trigger the segue manually
//- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender;
@end