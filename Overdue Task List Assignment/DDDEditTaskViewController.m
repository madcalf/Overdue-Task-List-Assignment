//
//  DDDEditTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import "DDDEditTaskViewController.h"

@interface DDDEditTaskViewController ()
@property (nonatomic) CGColorRef defaultBorderColor;
@property (nonatomic) CGColorRef hiliteBorderColor;

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
    self.dateTextField.delegate = self;
    
    // NOTE: the border manipulating code and related delegate and helper methods are duplicates from AddTaskViewController. Would love to find a way to refactor so that we're not copying code this way. Maybe some kind of subclass...?
    
    // Note borders use CGColor not UIColor!
    self.defaultBorderColor = [[UIColor colorWithCGColor:self.taskNameTextField.layer.borderColor] colorWithAlphaComponent:.2].CGColor;
    self.hiliteBorderColor = self.view.tintColor.CGColor;
    
    // assign border properties to textViews and textFields
    [self setBorder:self.taskNameTextField withColor:self.defaultBorderColor];
    [self setBorder:self.detailTextView withColor:self.defaultBorderColor];
    [self setBorder:self.dateTextField withColor:self.defaultBorderColor];
    
    // replace the keyboard with datePicker as dateTestField's inputView
    self.dateTextField.inputView = self.datePicker;
    // hide the cursor in the dateTextField
    self.dateTextField.tintColor = [UIColor clearColor];
    
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

- (IBAction)dateTextFieldPressed:(UITextField *)sender {
    [self toggleDatePicker];
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    [self updateDateText];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // disable editing the in the date field only
    if (textField == self.dateTextField) {
        return NO;
    } else {
        return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // hilite the border of the active field for feedbackk
    [self setBorder:textField withColor:self.hiliteBorderColor];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    // turn off the hilite
    [self setBorder:textField withColor:self.defaultBorderColor];
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self setBorder:textView withColor:self.hiliteBorderColor];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self setBorder:textView withColor:self.defaultBorderColor];
}

#pragma mark - private / helper methods

-(void)displayTask {
    self.taskNameTextField.text = self.task.taskName;
    self.detailTextView.text = self.task.detail;
    self.datePicker.date = self.task.dueDate;
    [self updateDateText];    
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
