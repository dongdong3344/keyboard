//
//  KeyboardViewController.m
//  keyboard
//
//  Created by Ringo on 2017/5/18.
//  Copyright © 2017年 Ringo. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextView  *sugesstionTextView;
@property (weak, nonatomic) IBOutlet UITextField *userInfoText;
@property (weak, nonatomic) IBOutlet UITextField *commentText;
@property (strong,nonatomic) NSTimer *timer;
@end

@implementation KeyboardViewController

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)sendButtonClick:(UIButton *)sender {
    
    
    if (!self.userInfoText.text.length || !self.commentText.text.length) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"联系方式和建议不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        self.sugesstionTextView.text=[NSString stringWithFormat:@"您的联系方式是:%@\n您所反馈的建议是:%@\n%@",self.userInfoText.text,self.commentText.text,@"感谢您的宝贵意见！"];
        self.userInfoText.text=@"";
        self.commentText.text=@"";
        [self.view endEditing:YES];
    
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1,注册通知，监听键盘frame变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    //2,创建定时器刷新时间
    __weak KeyboardViewController *weakSelf=self;
    _timer=[NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        KeyboardViewController *strongSelf=weakSelf;
        [strongSelf updateTime];
    }];
   
}


-(void)updateTime{
    //设置时间label
    NSDate *currentDate = [NSDate date];//获取当前时间、日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    self.timeLabel.text=dateString;
}


-(void)keyboardWillChangeFrame:(NSNotification*)notification{
    
     NSLog(@"notification-info:%@",notification.userInfo);
    
    //获取键盘弹起时y值
    CGFloat keyboardY=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    //改变底部约束
    self.bottomConstraint.constant=[UIScreen mainScreen].bounds.size.height-keyboardY;
    //获取键盘弹起时间
    CGFloat duration=[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration: duration animations:^{
        [self.view layoutIfNeeded];
    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    
}



-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}


@end
