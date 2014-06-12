//
//  LostPassViewController.h
//  app
//
//  Created by Joel Oliveira on 17/05/14.
//  Copyright (c) 2014 Notificare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormField.h"
#import "FormButton.h"
#import "InfoLabel.h"

@interface LostPassViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) IBOutlet FormField * email;
@property (nonatomic, strong) IBOutlet FormButton * forgotPassButton;
@property (nonatomic, strong) IBOutlet InfoLabel * infoLabel;

-(IBAction)recoverPassword:(id)sender;

@end
