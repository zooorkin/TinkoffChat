//
//  Themes.m
//  TinkoffChat
//
//  Created by Андрей Зорькин on 17.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

#import "Themes.h"

@implementation Themes
@synthesize theme1 = _theme1;
@synthesize theme2 = _theme2;
@synthesize theme3 = _theme3;
-(id)init{
    //printf("Themes INITIALIZED\n");
    [super init];
    _theme1 = [UIColor redColor];
    _theme2 = [UIColor greenColor];
    _theme3 = [UIColor blueColor];
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
    //printf("Themes DEALLOCED\n");
    [super dealloc];
}

@end
