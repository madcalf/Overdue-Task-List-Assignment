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
    self.detailTextView.delegate = self;
    
    // test sliding datePicker
    //    self.taskNameTextField.inputView = self.datePicker;
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
    //    [self saveTask: [self taskAsDictionary:task]];
    // notify delegate of the save
    [self.delegate didAddTask:task];
    [self.detailTextView resignFirstResponder];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    NSLog(@" - [DDDAddTaskVC cancelButtonPressed]");
    // notify delegate that we've canceled
    [self.delegate didCancel];
    [self.detailTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    NSLog(@" - [DDDAddTaskVC shouldChangeTextInRange]");
    if ([text isEqualToString:@"\n"]) {
        [self.detailTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - private / helper methods

-(DDDTask *)newTask {
    DDDTask *task = [[DDDTask alloc]initWithTaskName: self.taskNameTextField.text detail:self.detailTextView.text dueDate:self.datePicker.date];
    NSLog(@"[DDDAddTaskVC newTask] task:%@, %@", task.taskID, task);
    return task;
}

@end
