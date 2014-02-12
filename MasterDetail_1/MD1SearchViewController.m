//
//  MD1SearchViewController.m
//  MasterDetail_1
//
//  Created by Dmitry Oreshkin on 1/23/14.
//  Copyright (c) 2014 Dmitry Oreshkin. All rights reserved.
//

#import "MD1CaseSearchData.h"
#import "MD1SimonResponse.h"
#import "MD1SimonSessionHelper.h"
#import "MD1SearchViewController.h"
#import "MD1PlansViewController.h"


MD1SimonSessionHelper *g_SimonSession;


@interface MD1SearchViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *RGO;
@property (weak, nonatomic) IBOutlet UITextField *RGOtext;
@property (weak, nonatomic) IBOutlet UIPickerView *salesRep;
@property (weak, nonatomic) IBOutlet UITextField *salesRepText;
@property (weak, nonatomic) IBOutlet UIDatePicker *from;
@property (weak, nonatomic) IBOutlet UITextField *fromText;
@property (weak, nonatomic) IBOutlet UIDatePicker *to;
@property (weak, nonatomic) IBOutlet UITextField *toText;
@property (weak, nonatomic) IBOutlet UITextField *planNumber;
@property (weak, nonatomic) IBOutlet UITextField *planholder;
@property (weak, nonatomic) IBOutlet UISwitch *matchAnywhere;

@property (nonatomic) NSMutableArray *RGOs;
@property (nonatomic) NSMutableArray *salesReps;

- (IBAction)home:(id)sender;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)clear:(id)sender;

@end

@implementation MD1SearchViewController

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
    self.RGOs = [[NSMutableArray alloc] init];
    self.RGOs[0] = @"Please Select RGO...";
    for(int i = 0; i < g_SimonSession.RGOs.count; i++){
        self.RGOs[i+1] = g_SimonSession.RGOs[i];
    }
    self.RGO.hidden = YES;
    
    self.salesReps = [[NSMutableArray alloc] init];
    self.salesReps[0] = @"Please Select Sales Rep...";
    for(int i = 0; i < g_SimonSession.salesReps.count; i++){
        self.salesReps[i+1] = g_SimonSession.salesReps[i];
    }
    self.salesRep.hidden = YES;
    
    self.from.hidden = YES;
    self.to.hidden = YES;
    
    [self addPickerToTextfield:self.salesRepText picker:self.salesRep action:@selector(salesRepPickerDoneClicked)];
    [self addPickerToTextfield:self.RGOtext picker:self.RGO action:@selector(rgoPickerDoneClicked)];
    [self addPickerToTextfield:self.fromText picker:self.from action:@selector(fromPickerDoneClicked)];
    [self addPickerToTextfield:self.toText picker:self.to action:@selector(toPickerDoneClicked)];
}

- (void) addPickerToTextfield:(UITextField *)text picker:(UIView *)picker action:(SEL)action
{
    [text setInputView:picker];
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:action];
    [barItems addObject:doneBtn];
    [pickerToolbar setItems:barItems animated:YES];

    text.inputAccessoryView = pickerToolbar;
}

- (void)rgoPickerDoneClicked
{
    [self.RGOtext resignFirstResponder];
    self.RGOtext.inputAccessoryView.hidden=YES;
    self.RGO.hidden=YES;
}

- (void)salesRepPickerDoneClicked
{
    [self.salesRepText resignFirstResponder];
    self.salesRepText.inputAccessoryView.hidden=YES;
    self.salesRep.hidden=YES;
}

- (void)fromPickerDoneClicked
{
    [self.fromText resignFirstResponder];
    self.fromText.inputAccessoryView.hidden=YES;
    self.from.hidden = YES;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    self.fromText.text =[df stringFromDate:self.from.date];
}

- (void)toPickerDoneClicked
{
    [self.toText resignFirstResponder];
    self.toText.inputAccessoryView.hidden=YES;
    self.to.hidden = YES;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    self.toText.text =[df stringFromDate:self.to.date];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual:self.RGO]) {
        return self.RGOs.count;
    } else if ([pickerView isEqual:self.salesRep]) {
        return self.salesReps.count;
    } else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([pickerView isEqual:self.RGO]) {
        return self.RGOs[row];
    } else if ([pickerView isEqual:self.salesRep]) {
        return self.salesReps[row];
    } else {
        return nil;
    }
}

