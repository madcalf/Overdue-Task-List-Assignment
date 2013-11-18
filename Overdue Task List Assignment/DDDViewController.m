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
        DDDAddTaskViewController *addTaskController = segue.destinationViewController;
        addTaskController.delegate = self;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"--[DDDVC numberOfRowsInSection] rows: %i", [self.tasks count] );
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
    
}

#pragma mark - DDDAddTaskViewControllerDelegate
-(void)didCancel {
    // dismiss the addTaskVC
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask {
    NSLog(@"--[DDDVC didAddTask]");
    [self dismissViewControllerAnimated:YES completion:nil];
    // reload view
    [self.tableView reloadData];
}

#pragma mark - private / helper methods

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
//    NSLog(@"--[DDDVC viewDidLoad]  tasks: %@", self.tasks );
}

-(DDDTask *)taskFromDictionary:(NSDictionary *)aDict {
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
}
@end
