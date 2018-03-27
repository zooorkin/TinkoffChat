//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Андрей Зорькин on 17.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Themes.h"

@protocol ThemesViewControllerDelegate <NSObject>
-(void)themesViewController: (UIViewController *)controller didSelectTheme:(UIColor *)selectedTheme;
@end

@interface ThemesViewController: UIViewController
{
    id<ThemesViewControllerDelegate> _delegate;
    Themes *_model;
}
@property (retain, nonatomic) IBOutlet UIButton *button1;
@property (retain, nonatomic) IBOutlet UIButton *button2;
@property (retain, nonatomic) IBOutlet UIButton *button3;

@property (weak) id<ThemesViewControllerDelegate> delegate;
@property (retain) Themes *model;
-(id<ThemesViewControllerDelegate>)delegate;
-(void)setDelegate:(id<ThemesViewControllerDelegate>)delegate;
-(Themes *)model;
-(void)setModel:(Themes *)model;
@end
