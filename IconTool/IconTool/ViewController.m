//
//  ViewController.m
//  IconTool
//
//  Created by Rocker on 2018/9/12.
//  Copyright © 2018年 Rocker. All rights reserved.
//

#import "ViewController.h"
#import "DLAddToDesktopHandler.h"
#import "UIImage+DLDataURIImage.h"
#import <TZImagePickerController/TZImagePickerController.h>
@interface ViewController ()<TZImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage *imageSelect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImg)];
    self.imgView.layer.cornerRadius = 10.f;
    self.imgView.layer.masksToBounds = YES;
    [self.imgView addGestureRecognizer:tap];
   
    //self.titleField.layer.borderColor = [UIColor colorWithRed:151.f/255 green:151.f/255 blue:151.f/255 alpha:1].CGColor;
    self.titleField.borderStyle = UITextBorderStyleNone;
    self.titleField.layer.cornerRadius = 5.f;
    self.titleField.layer.masksToBounds = YES;
    self.titleField.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.04];
   // self.titleField.placeholder = @"请输入名称";
    UIColor *color = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.2f];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    self.titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入名称" attributes:@{NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName:style}];
    
    self.titleField.textColor = [UIColor blackColor];
    self.titleField.textAlignment = NSTextAlignmentCenter;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didKboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)didClickKeyboard:(NSNotification *)sender{
    
    CGFloat durition = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyboardRect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:durition animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}

-(void)didKboardDisappear:(NSNotification *)sender{
    
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.titleField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectImg
{

    TZImagePickerController *imagePick = [[TZImagePickerController alloc]initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePick.allowPickingOriginalPhoto = NO;
    imagePick.allowCrop = YES;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 15;
    NSInteger widthHeight = self.view.frame.size.width - 2 * left;
    NSInteger top = (self.view.frame.size.height - widthHeight) / 2;
    imagePick.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    [imagePick setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photo, NSArray *asset, BOOL isSelectOriginalPhoto) {

    }];
    
    //弹出相册
    [self presentViewController:imagePick animated:YES completion:nil];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"%@",photos);
    if(photos.count > 0)
    {
        self.imgView.image = photos[0];
        self.imageSelect = photos[0];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择图片出错" message:@"请重新选择图片" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
}

- (IBAction)confirmAction:(id)sender {
    if(!self.imageSelect)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择图片" message:@"图片不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(![self.titleField.text isEqualToString:@""])
    {
        
        DLAddToDesktopHandler *handler = [DLAddToDesktopHandler sharedInsance];
        NSString *imageString = [self.imageSelect dataURISchemeImage];
        [handler addToDesktopWithDataURISchemeImage:imageString
                                              title:self.titleField.text
                                          urlScheme:@"IconTool://para=a"
                                     appDownloadUrl:@"https://www.baidu.com"];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置标题" message:@"标题不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
@end