#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if([pickerView isEqual:self.RGO]) {
        if(row > 0) {
            NSString *rgo = self.RGOs[row];
            self.RGOtext.text = rgo;
        } else {
            self.RGOtext.text = @"";
        }
    } else if ([pickerView isEqual:self.salesRep]) {
        if(row > 0) {
            NSString *salesRep = self.salesReps[row];
            self.salesRepText.text = salesRep;
        } else {
            self.salesRepText.text = @"";
        }
    } else {
        return;
    }
}

- (IBAction)search:(id)sender
{
}

- (IBAction)home:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)clear:(id)sender
{
    self.planNumber.text = @"";
    self.planholder.text = @"";
    self.matchAnywhere.on = NO;
    [self.salesRep selectRow:0 inComponent:0 animated:NO];
    self.salesRepText.text = @"";
    [self.RGO selectRow:0 inComponent:0 animated:NO];
    self.RGOtext.text = @"";
    self.fromText.text = @"";
    self.toText.text = @"";
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MD1PlansViewController *targetvc =[segue destinationViewController];
    targetvc.resultset = self.resultset;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowPlans"]) {
        BOOL performSegue = NO;
        NSString *error;
        
        NSMutableDictionary *jsonIn = [[NSMutableDictionary alloc] init];
        if([self.planNumber.text length] > 0) {
            jsonIn[CSD_PLN_NR] = self.planNumber.text;
        }
        if([self.planholder.text length] > 0) {
            jsonIn[CSD_PHD_NM] = self.planholder.text;
        }
        if(self.matchAnywhere.on) {
           jsonIn[@"isPHMatch"] = @"true";
        }
        if([self.salesRepText.text length] > 0) {
            NSRange range = [self.salesRepText.text rangeOfString:@" - "];
            if(range.location != NSNotFound) {
                jsonIn[CSD_SALES_REP_CD] = [self.salesRepText.text substringToIndex:range.location];
            }
        }
        if([self.RGOtext.text length] > 0) {
            NSRange range = [self.RGOtext.text rangeOfString:@" - "];
            if(range.location != NSNotFound) {
                jsonIn[CSD_RGO_CD] = [self.RGOtext.text substringToIndex:range.location];
            }
        }
        if([self.fromText.text length] > 0) {
            jsonIn[@"dateFrom"] = self.fromText.text;
        }
        if([self.toText.text length] > 0) {
            jsonIn[@"dateTo"] = self.toText.text;
        }
        
        NSError *nserror;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(jsonIn) options:0 error:&nserror];
        
        if(!nserror) {
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            MD1SimonResponse *response;
            response = [g_SimonSession search:jsonStr];
            
            if (!response.error) {
                NSObject *jsonOut = response.data;
                if(jsonOut) {
                    NSDictionary *jsonDic = (NSDictionary *)jsonOut;
                    NSArray *resultset = [jsonDic objectForKey:@"resultset"];
                    if(resultset) {
                        self.resultset = resultset;
                        performSegue = YES;
                    } else {
                        error = @"Invalid System Response, resultset=(nil)";
                    }
                } else {
                    error = @"Invalid System Response, data=(nil)";
                }
            } else {
                error = response.error;
            }
        } else {
            error = [nserror localizedDescription];
        }
        
        if (!performSegue) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:error
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
        }
       return performSegue;
    }
    
    // by default perform the segue transition
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.RGOtext]) {
        self.RGO.hidden = NO;
        textField.inputAccessoryView.hidden=NO;
    } else if([textField isEqual:self.salesRepText]) {
        self.salesRep.hidden = NO;
        textField.inputAccessoryView.hidden = NO;
    } else if([textField isEqual:self.fromText]) {
        textField.inputAccessoryView.hidden = NO;
        self.from.hidden = NO;
    } else if([textField isEqual:self.toText]) {
        textField.inputAccessoryView.hidden = NO;
        self.to.hidden = NO;
    } else if([textField isEqual:self.planNumber]) {
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (IBAction)datePickerChanged:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    if([sender isEqual:self.from]) {
        self.fromText.text =[df stringFromDate:self.from.date];
    } else if([sender isEqual:self.to]) {
        self.toText.text =[df stringFromDate:self.to.date];
    }
}
@end
