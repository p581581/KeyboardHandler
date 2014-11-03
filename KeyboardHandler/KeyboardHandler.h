//
//  KeyboardHandler.h
//  Erdo Test
//
//  Created by 581 on 2014/8/21.
//  Copyright (c) 2014年 Erdo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KeyboardHandler : NSObject<UITextFieldDelegate>

+ (KeyboardHandler *) handleWithViewController:(UIViewController *) vc textFields: (NSArray *)textFields;
- (void) addTextField: (UITextField *) textField;

@end