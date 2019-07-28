//
//  LoginView.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "LoginView.h"
#import "FoundationTool.h"
#import "MBProgressHUD.h"
#import "LoginModel.h"
#import "SqlOperation.h"
#import "SourceTool.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface LoginView()

@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *passwdField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registBtn;
@property (nonatomic, strong) FoundationTool *tools;
@property (nonatomic, assign) BOOL  loginAndRegister;

@end

@implementation LoginView
@synthesize registBtn = _registBtn;
@synthesize loginBtn = _loginBtn;
@synthesize phoneField = _phoneField;
@synthesize passwdField = _passwdField;

- (id)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        _tools = [[FoundationTool alloc] init];
        [self addSubview:self.phoneField];
        [self addSubview:self.passwdField];
        [self addSubview:self.loginBtn];
        [self addSubview:self.registBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)doRegistAction:(UIButton *)btn{
    LoginModel *model = [[LoginModel alloc] init];
    model.phoneNum = _phoneField.text;
    model.password = _passwdField.text;
    SqlOperation *sqlOper = [[SqlOperation  alloc] init];
    
    BOOL res =  [sqlOper doInsertTable:@"login" data:model];
    if (res) {
        [self registerSuccess];
    }
}
- (void)doLoginAction:(UIButton *)btn{
    
    LoginModel *model = [[LoginModel alloc] init];
    model.phoneNum = _phoneField.text;
    model.password = _passwdField.text;
    
    SqlOperation *sqlOper = [[SqlOperation  alloc] init];
    
    BOOL res = [sqlOper doSearchTable:@"login" data:model value:@"phoneNum" key:model.phoneNum];
    if (!res){
        [self loginFail];
    }else{
        [self loginSuccess];
    }
}

- (void)loginSuccess{
    _loginAndRegister = NO;
    [self.tools showHUDWithView:self title:@"登录成功"];
    SourceTool *tool = [[SourceTool alloc] init];
    [tool doSaveUserID:_phoneField.text];
//    Class class = object_getClass(_delegate);
//    BOOL res = [class respondsToSelector:@selector(loginAction)];
    if (_delegate) {
        [_delegate loginAction];
    }
}

- (void)loginFail{
   [self.tools showHUDWithView:self title:@"登录失败 请注册"];
}

- (void)registerSuccess{
    [self.tools showHUDWithView:self title:@"注册成功"];

}

- (void)textFieldDidChange:(UITextField *)textField{
    BOOL res = [self.tools isMobileNumber:textField.text];
    
}

- (void)listSubView{
    for (UIButton *btn  in self.subviews) {
        NSLog(@"btn=====%@",btn);
        [btn removeFromSuperview];
    }
}

- (void)setPasswdField:(UITextField *)passwdField
{
     _passwdField = passwdField;
}

- (UITextField *)passwdField{
    if (!_passwdField) {
        _passwdField = [[UITextField alloc] initWithFrame:CGRectMake(0, 130, KWidth-40, 50)];
        _passwdField.backgroundColor = [UIColor grayColor];
        _passwdField.returnKeyType = UIKeyboardTypeNumberPad;
        _passwdField.layer.cornerRadius = 5;
        [_passwdField setFont:[UIFont systemFontOfSize:15]];
        [_passwdField setTextAlignment:NSTextAlignmentLeft];
        [_passwdField  setTextColor:[UIColor blackColor]];
    }
    return _passwdField;
}

- (void)setPhoneField:(UITextField *)phoneField{
    _phoneField = phoneField;
}

- (UITextField *)phoneField{
    if (!_phoneField){
        _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, KWidth-40, 50)];
        [_phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phoneField.returnKeyType = UIKeyboardTypeNumberPad;
        _phoneField.layer.cornerRadius = 5;
        [_phoneField setFont:[UIFont systemFontOfSize:15]];
        [_phoneField setTextAlignment:NSTextAlignmentLeft];
        [_phoneField  setTextColor:[UIColor blackColor]];
        _phoneField.backgroundColor = [UIColor grayColor];
    }
    return _phoneField;
}


- (void)setLoginBtn:(UIButton *)loginBtn
{
    _loginBtn = loginBtn;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.tag = 1;
        _loginBtn.userInteractionEnabled = YES;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_loginBtn setContentMode:UIViewContentModeScaleAspectFit];
        [_loginBtn setFrame:CGRectMake(30, 200, 100, 50)];
        [_loginBtn addTarget:self action:@selector(doLoginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn setBackgroundColor:[UIColor yellowColor]];
    }
    return _loginBtn;
}

- (void)setRegistBtn:(UIButton *)registBtn{
    _registBtn = registBtn;
}

- (UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registBtn.userInteractionEnabled = YES;
        [_registBtn setBackgroundColor:[UIColor greenColor]];
        _registBtn.tag = 2;
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_registBtn setContentMode:UIViewContentModeScaleAspectFit];
        [_registBtn setFrame:CGRectMake(150, 200, 100, 50)];
        [_registBtn addTarget:self action:@selector(doRegistAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}


@end
