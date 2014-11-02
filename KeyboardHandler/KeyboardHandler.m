//
//  KeyboardHandler.m
//  KeyboardHandler demo
//
//  Created by 581 on 2014/8/21.
//  Copyright (c) 2014年 581. All rights reserved.
//

#import "KeyboardHandler.h"

@implementation KeyboardHandler {
    NSMutableArray *_textFields;
    UIView *targetView;
    UIView *editingTextField;
    CGRect keyboardRect;
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
        _textFields = [NSMutableArray arrayWithArray:textFields];
        isShowUp = NO;
    }
    return self;
}

- (void) addTextField: (UITextField *) textField {
    textField.delegate = self;
    [_textFields addObject:textField];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    isShowUp = NO;
    NSDictionary *info = [notification userInfo];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    
    CGFloat offsetY = [[UIScreen mainScreen] bounds].size.height - targetView.frame.size.height;
    
    void (^action)(void) = ^{
        CGRect rect = targetView.frame;
        rect.origin.y = offsetY;
        targetView.frame = rect;
    };
    
    [UIView animateWithDuration: 0.0008 * fabsf(offsetY) delay:0.0 options:curve animations:action completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
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
    CGFloat targetViewHieght = targetView.frame.size.height;
    
    CGFloat targetViewY = targetView.frame.origin.y;
    CGFloat offsetY = [[UIScreen mainScreen] bounds].size.height - targetViewHieght;
    
    CGFloat freeSpaceHeight = targetViewHieght - keyboardHieght;
    CGFloat scrollAmount = freeSpaceHeight / 2.0 - editingTextField.center.y - targetViewY;
    
    if(scrollAmount < -keyboardHieght) {
        scrollAmount = -keyboardHieght;
    } else if (targetViewY - offsetY + scrollAmount < -keyboardHieght && scrollAmount < 0) {
        scrollAmount = -keyboardHieght - targetViewY + offsetY;
    } else if ( targetViewY - offsetY + scrollAmount > 0 && scrollAmount > 0) {
        scrollAmount = offsetY - targetViewY;
    }
    
    [UIView animateWithDuration:0.0008 * fabsf(scrollAmount) delay:0.0 options:curve animations:
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
