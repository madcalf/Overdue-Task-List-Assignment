//
//  DDDAddTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import "DDDAddTaskViewController.h"

@interface DDDAddTaskViewController ()

@end

@implementation DDDAddTaskViewController

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
    NSLog(@" - [DDDAddTaskVC viewDidLoad]");
    self.taskNameTextField.delegate = self;
    self.detailTextView.delegate = self;
    // NOTE: try to hide the date picker til we need it. Annoying that it's hideous and takes up so much screen space.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    NSLog(@" - [DDDAddTaskVC saveButtonPressed]");
    // make the task then save it to NSUserDefaults
    DDDTask *task = [self newTask];
    // notify delegate of the new task
    [self.delegate didAddTask:task];
    // dismiss the keyboard
    [self.detailTextView resignFirstResponder];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    NSLog(@" - [DDDAddTaskVC cancelButtonPressed]");
    // notify delegate that we've canceled
    [self.delegate didCancel];
    [self.detailTextView resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.detailTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - private / helper methods

-(DDDTask *)newTask {
    NSDictionary *dict = @{TASK_NAME: self.taskNameTextField.text, TASK_DETAIL: self.detailTextView.text, TASK_DUE_DATE: self.datePicker.date};
    DDDTask *task = [[DDDTask alloc]initWithData:dict];
    NSLog(@"[DDDAddTaskVC newTask] task:%@", task);
    return task;
}

@end
