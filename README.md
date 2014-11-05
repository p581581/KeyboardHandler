## KeyboardHandler

KeyboardHandler is a delightful library that helps you handle with multiple UITextField and keyboard easily.
It supports UITextField to be wrapped in a UIViewController, a UINavigationController, a UITabBarController, or even in a UIView.

Here is the Demo : [Download KeyboardHandler](https://github.com/p581581/KeyboardHandler/archive/master.zip)

#### Podfile

```ruby
platform :ios, '7.0'
pod "KeyboardHandler", "~> 0.0.1"
```

#### Usage
1. Create a NSArray, and put all UITextField into it.
2. Call the method: `handleWithView`.

```objective-c
@interface Demo () {
    KeyboardHandler *keyboardHandler; // or declare as a property variable
}
@property (strong, nonatomic) IBOutlet UITextField *textField1;
@property (strong, nonatomic) IBOutlet UITextField *textField2;
@property (strong, nonatomic) IBOutlet UITextField *textField3;
@end
```
```objective-c
NSArray *textFields = @[_textField1,
                        _textField2,
                        _textField3];
    
keyboardHandler = [KeyboardHandler handleWithViewController:self textFields:textFields];
```

#### Add text field programmingly

```objective-c
[keyboardHandler addTextField: textField];
```
