//
//  DDDAddTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDDAddTaskViewControllerDelegate <NSObject>
@required
-(void)didCancel;
-(void)didAddTask:(DDDTask *)aTask;
@end


@interface DDDAddTaskViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id<DDDAddTaskViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

// note these are buttons, not BarButtonItems
- (IBAction)saveButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end
