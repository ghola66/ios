//
//  MD1ProcessInqueryViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 2/10/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1ProcessInqueryViewController.h"

@interface MD1ProcessInqueryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *inquery;

@end

@implementation MD1ProcessInqueryViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
