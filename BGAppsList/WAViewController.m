//
//  WAViewController.m
//  BGAppsList
//
//  Created by Jayaprada Behera on 15/10/13.
//  Copyright (c) 2013 Webileapps. All rights reserved.
//

#import "WAViewController.h"

@interface WAViewController (){
    NSMutableArray *processes;
}

@end

@implementation WAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    processes = [[UIDevice currentDevice] runningProcesses];
    NSLog(@"%@",processes);

    
    UITableView *myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource= self;
    [self.view addSubview:myTableView];
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *apppath =     [[UIDevice currentDevice] pathFromProcessID:[[(WAProcess *)[processes objectAtIndex:indexPath.row] processID] intValue]];
    NSBundle* bundle = [NSBundle bundleWithPath:apppath];
    NSArray *infostmp = [[bundle infoDictionary] objectForKey:@"CFBundleIconFiles"];
    if(infostmp){
        NSString* iconPath = [[NSString alloc] initWithString:[infostmp objectAtIndex:0]];
        UIImage*  icon =[UIImage imageWithContentsOfFile:iconPath];
    cell.imageView.image = icon;
    }

    cell.textLabel.text = [(WAProcess *)[processes objectAtIndex:indexPath.row] processName];
    cell.detailTextLabel.text = [(WAProcess *)[processes objectAtIndex:indexPath.row] processID];
    return cell;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return processes.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int pID = [[(WAProcess *)[processes objectAtIndex:indexPath.row] processID] intValue];
    kill(pID, SIGKILL);
    [processes removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
    


}
/*
 void suspend(int sig) {
 pid_t pid;
 sigset_t mask;
 //mpid is the pgid of this shell.
 tcsetpgrp(STDIN_FILENO, mpid);
 tcsetpgrp(STDOUT_FILENO, mpid);
 sigemptyset(&mask);
 sigaddset(&mask, SIGTSTP);
 sigprocmask(SIG_UNBLOCK, &mask, NULL);
 signal(SIGTSTP, SIG_DFL);
 //active.pid is the pid of the child currently in the fg.
 if (active.pid != 0) {
 kill(active.pid, SIGTSTP);
 }
 else{
 //if this code is being run in the child, child calls SIGTSTP on itself.
 pid = getpid();
 if (pid != 0 && pid != mpid){
 kill(pid, SIGTSTP);
 }
 }
 signal(SIGTSTP, suspend);
 }

 */

/*
 
 NSBundle* bundle = [NSBundle bundleWithPath:apppath];
 NSArray *infostmp = [[bundle infoDictionary] objectForKey:@"CFBundleIconFiles"];
 if(infostmp){
 NSString* iconPath = [[NSString alloc] initWithString:[infostmp objectAtIndex:0]];
 UIImage*  icon =[UIImage imageWithContentsOfFile:iconPath];
 }

 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
