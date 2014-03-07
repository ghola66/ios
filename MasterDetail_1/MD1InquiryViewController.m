//
//  MD1InquiryViewController.m
//  Workflow
//
//  Created by Dmitry Oreshkin on 2/27/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1InquiryViewController.h"

@interface MD1InquiryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *inquiry;

@property (weak, nonatomic) IBOutlet UILabel *planNumber;
@property (weak, nonatomic) IBOutlet UILabel *sentOn;
@property (weak, nonatomic) IBOutlet UILabel *refNumber;

- (IBAction)done:(id)sender;

@end

@implementation MD1InquiryViewController

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
    self.inquiry.layer.borderColor = [UIColor grayColor].CGColor;
    self.inquiry.layer.borderWidth =  1.0f;
    //self.inquiry.layer.cornerRadius = 5.0f;
    self.inquiry.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
