//
//  UIDevice+ProcessAddition.h
//  BGAppsList
//
//  Created by Jayaprada Behera on 15/10/13.
//  Copyright (c) 2013 Webileapps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <sys/sysctl.h>

#import "WAProcess.h"

@interface UIDevice (ProcessAddition)
- (NSMutableArray *)runningProcesses;
- (NSString *)pathFromProcessID:(NSUInteger)pid;
@end
