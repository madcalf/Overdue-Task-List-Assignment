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

@interface DDDTaskDetailViewController : UIViewController <DDDEditTaskViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

#pragma mark - properties
@property (strong, nonatomic) DDDTask * task;
@property (weak, nonatomic) id delegate;

#pragma mark - outlets
@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;

@end