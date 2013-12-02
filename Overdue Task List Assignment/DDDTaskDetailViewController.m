//
//  DDDTaskDetailViewController.m
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import "DDDTaskDetailViewController.h"

@interface DDDTaskDetailViewController ()

@end

@implementation DDDTaskDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"--[TaskDetailVC viewDidLoad]  self.task: %@", self.task);
    [super viewDidLoad];
    self.taskNameTextField.delegate = self;
    self.dateTextField.delegate = self;
    
    // hide cursor in all textFields and TextViews
    self.taskNameTextField.tintColor = [UIColor clearColor];
    self.dateTextField.tintColor = [UIColor clearColor];

    // Ok, this is a hacky solution from SO to prevent TextFields from triggering keyboard while still allowing selection/copy pasting. Create a dummy inputView to replace the keyboard. Setting it to nil didn't work.
    // Note this hackery is not needed for detailTextView cuz UITextView has "editable" and "selectable" properties.
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.taskNameTextField.inputView = dummyView;
    self.dateTextField.inputView = dummyView;
    
    [self displayTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DDDEditTaskViewController class]]) {
        DDDEditTaskViewController *editTaskVC = segue.destinationViewController;
        editTaskVC.task = self.task;
        editTaskVC.delegate = self;
    }
}

#pragma mark - DDDEditTaskViewControllerDelegate

- (void)didEditTask:(DDDTask *)aTask {
    NSLog(@"[DDDTaskDetailVC didEditTask] aTask: %@", aTask);
   
    // can simply update self.task here, since this class is referencing the same instances of the tasks that are in the mainVC's array.
    // not sure if this is the expected way to handle this...
    [self displayTask];
    [self.delegate didEditTask:aTask];
}

#pragma mark - UITextFieldDelegate


// NOTE: All of these are attepmpts to disable the keyboard and editing, while allowing the user to still select/copy/paste text. So far none work completely
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // if NO, this disables editing but also kills ability to select/copy/paste
    // return NO;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // prevents all interaction. Does not allow selection/copy/paste
    //    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // none of the fields should be editable in this view. If NO, this preserves the ability to select/copy/paste text.
    // But it still allows the keyboard to display! So still need a solution for that.
    return NO;
}


#pragma mark - private methods

-(void)displayTask {
    self.taskNameTextField.text = self.task.taskName;
    self.detailTextView.text = self.task.detail;
    self.dateTextField.text =  [NSString stringWithFormat:@"Due:   %@", [self formatDate:self.task.dueDate withComponentString:@"EEEMMMdyyyyhhmm"]];
    
    // note the datePicker is hidden now, but we can probably just get rid of it...
    //    self.datePicker.date = self.task.dueDate;
    //    self.dateLabel.text = self.datePicker.dueDate;
}

// this creates a date with the specified date components that still conforms to the user's locale.
-(NSString *)formatDate:(NSDate *)aDate withComponentString:(NSString *)aDateComponents {
    
    // note: options is always 0, as there are no options yet according to the docs.
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:aDateComponents options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatString];
    // create a formatted string of our date text using this formatter
    NSString *dateString = [formatter stringFromDate:aDate];
    return dateString;
}

    
@end