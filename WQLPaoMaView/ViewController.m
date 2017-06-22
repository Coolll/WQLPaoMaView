//
//  ViewController.m
//  WQLPaoMaView
//
//  Created by WQL on 15/12/28.
//  Copyright © 2015年 WQL. All rights reserved.
//

#import "ViewController.h"
#import "WQLPaoMaView.h"
#import "SecondViewController.h"


@interface ViewController ()
{
    WQLPaoMaView *paoma;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    paoma = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50) withTitle:@"全场卖两块，买啥都两块，两块钱，你买不了吃亏，两块钱，你买不了上当，真正的物有所值。拿啥啥便宜 买啥啥不贵，都两块，买啥都两块，全场卖两块，随便挑，随便选，都两块～～"];
    [self.view addSubview:paoma];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width-100)/2, 200, 100, 50);
    [button addTarget:self action:@selector(stopPaoma:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"停止" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button];
    
    
    UIButton *buttona = [UIButton buttonWithType:UIButtonTypeCustom];
    buttona.frame = CGRectMake((self.view.frame.size.width-100)/2, 300, 100, 50);
    [buttona addTarget:self action:@selector(startPaoMa:) forControlEvents:UIControlEventTouchUpInside];
    [buttona setTitle:@"开始" forState:UIControlStateNormal];
    [buttona setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:buttona];
}

- (void)stopPaoma:(UIButton*)sender
{
    [paoma stop];
}

- (void)startPaoMa:(UIButton*)sender
{
    [paoma start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //跳转的话，把跑马灯停止
    SecondViewController *second = [[SecondViewController alloc]init];
    [paoma stop];
    [self.navigationController pushViewController:second animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [paoma doCustomAnimation];
    [paoma start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
