//
//  ViewController.h
//  IconTool
//
//  Created by Rocker on 2018/9/12.
//  Copyright © 2018年 Rocker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UITextField *titleField;

- (IBAction)confirmAction:(id)sender;


@end

