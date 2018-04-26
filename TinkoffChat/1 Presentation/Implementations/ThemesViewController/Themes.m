//
//  Themes.m
//  TinkoffChat
//
//  Created by Андрей Зорькин on 17.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

#import "Themes.h"

@implementation Themes
-(id)init{
    [super init];
    _theme1 = [UIColor clearColor];
    _theme2 = [UIColor clearColor];
    _theme3 = [UIColor clearColor];
    return self;
}

-(id)initWith: (UIColor *)theme1 theme2: (UIColor *)theme2 theme3: (UIColor *)theme3{
    [super init];
    [theme1 retain];
    _theme1 = theme1;
    [theme2 retain];
    _theme2 = theme2;
    [theme3 retain];
    _theme3 = theme3;
    return self;
}

-(void)setTheme1:(UIColor *)theme1{
    [_theme1 release];
    [theme1 retain];
    _theme1 = theme1;
}
-(void)setTheme2:(UIColor *)theme2{
    [_theme2 release];
    [theme2 retain];
    _theme2 = theme2;
}
-(void)setTheme3:(UIColor *)theme3{
    [_theme3 release];
    [theme3 retain];
    _theme3 = theme3;
}
-(UIColor *)theme1{
    return _theme1;
}
-(UIColor *)theme2{
    return _theme2;
}
-(UIColor *)theme3{
    return _theme3;
}

-(void)dealloc{
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    [super dealloc];
}

@end
