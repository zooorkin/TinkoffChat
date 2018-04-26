//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Андрей Зорькин on 17.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

#import "ThemesViewController.h"

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self button1] setBackgroundColor: [[self model] theme1]];
    [[self button2] setBackgroundColor: [[self model] theme2]];
    [[self button3] setBackgroundColor: [[self model] theme3]];
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
            [[self view] setBackgroundColor: [[self model] theme1]];
            [[[self navigationController] navigationBar] setBarTintColor: [[self model] theme1]];
            break;
        case 1:
            [[self delegate] themesViewController:self didSelectTheme:[[self model] theme2]];
            [[self view] setBackgroundColor: [[self model] theme2]];
            [[[self navigationController] navigationBar] setBarTintColor: [[self model] theme2]];
            break;
        case 2:
            [[self delegate] themesViewController:self didSelectTheme:[[self model] theme3]];
            [[self view] setBackgroundColor: [[self model] theme3]];
            [[[self navigationController] navigationBar] setBarTintColor: [[self model] theme3]];
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
    [[self model] release];
    [_button1 release];
    [_button2 release];
    [_button3 release];
    [super dealloc];
}

@end
