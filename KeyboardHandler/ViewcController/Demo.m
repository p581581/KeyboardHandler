//
//  Demo.m
//  KeyboardHandler
//
//  Created by 581 on 2014/11/2.
//  Copyright (c) 2014年 581. All rights reserved.
//

#import "Demo.h"
#import "KeyboardHandler.h"

@interface Demo () {
    KeyboardHandler *keyboardHandler;
}
@property (strong, nonatomic) IBOutlet UITextField *textField1;
@property (strong, nonatomic) IBOutlet UITextField *textField2;
@property (strong, nonatomic) IBOutlet UITextField *textField3;
@end

@implementation Demo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *textFields = @[_textField1,
                            _textField2,
                            _textField3];
    keyboardHandler = [KeyboardHandler handleWithView:self.view textFields:textFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
