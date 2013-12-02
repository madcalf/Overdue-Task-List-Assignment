//
//  DDDAddTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import "DDDAddTaskViewController.h"

@interface DDDAddTaskViewController ()
@property (nonatomic) CGColorRef defaultBorderColor;
@property (nonatomic) CGColorRef hiliteBorderColor;

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
    self.dateTextField.delegate = self;

    // base our default color on the default border color of UIextFields
    // Note: for some reason when we apply this border color manually it's darker than the default UITextField color that appears normally. So the alpha channel is a hack to get it lighter.
    // Note borders use CGColor not UIColor!
    self.defaultBorderColor = [[UIColor colorWithCGColor:self.taskNameTextField.layer.borderColor] colorWithAlphaComponent:0.2].CGColor;
    self.hiliteBorderColor = self.view.tintColor.CGColor;
    
    // assign border properties to textViews and textFields
    [self setBorder:self.taskNameTextField withColor:self.defaultBorderColor];
    [self setBorder:self.detailTextView withColor:self.defaultBorderColor];
    [self setBorder:self.dateTextField withColor:self.defaultBorderColor];
 
    // set placeholder text, since you can't do that in the storyboard
    self.detailTextView.text = @"Details";
    self.detailTextView.textColor = [UIColor lightGrayColor];
    
    // Note: Cuz the datePicker takes up so much space, we're now using a textField to display the date. Tapping on this field in Add or Edit Views will toggle a datePicker instead of the keyboard.
    // When not in use the datePicker is hidden from view by setting it's y position off screen (in the storyboard). Simply setting the hidden property resulted in a flicker whenever we first unhide it.
    [self updateDateText];
    [self.dateTextField setInputView:self.datePicker];
    // this hides the cursor! Not sure why it only affects the cursor and not the text tho...
    self.dateTextField.tintColor = [UIColor clearColor];
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


- (IBAction)dateTextFieldPressed:(UITextField *)sender {
    NSLog(@"[AddTaskVC dateTextFieldPressed]  textField.editing: %d", self.dateTextField.editing);
    // toggle the inputView (datePicker) whenever they tap the dateTextField
    [self toggleDatePicker];
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    [self updateDateText];
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"[AddTaskVC textFieldShouldReturn");
    // hide keyboard when return key pressed
    if (textField == self.taskNameTextField) {
        [textField resignFirstResponder];
    } else if (textField == self.dateTextField) {
        // Even tho there's no keyboard with return key in this case, it does catch returns in the simulator, and i assume returns from an external keyboard...
        [self updateDateText];
        [textField resignFirstResponder];
    }
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // disallow editing while still allowing the touch event to trigger the datePicker
    // note this still leaves the cursor visible. Hiding that in TestFieldDidBeginEditing...
    // ultimately a subclass of UITextField would allow a better more complete solution.
    // But just get it working for now...
    if (textField == self.dateTextField) {
        return NO;
    } else {
        return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    NSLog(@"[AddTaskVC didBeginEditing]  textField.editing: %d", textField.editing);
    // change the border just for feedback
//    textField.layer.borderColor = self.view.tintColor.CGColor;
    [self setBorder:textField withColor:self.hiliteBorderColor];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"[AddTaskVC didEndEditing]  textField.editing: %d", textField.editing);
    [self setBorder:textField withColor:self.defaultBorderColor];
    if (textField == self.dateTextField) {
        // catches cases when user taps another control
        [self closeDatePicker];
    }
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // only one textView, so no need test it
    if ([text isEqualToString:@"\n"]) {
        [self.detailTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    // remove placeholder text and set to normal color
    [self setBorder:textView withColor:self.hiliteBorderColor];
    if ([self.detailTextView.text isEqualToString:DETAIL_TEXTFIELD_PLACEHOLDER_TEXT]) {
        [self showDetailViewPlaceholderText:NO];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    // display placehoder text if the field is empty
    [self setBorder:textView withColor:self.defaultBorderColor];
    if (![self.detailTextView hasText]) {
        [self showDetailViewPlaceholderText:YES];
    }
}

#pragma mark - private / helper methods

-(DDDTask *)newTask {
    NSDictionary *dict = @{TASK_NAME: self.taskNameTextField.text, TASK_DETAIL: self.detailTextView.text, TASK_DUE_DATE: self.datePicker.date};
    DDDTask *task = [[DDDTask alloc]initWithData:dict];
    NSLog(@"[DDDAddTaskVC newTask] task:%@", task);
    return task;
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

-(void)toggleDatePicker{
    // toggle the inputView (datePicker) whenever they tap the dateTextField
    if (self.dateTextField.editing) {
        [self updateDateText];
        self.dateTextField.textColor = [UIColor blackColor];
        [self.dateTextField resignFirstResponder];
    } else {
        // The animation of the picker is handled by setting the datePicker as this textFields inputView, so it replaces the keyboard.
        
        // change the textColor as feedback that the date is being edited. Similar to how the Reminders app does it.
        self.dateTextField.textColor = self.view.tintColor;
    }
}

-(void)closeDatePicker {
    // close keyboard and update date and text color
    [self updateDateText];
    self.dateTextField.textColor = [UIColor blackColor];
    [self.dateTextField resignFirstResponder];
}

-(void)updateDateText {
    NSString *formattedDate = [self formatDate:self.datePicker.date withComponentString:@"EEEMMMdyyyyhhmm"];
    self.dateTextField.text = [NSString stringWithFormat:@"Due:   %@", formattedDate];
}

-(void)showDetailViewPlaceholderText:(BOOL)aBool {
    if (aBool) {
        self.detailTextView.Text = DETAIL_TEXTFIELD_PLACEHOLDER_TEXT;
        self.detailTextView.textColor = [UIColor lightGrayColor];
    } else {
        self.detailTextView.Text = @"";
        self.detailTextView.textColor = [UIColor blackColor];
    }
}

-(void)setBorder:(UIView *)aView withColor:(CGColorRef)aColor {
    // weird that even tho UITextFields appear by default with rounded light gray borders, you can't change their borderColor unless you explicitly set a borderWidth. And since we want to keep the rounded style we need to explicitly set the corner radius up too, regardless of the borderStyle set in the storyboard...
    aView.layer.borderWidth = 0.8;
    aView.layer.borderColor = aColor;
    aView.layer.cornerRadius = 5;
}

@end
