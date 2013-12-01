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


- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender {
    if (!self.tableView.editing) {
        [self.tableView setEditing:YES];
        self.reorderBarButtonItem.title = @"Done";
    } else {
        [self.tableView setEditing:NO];
        self.reorderBarButtonItem.title = @"Reorder";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    NSLog(@"--[DDDVC prepareForSegue] destinationVC: %@", segue.destinationViewController);
    
    // currently testing the destinations to determine which segue to prep, but could also test the senders. Does it matter? Pros/Cons of each?
    if ([segue.destinationViewController isKindOfClass:[DDDAddTaskViewController class]]) {
        DDDAddTaskViewController *addTaskVC = segue.destinationViewController;
        addTaskVC.delegate = self;
    } else if ([segue.destinationViewController isKindOfClass:[DDDTaskDetailViewController class]]) {
        DDDTaskDetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *path = sender;
        detailVC.task = self.tasks[path.row];
        detailVC.delegate = self;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    NSLog(@"--[VC numberOfRowsInSection] rows: %i", [self.tasks count] );
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete the data first! Apparently the order matters. I guess deleteRowsAtIndexPath references the array somehow cuz it bugs out if it doesn't match up with the cell deletion. Really not sure how that happens, cuz we never give the tableView a ref to the array, just to the individual objects in it...
        [self.tasks removeObjectAtIndex:indexPath.row];
        
        // delete the table row
        [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        // remove the task from user defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *storedTasks = [[defaults objectForKey:OVERDUE_TASK_LIST_KEY] mutableCopy];
        [storedTasks removeObjectAtIndex:indexPath.row];
        [defaults setObject:storedTasks forKey:OVERDUE_TASK_LIST_KEY];
        [defaults synchronize];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // update the array to match the moved cell
    DDDTask *task = [self.tasks objectAtIndex:sourceIndexPath.row];
    [self.tasks removeObjectAtIndex:sourceIndexPath.row];
    [self.tasks insertObject:task atIndex:destinationIndexPath.row];
    // save the updated array to NSUserDefaults
    [self saveAllTasks];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // perform segue to detail vieiw
    [self performSegueWithIdentifier:@"segueToDetailVC" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"--[VC didSelectRowAtIndexPath]  Row %i", indexPath.row );
    
    DDDTask *task = self.tasks[indexPath.row];
    // update the complete status of the task and store the changes to NSUserDefaults
    [task toggleCompleted];
    [self saveUpdatedTask:indexPath.row];
    // note this just reloads data from the model, not from stored data.
    [self.tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // Needs to return YES if you want to even get the didSelectRowAtIndexPath message. If you return NO, the didSelectRowAtIndexPath message doesn't seem to get sent. Weird...
    return YES;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    // this is the chance to change the actual destination of a moved row if for some reason you don't want to allow the proposed location where the user dragged it to.
    // Just testing this in action:
    //    NSIndexPath *newPath = [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row - 1 inSection:proposedDestinationIndexPath.section];
    //    return newPath;
    return proposedDestinationIndexPath;
}


#pragma mark - DDDAddTaskViewControllerDelegate

-(void)didCancel {
    // dismiss the addTaskVC
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(DDDTask *)aTask {
    //    NSLog(@"--[VC didAddTask]");
    [self.tasks addObject:aTask];
    [self saveTask:aTask];
    [self dismissViewControllerAnimated:YES completion:nil];
    // reload view so we see any newly added objects
    [self.tableView reloadData];
}

#pragma mark - DDDTaskDetailViewControllerDelegate

-(void)didEditTask:(DDDTask *)aTask{
    // just need to save the task array to NSUserDefaults
    // no need to specifically re-update the task in the array cuz it already points to the instance that was editied.
    [self.tableView reloadData];
    [self saveAllTasks];
}

#pragma mark - private / helper methods

-(void)saveTask:(DDDTask *)aTask {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // remember results from NSUserDefaults are not mutable!!
    // get a mutable copy of the saved task list, so it can be modified
    NSMutableArray *storedTaskDictionaries = [[defaults objectForKey:OVERDUE_TASK_LIST_KEY] mutableCopy];
    // or create one if it doesn't already exits
    if (!storedTaskDictionaries) storedTaskDictionaries = [[NSMutableArray alloc]init];
    // add the new task to it
    NSDictionary *taskDictionary = [self taskAsDictionary:aTask];
    [storedTaskDictionaries addObject:taskDictionary];
    // save our modified array back to NSUserDefaults
    [defaults setObject:storedTaskDictionaries forKey:OVERDUE_TASK_LIST_KEY];
    [defaults synchronize];
}

-(void)saveUpdatedTask:(NSInteger)aIndex {
    // resave the task by removing the changed item from defaults and inserting the new one in its place
    DDDTask *task = self.tasks[(NSUInteger)aIndex];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *storedTasks = [[defaults objectForKey:OVERDUE_TASK_LIST_KEY] mutableCopy];
    [storedTasks removeObjectAtIndex: (NSUInteger)aIndex];
    [storedTasks insertObject:[self taskAsDictionary:task] atIndex:(NSUInteger)aIndex];
    [defaults setObject:storedTasks forKey:OVERDUE_TASK_LIST_KEY];
    [defaults synchronize];
}

-(void)saveAllTasks {
    // convert all tasks to dictionaries and overwrite the whole saved array in defaults
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // make new array to overwrite the existing one in NSUserDefaults. Don't need a copy of the existing one.
    NSMutableArray *storedTaskDictionaries = [[NSMutableArray alloc]init];
    for (DDDTask *task in self.tasks) {
        NSDictionary *dict = [self taskAsDictionary:task];
        [storedTaskDictionaries addObject:dict];
    }
    // write the array to NSUserDefaults
    [defaults setObject:storedTaskDictionaries forKey:OVERDUE_TASK_LIST_KEY];
    [defaults synchronize];
}

-(void)clearSavedTasks {
    // just a helper to delete all saved tasks from NSUserDefaults for a clean start
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:OVERDUE_TASK_LIST_KEY];
}

-(NSDictionary *)taskAsDictionary:(DDDTask *)aTask {
    // don't forget to convert the bool to NSNumber since this is for NSUserDefualts!
    return @{TASK_NAME:aTask.taskName, TASK_DETAIL:aTask.detail, TASK_DUE_DATE: aTask.dueDate, TASK_COMPLETED:[NSNumber numberWithBool:aTask.completed]};
}

-(void)loadSavedData {
    // load tasks from NSDefaults so they can be displayed on the tableView
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *storedTasks = [defaults objectForKey: OVERDUE_TASK_LIST_KEY];
    // create DDDTask objects from loaded dictionaries
    self.tasks = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in storedTasks) {
        //        NSLog(@"Loading saved task dictionary: %@", dict);
        [self.tasks addObject:[self taskFromDictionary:dict] ];
    }
}

-(DDDTask *)taskFromDictionary:(NSDictionary *)aDict {
    return [[DDDTask alloc]initWithData:aDict];
}


-(void)displayTask:(DDDTask *)aTask inTableCell:(UITableViewCell *)aCell {
    // populate the TableViewCell with task data
    aCell.textLabel.text = aTask.taskName;
    // create the formatted date. Try a date with day and month names and times.
    NSString *dateComponents = @"EEEMMMddyyyyhhmm";
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatString];
    // create a formatted string of our date text using this formatter
    NSString *dateString = [formatter stringFromDate:aTask.dueDate];
    aCell.detailTextLabel.text = dateString;
    // color the background based on task properties
    if (aTask.completed) {
        aCell.backgroundColor = [UIColor greenColor];
    } else {
        if ([aTask isOverdue]) {
            aCell.backgroundColor = [UIColor redColor];
        } else {
            aCell.backgroundColor = [UIColor yellowColor];
        }
    }
}
@end
