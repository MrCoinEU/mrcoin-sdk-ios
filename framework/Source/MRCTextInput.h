//
//  MRCTextInput.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCTextInput : UITextField <UITextFieldDelegate>

- (IBAction)doneEditing:(id)sender;
- (IBAction)cancelEditing:(id)sender;

@end
