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
    return [self initWithData: @{TASK_NAME:@"New Task", TASK_DETAIL:@"", TASK_DUE_DATE: [NSDate date]}];
}

-(id)initWithData:(NSDictionary *)aDict {
    self = [super init];
    if (self) {
        _taskName = aDict[TASK_NAME];
        _detail = aDict[TASK_DETAIL];
        _dueDate = aDict[TASK_DUE_DATE];
//        _completed = [aDict[TASK_COMPLETED] boolValue];
//        if (_completed == nil) _completed = NO;
        if (aDict[TASK_COMPLETED] == nil) {
            _completed = NO;
        } else {
            _completed = [aDict[TASK_COMPLETED] boolValue];
        }
    }
    return self;
}

-(BOOL)isOverdue {
    // compare due date to today's date and return true if this was due in the past
    NSTimeInterval timeTilDueDate = [self.dueDate timeIntervalSinceNow];
    NSLog(@"[DDDTask isOverdue] timeIntervalSinceNow: %f", timeTilDueDate);
    return timeTilDueDate <= 0;
}

-(void)toggleCompleted {
    self.completed = !self.completed;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<DDDTask - taskName: %@  dueDate: %@  completed: %d>", self.taskName, self.dueDate, self.completed ];
}

@end
