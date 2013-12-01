//
//  DDDEditTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import "DDDEditTaskViewController.h"

@interface DDDEditTaskViewController ()

@end

@implementation DDDEditTaskViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.taskNameTextField.delegate = self;
    self.detailTextView.delegate = self;
    [self displayTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBarButtonItemPressed:(UIBarButtonItem *)sender {
    // don't think we actually need to pass back the task, cuz self.task is already pointing to the same object in the main VC's tasks array...
    // so just updating the task here is enough cuz everyone is referencing the same copy
    self.task.taskName = self.taskNameTextField.text;
    self.task.detail = self.detailTextView.text;
    self.task.dueDate = self.datePicker.date;

    [self.delegate didEditTask:self.task];
    [self.navigationController popViewControllerAnimated:YES ];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - private / helper methods

-(void)displayTask {
    self.taskNameTextField.text = self.task.taskName;
    self.detailTextView.text = self.task.detail;
    self.datePicker.date = self.task.dueDate;
}


@end
