//
//  ViewController.m
//  SimpleImagesLooker
//
//  Created by apple on 16/2/22.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "ViewController.h"
#import "Looker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Looker *looker = [[Looker alloc]initWithFrame:self.view.bounds];
    [looker showImageArray:@[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"6.jpg"]]];
    [self.view addSubview:looker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
