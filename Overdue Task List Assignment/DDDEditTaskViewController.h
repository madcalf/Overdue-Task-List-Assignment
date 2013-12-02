//
//  DDDEditTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DDDEditTaskViewControllerDelegate <NSObject>
@required
//-(void)didCancel;
-(void)didEditTask:(DDDTask *)aTask;
@end

@interface DDDEditTaskViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) DDDTask *task;
@property (weak, nonatomic) id delegate;

#pragma mark - outlets

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;

#pragma mark - actions

- (IBAction)saveBarButtonItemPressed:(UIBarButtonItem *)sender;
- (IBAction)dateTextFieldPressed:(UITextField *)sender;
- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;

@end
