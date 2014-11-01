//
//  KeyboardHandler.m
//  KeyboardHandler demo
//
//  Created by 581 on 2014/8/21.
//  Copyright (c) 2014年 Erdo. All rights reserved.
//

#import "KeyboardHandler.h"

@implementation KeyboardHandler {
    NSArray *_textFields;
    UIViewController *targetVC;
    UIView *editingTextField;
    CGRect keyboardRect;
    NSTimeInterval duration;
    UIViewAnimationOptions curve;
    BOOL isShowUp;
}

+ (KeyboardHandler *) handleWithTextFields: (NSArray *)textFields {
    return [[KeyboardHandler alloc] initWithTextFields:textFields];
}

- (id)initWithTextFields:(NSArray *)textFields
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        for (UITextField* t in textFields) {
            t.delegate = self;
        }
        
        targetVC = [self getVisibleViewController];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        [targetVC.view addGestureRecognizer:singleTap];
        
        _textFields = textFields;
        isShowUp = NO;
    }
    return self;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    isShowUp = NO;
    NSDictionary *info = [notification userInfo];

    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];

    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    
    void (^action)(void) = ^{
        CGFloat offsetY = [[UIScreen mainScreen] bounds].size.height - targetVC.view.frame.size.height;
        CGRect rect = targetVC.view.frame;
        rect.origin.y = offsetY;
        targetVC.view.frame = rect;
    };
    
    [UIView animateWithDuration:duration - 0.0255 delay:0.0 options:curve animations:action completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    
    [self viewWillScroll];
    isShowUp = YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    editingTextField = textField;
    
    if (editingTextField.superview != targetVC.view) {
        editingTextField = targetVC.view;
    }
    
    if (isShowUp == YES) {
        [self viewWillScroll];
    }
}

- (void)viewWillScroll {
    
    CGFloat viewCenterY = editingTextField.center.y;
    CGFloat freeSpaceHeight = targetVC.view.frame.size.height - keyboardRect.size.height; // 352
    CGFloat scrollAmount = freeSpaceHeight / 2.0 - viewCenterY - targetVC.view.frame.origin.y;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:curve animations:
     ^{
         CGRect rect = targetVC.view.frame;
         rect.origin.y += scrollAmount;
         targetVC.view.frame = rect;
     }
    completion:nil];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)Tap:(id)sender {
    for (UITextField* t in _textFields) {
        [t resignFirstResponder];
    }
}

- (UIViewController *)getVisibleViewController {
    UIViewController *root = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    if ([root isKindOfClass:[UINavigationController class]] ) {
        root = ((UINavigationController*) root).visibleViewController;
    } else if([root isKindOfClass:[UITabBarController class]] ) {
        root = ((UITabBarController*) root).selectedViewController;
    } else if (root.presentedViewController) {
        root = root.presentedViewController;
    }
    
    return root;
}
@end
