//
//  DDDViewController.m
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import "DDDViewController.h"

@interface DDDViewController ()

@end

@implementation DDDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"--[DDDVC viewDidLoad]  LOADING TASKS...");
	// Do any additional setup after loading the view, typically from a nib.
    
    // assign myself as delegate to listen for tableView messages
    self.tableView.delegate = self;
    // assign myself as the datasource of the tableView also
    self.tableView.dataSource = self;
    [self loadSavedData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// not sure if we need this since the segue happens automatically from the buttonBarItem at the top. Not sure how to set this segue in the storyboard and have it not trigger automatically...
- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"--[DDDVC prepareForSegue] destinationVC: %@", segue.destinationViewController);
    if ([segue.destinationViewController isKindOfClass:[DDDAddTaskViewController class]]) {
        DDDAddTaskViewController *addTaskVC = segue.destinationViewController;
        addTaskVC.delegate = self;
    }
//    else if ([segue.destinationViewController isKindOfClass:[DDDTaskDetailViewController class]]) {
//        DDDTaskDetailViewController *detailVC = segue.destinationViewController;
//        NSLog(@"\t\tSender: %@", sender);
//    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"--[VC numberOfRowsInSection] rows: %i", [self.tasks count] );
    return [self.tasks count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"--[DDDVC cellForRowAtIndexPath]");
    // note we only have one tableView here, so don't have to test which one it is
    
    // grab a new cell
    NSString *cellIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    // grab the corresponding task and display it
    DDDTask *task = self.tasks[indexPath.row];
    [self displayTask:task inTableCell:cell];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // perform segue to detail vieiw
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"--[VC didSelectRowAtIndexPath]  Row %i", indexPath.row );
    DDDTask *task = self.tasks[indexPath.row];
    task.completed = YES;
    [self.tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // just testing this. Needs to return YES if you want to even get the didSelect... message. If you return no, the didSelectRowAtIndexPath message doesn't seem to get sent. Weird... 
    return YES;
}

#pragma mark - DDDAddTaskViewControllerDelegate
-(void)didCancel {
    // dismiss the addTaskVC
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(DDDTask *)aTask {
    NSLog(@"--[VC didAddTask]");
    [self.tasks addObject:aTask];
    [self saveTask:aTask];
    [self dismissViewControllerAnimated:YES completion:nil];
    // reload view so we see any newly added objects
    [self.tableView reloadData];
}

#pragma mark - private / helper methods

-(void)saveTask:(DDDTask *)aTask {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // remember results from NSUserDefaults are not mutable!!
    // get a mutable copy of the saved task list, so it can be modified
    NSMutableArray *storedTasks = [[defaults objectForKey:OVERDUE_TASK_LIST_KEY] mutableCopy];
    // or create one if it doesn't already exits
    if (!storedTasks) storedTasks = [[NSMutableArray alloc]init];
    // add the new task to it
    NSDictionary *taskDictionary = [self taskAsDictionary:aTask];
    [storedTasks addObject:taskDictionary];
    // save our modified array back to NSUserDefaults
    [defaults setObject:storedTasks forKey:OVERDUE_TASK_LIST_KEY];
    [defaults synchronize];
}

//-(void)saveTask:(NSDictionary *)aTask {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    // remember results from NSUserDefaults are not mutable!!
//    // get a mutable copy of the saved task list, so it can be modified
//    NSMutableArray *storedTasks = [[defaults objectForKey:OVERDUE_TASK_LIST_KEY] mutableCopy];
//    // or create one if it doesn't already exits
//    if (!storedTasks) storedTasks = [[NSMutableArray alloc]init];
//    // add the new task to it
//    [storedTasks addObject:aTask];
//    // save our modified array back to NSUserDefaults
//    [defaults setObject:storedTasks forKey:OVERDUE_TASK_LIST_KEY];
//    [defaults synchronize];
//}


-(NSDictionary *)taskAsDictionary:(DDDTask *)aTask {
    //    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // NEED TO ADD OUR COMPLETE STATE TOO. NEED TO CONVERT FROM BOOL TO ??
    // since completed is a bool, need to set it to defaults explicitly, since bool is not propertly list compatible??

    return @{TASK_ID:aTask.taskID, TASK_NAME:aTask.taskName, TASK_DETAIL:aTask.detail, TASK_DUE_DATE: aTask.dueDate, TASK_COMPLETED:[NSNumber numberWithBool:aTask.completed]};
}

-(void)loadSavedData {
    // load tasks from NSDefaults so they can be displayed on the tableView
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *storedTasks = [defaults objectForKey: OVERDUE_TASK_LIST_KEY];
    // create DDDTask objects from loaded dictionaries
    self.tasks = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in storedTasks) {
        //        NSLog(@"Stored task dictionary: %@", dict);
        [self.tasks addObject:[self taskFromDictionary:dict] ];
    }
}

-(DDDTask *)taskFromDictionary:(NSDictionary *)aDict {
    // CHANGE THE Task initializer to accept dictionary instead of individual args
    DDDTask *task = [[DDDTask alloc] initWithID:aDict[TASK_ID] taskName:aDict[TASK_NAME] detail:aDict[TASK_DETAIL] dueDate:aDict[TASK_DUE_DATE]];
    return task;
}

-(void)displayTask:(DDDTask *)aTask inTableCell:(UITableViewCell *)aCell {
    // populate the cell with task data
    aCell.textLabel.text = aTask.taskName;
    // create the formatted date
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    // create a formatted string of our date text using this formatter
    NSString *dateString = [formatter stringFromDate:aTask.dueDate];
    aCell.detailTextLabel.text = dateString;
    // color the background based on task properties
    if ([aTask isOverdue]) {
        aCell.backgroundColor = [UIColor redColor];
    } else if (aTask.completed) {
        aCell.backgroundColor = [UIColor greenColor];
    } else {
        aCell.backgroundColor = [UIColor yellowColor];
    }
}
@end
