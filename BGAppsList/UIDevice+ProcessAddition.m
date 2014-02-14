//
//  UIDevice+ProcessAddition.m
//  BGAppsList
//
//  Created by Jayaprada Behera on 15/10/13.
//  Copyright (c) 2013 Webileapps. All rights reserved.
//

#import "UIDevice+ProcessAddition.h"

@implementation UIDevice (ProcessAddition)
- (NSMutableArray*)runningProcesses {

    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i = nprocess - 1; i >= 0; i--){
                    WAProcess *processModel = [[WAProcess alloc] init];
 
                   processModel.processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    processModel.processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    
//                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processModel.processID,processModel.processName, nil]
//                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];
                    
                    [array addObject:processModel];
                }
                
                free(process);
                return array;
            }
        }
    }
    
    return nil;
}
- (NSString *)pathFromProcessID:(NSUInteger)pid {
    
    // First ask the system how big a buffer we should allocate
    int mib[3] = {CTL_KERN, KERN_ARGMAX, 0};
    
    size_t argmaxsize = sizeof(size_t);
    size_t size;
    
    int ret = sysctl(mib, 2, &size, &argmaxsize, NULL, 0);
    
    if (ret != 0) {
        NSLog(@"Error '%s' (%d) getting KERN_ARGMAX", strerror(errno), errno);
        
        return nil;
    }
    
    // Then we can get the path information we actually want
    mib[1] = KERN_PROCARGS2;
    mib[2] = (int)pid;
    
    char *procargv = malloc(size);
    
    ret = sysctl(mib, 3, procargv, &size, NULL, 0);
    
    if (ret != 0) {
        NSLog(@"Error '%s' (%d) for pid %d", strerror(errno), errno, pid);
        
        return nil;
    }
    
    // procargv is actually a data structure.
    // The path is at procargv + sizeof(int)
    NSString *path = [NSString stringWithCString:(procargv + sizeof(int))
                                        encoding:NSASCIIStringEncoding];
    
    free(procargv);
    NSLog(@"%@",path);
    return(path);
}
@end
