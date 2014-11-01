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
    UIView *targetView;
    UIView *editingTextField;
    CGRect keyboardRect;
    NSTimeInterval duration;
    UIViewAnimationOptions curve;
    BOOL isShowUp;
}

+ (KeyboardHandler *) handleWithView:(UIView *) view textFields: (NSArray *)textFields {
    return [[KeyboardHandler alloc] initWithView:view textFields:textFields];
}

- (id)initWithView:(UIView *) view textFields:(NSArray *)textFields
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        for (UITextField* t in textFields) {
            t.delegate = self;
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [view addGestureRecognizer:singleTap];
        
        targetView = view;
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
        CGFloat offsetY = [[UIScreen mainScreen] bounds].size.height - targetView.frame.size.height;
        CGRect rect = targetView.frame;
        rect.origin.y = offsetY;
        targetView.frame = rect;
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
    
    while (editingTextField.superview != targetView) {
        editingTextField = editingTextField.superview;
    }
    
    if (isShowUp == YES) {
        [self viewWillScroll];
    }
}

- (void)viewWillScroll {
    
    CGFloat keyboardHieght = keyboardRect.size.height;
    CGFloat viewCenterY = editingTextField.center.y;
    CGFloat freeSpaceHeight = targetView.frame.size.height - keyboardRect.size.height;
    CGFloat scrollAmount = freeSpaceHeight / 2.0 - viewCenterY - targetView.frame.origin.y;
    
    if(scrollAmount < -keyboardHieght) scrollAmount = -keyboardHieght;
    if (targetView.frame.origin.y + scrollAmount <= -keyboardHieght && scrollAmount < 0) {
        scrollAmount = -keyboardHieght - targetView.frame.origin.y;
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:curve animations:
     ^{
         CGRect rect = targetView.frame;
         rect.origin.y += scrollAmount;
         targetView.frame = rect;
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

- (IBAction)singleTap:(id)sender {
    for (UITextField* t in _textFields) {
        [t resignFirstResponder];
    }
}
@end
