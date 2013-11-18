//
//  DDDTask.m
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import "DDDTask.h"

@implementation DDDTask

// default init with no args
-(id)init {
   return [self initWithTaskName:@"Default task" detail:@"" dueDate:[NSDate date]];
}

// creates new task, assigning a unique ID
- (id)initWithTaskName:(NSString *)aTaskName detail:(NSString *)aDetail dueDate:(NSDate *)aDate {
    // create a unique id using the date in seconds
    // Note NSTimeInterval is really double, so don't use a pointer
    NSTimeInterval dateSeconds = [[NSDate date] timeIntervalSince1970];
//    NSString *taskID = [NSString stringWithFormat:@"%i", (int)round(dateSeconds)];
    NSNumber *taskID = [NSNumber numberWithDouble:dateSeconds];
    return [self initWithID:taskID taskName:aTaskName detail:aDetail dueDate:aDate];
}

// Main initializer. Creates a new task object using the specified ID
-(id)initWithID:(NSNumber *)aID taskName:(NSString *)aName detail:(NSString *)aDetail dueDate:(NSDate *)aDate {
    self = [super init];
    if (self) {
        // can't use the taskID getter since the property is read only, so use the instance var here
        _taskID = aID;
        _taskName = aName;
        _detail = aDetail;
        _dueDate = aDate;
        
        // not sure why an instance var for the BOOL doesn't autofill here as the others do...
        self.isCompleted = NO;        
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<DDDTask - taskID: %@  taskName: %@  dueDate: %@>", self.taskID, self.taskName, self.dueDate ];
}

@end
