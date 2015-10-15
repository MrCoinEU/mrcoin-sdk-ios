//
//  MRCPhoneViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCPhoneViewController.h"
#import "MRCFormViewController.h"
#import "RMPhoneFormat.h"
#import "MRCPopUpViewController.h"
#import "MRCTextInput.h"
#import "MRCButton.h"
#import "MrCoin.h"
#import "MRCPhoneData.h"

@implementation MRCPhoneViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    _countrySelector.textInputDelegate = self;
    //
    _phoneTextInput.textInputDelegate = self;
    _phoneTextInput.dataType = (MRCInputDataType*)[MRCPhoneData dataType];
    _phoneTextInput.placeholder = @"Your phone number";

    if(self.object){
        _countrySelector.text = [self.object objectForKey:@"country"];
        _phoneTextInput.text = [self.object objectForKey:@"phone"];
    }
    
    if(!_countrySelector.items){
        [[MrCoin api] getCountries:^(NSDictionary *dictionary) {
            [self configureDropdown:dictionary];
        } error:^(NSError *error, MRCAPIErrorType errorType) {
            NSLog(@"%@",error);
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Country selector
- (IBAction)countrySelectorChanged:(id)sender
{
    if(self.countrySelector.selectedRow >= 0){
        // Change country, update API settings
        NSInteger index = self.countrySelector.selectedRow;
        [[MrCoin api] setCountry:[[[MrCoin api] countries] objectAtIndex:index]];
        //
        NSString *prefix = [[[MrCoin api] country] valueForKeyPath:@"attributes.phone_prefix"];
        NSString *countryCode = [[[[MrCoin api] country] valueForKeyPath:@"attributes.code2"] lowercaseString];
        NSLog(@"Country selected: %@",[[MrCoin api] country]);
        
        // Configure validator
        MRCPhoneData* phoneData = (MRCPhoneData*)_phoneTextInput.dataType;
        [phoneData setPrefix:prefix];
//        [phoneData setCountryCode:<#(NSString *)#>]
        
        // Reset text input
        _phoneTextInput.placeholder = [NSString stringWithFormat:@"%@ (Your Phone number) ",prefix];
        _phoneTextInput.text = @"";
        
        // Reset navigation
        _phoneTextInput.enabled = YES;
        self.nextButton.enabled = NO;
    }else{
        _phoneTextInput.enabled = NO;
        self.nextButton.enabled = NO;
    }
}

#pragma mark - Navigation
- (void)nextPage:(id)sender
{
    [self.phoneTextInput endEditing:YES];
    //
    [self showActivityIndicator:NSLocalizedString(@"Sending data to MrCoin...",nil)];
    //
    [[MrCoin api] phone:[_phoneTextInput text] country:[_countrySelector text] success:^(NSDictionary *dictionary) {
        MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
        [popup dismissViewController];
        [[MrCoin settings] setUserPhone:self.phoneTextInput.text];
        [[MrCoin settings] setUserCountry:self.countrySelector.text];
        [super nextPage:self withObject:@{@"phone":_phoneTextInput.text,@"country":_countrySelector.text}];
    } error:^(NSError *error, MRCAPIErrorType errorType) {
        //        [self showErrorPopup:@"Invalid verification code" message:[NSString stringWithFormat:@"Verification code: '%@' is incorrect.",self.codeTextInput.text]];
        //        self.nextButton.enabled = NO;
        //        _codeTextInput.text = @"";
        //        [[self view] setNeedsLayout];

    }];
}
- (void) configureDropdown:(NSDictionary*)dictionary
{
    NSArray *countries = [dictionary objectForKey:@"data"];
    NSMutableArray *names = [NSMutableArray array];
    NSMutableArray *flags = [NSMutableArray array];
    for (NSDictionary *country in countries) {
//            NSLog(@"%@",country);
        [names addObject:[country valueForKeyPath:@"attributes.localized_name"]];
        [flags addObject:[NSString stringWithFormat:@"flags/%@",[[country valueForKeyPath:@"attributes.code2"] lowercaseString]]];
    }
    _countrySelector.items = names;
    _countrySelector.iconItems = flags;
//    [_countrySelector becomeFirstResponder];
}

#pragma mark - Text Input
-(void)textInputStartEditing:(MRCTextInput *)textInput
{
    [super textInputStartEditing:textInput];
}
-(void)textInputFinishedEditing:(MRCTextInput *)textInput
{
    
}
- (void) textInput:(MRCTextInput *)textInput isValid:(BOOL)valid
{
    self.nextButton.enabled = valid;
}


@end
