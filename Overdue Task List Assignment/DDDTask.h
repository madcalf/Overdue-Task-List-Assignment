//
//  DDDTask.h
//  Overdue Task List Assignment
//
//  Created by DDD on 2013-11-11.
//  Copyright (c) 2013 DDD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TASK_NAME @"taskName"
#define TASK_DUE_DATE @"dueDate"
#define TASK_DETAIL @"detail"

@interface DDDTask : NSObject
@property (strong, nonatomic) NSString *taskName;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSDate *dueDate;
@property (nonatomic) BOOL completed;

-(id) initWithData:(NSDictionary *)aData;
-(BOOL) isOverdue;
-(void) toggleCompleted;
@end
