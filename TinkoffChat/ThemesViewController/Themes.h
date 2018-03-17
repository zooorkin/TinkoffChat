//
//  Themes.h
//  TinkoffChat
//
//  Created by Андрей Зорькин on 17.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Themes : NSObject
{
    UIColor *_theme1;
    UIColor *_theme2;
    UIColor *_theme3;
}
-(id)init;
@property (nonatomic, weak) UIColor *theme1;
@property (nonatomic, weak) UIColor *theme2;
@property (nonatomic, weak) UIColor *theme3;
-(void)setTheme1:(UIColor *)theme1;
-(void)setTheme2:(UIColor *)theme2;
-(void)setTheme3:(UIColor *)theme3;
-(UIColor *)theme1;
-(UIColor *)theme2;
-(UIColor *)theme3;
@end
