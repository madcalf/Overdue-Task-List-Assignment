//
//  DDDTask.h
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TASK_ID @"taskID"
#define TASK_NAME @"taskName"
#define TASK_DUE_DATE @"dueDate"
#define TASK_DETAIL @"detail"

@interface DDDTask : NSObject
@property (strong, nonatomic, readonly) NSNumber *taskID;
@property (strong, nonatomic) NSString *taskName;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSDate *dueDate;
@property (nonatomic) BOOL isCompleted;

// should this return DDTask or id? SpaceObject class returned id.
-(id) initWithTaskName:(NSString *)aTaskName detail:(NSString *)aDetail dueDate:(NSDate *)aDate;

-(id) initWithID:(NSNumber *)aID taskName:(NSString *)aName detail:(NSString *)aDetail dueDate:(NSDate *)aDate;
@end
