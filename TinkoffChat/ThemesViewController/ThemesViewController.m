//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Андрей Зорькин on 17.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

#import "ThemesViewController.h"

@implementation ThemesViewController
@synthesize delegate = _delegate;
@synthesize model = _model;

- (void)viewDidLoad {
    [super viewDidLoad];
    //printf("ThemesViewController VIEWDIDLOAD\n");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeTheme:(id)sender {
    if ([self model] != nil){
    switch ([sender tag]) {
        case 0:
            [[self delegate] themesViewController:self didSelectTheme:[[self model] theme1]];
            break;
        case 1:
            [[self delegate] themesViewController:self didSelectTheme:[[self model] theme2]];
            break;
        case 2:
            [[self delegate] themesViewController:self didSelectTheme:[[self model] theme3]];
            break;
        default: break;
    }
    }
}

-(id<ThemesViewControllerDelegate>)delegate{
    return _delegate;
}

-(void)setDelegate:(id<ThemesViewControllerDelegate>)delegate{
    _delegate = delegate;
}

-(Themes *)model{
    return _model;
}

-(void)setModel:(Themes *)model{
    [_model release];
    [model retain];
    _model = model;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    //printf("ThemesViewController DEALLOCED\n");
    [[self model] release];
    [super dealloc];
}

@end
