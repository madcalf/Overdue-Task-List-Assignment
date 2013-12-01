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

#pragma mark - private methods

-(void)displayTask {
    self.taskNameTextField.text = self.task.taskName;
    self.detailTextView.text = self.task.detail;
    self.datePicker.date = self.task.dueDate;
//    self.dateLabel.text = self.datePicker.dueDate;
}

    
@end