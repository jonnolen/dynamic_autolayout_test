//
//  DTViewController.m
//  test_autolayout_two
//
//  Created by Jonathan Nolen on 9/12/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "DTViewController.h"

@interface DTViewController (){

}
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@property (nonatomic, weak) UIView *pos1;
@property (nonatomic, weak) UIView *pos2;
@property (nonatomic, weak) UIView *pos3;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *buttonContainerCenterX;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *buttonContainerVerticalSpacing;
@end

@implementation DTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _view1 = [UIView new];
    _view2 = [UIView new];
    _view3 = [UIView new];
    
    _view1.backgroundColor = [UIColor greenColor];
    _view2.backgroundColor = [UIColor orangeColor];
    _view3.backgroundColor = [UIColor purpleColor];
    
    _view1.translatesAutoresizingMaskIntoConstraints = NO;
    _view2.translatesAutoresizingMaskIntoConstraints = NO;
    _view3.translatesAutoresizingMaskIntoConstraints = NO;

    
    self.pos1 = self.view1;
//    self.pos2 = self.view2;
//    self.pos3 = self.view3;
    
    [self.view addSubview:_view1];
//    [self.view addSubview:_view2];
//    [self.view addSubview:_view3];
//    
    [self.view1 addGestureRecognizer:[self buildGestureRecognizer]];
    [self.view2 addGestureRecognizer:[self buildGestureRecognizer]];
    [self.view3 addGestureRecognizer:[self buildGestureRecognizer]];
    
    [self layoutConstraintsForInterfaceOrientation:self.interfaceOrientation];
    [self.view layoutIfNeeded];
}

-(UITapGestureRecognizer *)buildGestureRecognizer{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    return recognizer;
}

-(void)tappedView:(UITapGestureRecognizer *)sender{
    if (sender.view != self.pos1){
        UIView *tmp = self.pos1;
        self.pos1 = sender.view;
        if (sender.view == self.pos2){
            self.pos2 = tmp;
        }
        else{
            self.pos3 = tmp;
        }
        [self layoutConstraintsForInterfaceOrientation:self.interfaceOrientation];
        [UIView animateWithDuration:.25 animations:^{
            [self.view layoutIfNeeded];
            [self.view bringSubviewToFront:self.pos2];
            [self.view bringSubviewToFront:self.pos3];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)layoutConstraintsForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    [self.view removeConstraints:self.view.constraints];
    [self.view1 removeConstraints:self.view1.constraints];
    [self.view2 removeConstraints:self.view2.constraints];
    [self.view3 removeConstraints:self.view3.constraints];
    
    [self.view addConstraints:@[self.buttonContainerCenterX, self.buttonContainerVerticalSpacing]];
    if (UIInterfaceOrientationIsLandscape(orientation)){
        [self setLandscapeConstraints];
    }
    else{
        [self setPortraitConstraints];
    }
}

-(void)setLandscapeConstraints{
    NSMutableDictionary *binding = [@{} mutableCopy];
    NSArray *constraints = @[];
    if (self.pos1){
        [binding addEntriesFromDictionary:NSDictionaryOfVariableBindings(_pos1)];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pos1(768)]" options:0 metrics:nil views:binding]];
        constraints = [constraints arrayByAddingObject:[self horizontalCenterInSuperView:self.pos1]];
        [self.pos1 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos1]];
        if (self.pos2 || self.pos3){
            constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_pos1]" options:0 metrics:nil views:binding]];
            if (self.pos2 && self.pos3){
                [binding addEntriesFromDictionary:NSDictionaryOfVariableBindings(_pos2, _pos3)];
                [self.pos2 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos2]];
                [self.pos3 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos3]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pos2]-|" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pos3]-|" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pos2(240)]" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pos3(==_pos2)]-|" options:0 metrics:nil views:binding]];
            }
            else if (self.pos2){
                [binding addEntriesFromDictionary:NSDictionaryOfVariableBindings(_pos2)];
                [self.pos2 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos2]];
                constraints = [constraints arrayByAddingObject:[self horizontalCenterInSuperView:self.pos2]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pos2]-|" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pos2(240)]" options:0 metrics:nil views:binding]];
            }
            else if (self.pos3){
                [binding addEntriesFromDictionary:NSDictionaryOfVariableBindings(_pos3)];
                [self.pos3 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos3]];
                constraints = [constraints arrayByAddingObject:[self horizontalCenterInSuperView:self.pos3]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pos3]-|" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pos3(240)]" options:0 metrics:nil views:binding]];
            }
        }
        else{
            constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:self.pos1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.]];
        }
    }
    [self.view addConstraints:constraints];


}

-(void)setPortraitConstraints{
    NSMutableDictionary *binding = [@{} mutableCopy];
    NSArray *constraints = @[];    
    if (self.pos1){
        [binding addEntriesFromDictionary:NSDictionaryOfVariableBindings(_pos1)];
        [self.pos1 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos1]];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pos1]-|" options:0 metrics:nil views:binding]];
        if (self.pos2 || self.pos3){
            constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_pos1]" options:0 metrics:nil views:binding]];
            if (self.pos2 && self.pos3){
                [binding addEntriesFromDictionary:NSDictionaryOfVariableBindings(_pos2, _pos3)];
                [self.pos2 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos2]];
                [self.pos3 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos3]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pos2]-|" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pos3]-|" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_pos2(==_pos3)]-[_pos3(==_pos2)]-|" options:0 metrics:nil views:binding]];
            }
            else if (self.pos2){
                [binding addEntriesFromDictionary:NSDictionaryOfVariableBindings(_pos2)];
                [self.pos2 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos2]];
                constraints = [constraints arrayByAddingObject:[self horizontalCenterInSuperView:self.pos2]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pos2]-|" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pos2(360)]" options:0 metrics:nil views:binding]];
            }
            else if (self.pos3){
                [binding addEntriesFromDictionary:NSDictionaryOfVariableBindings(_pos3)];
                [self.pos3 addConstraint:[self setFourThreeAspectRatioContraintForView:self.pos3]];
                constraints = [constraints arrayByAddingObject:[self horizontalCenterInSuperView:self.pos3]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pos3]-|" options:0 metrics:nil views:binding]];
                constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pos3(360)]" options:0 metrics:nil views:binding]];
            }
        }
        else{
            constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:self.pos1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.]];
        }
    }
    [self.view addConstraints:constraints];
}

-(NSLayoutConstraint *)setFourThreeAspectRatioContraintForView:(UIView *)target{
    return [NSLayoutConstraint constraintWithItem:target
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:target
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:.75 constant:0.0];
}

-(NSLayoutConstraint *)horizontalCenterInSuperView:(UIView *)target{
    return [NSLayoutConstraint constraintWithItem:target
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1. constant:0.0];
}

-(IBAction)addView:(UIButton *)sender{
    if (!self.pos2){
        self.pos2 = [self firstViewWithOutSuperView];
        [self.view addSubview:self.pos2];
        [self layoutConstraintsForInterfaceOrientation:self.interfaceOrientation];
    }
    else if (!self.pos3){
        self.pos3 = [self firstViewWithOutSuperView];
        [self.view addSubview:self.pos3];
        [self layoutConstraintsForInterfaceOrientation:self.interfaceOrientation];
    }
    
    [UIView animateWithDuration:.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(IBAction)removeView:(UIButton *)sender{
    UIView *tmp = nil;
    if (self.pos3){
        tmp = self.pos3;
        self.pos3 = nil;
        [self layoutConstraintsForInterfaceOrientation:self.interfaceOrientation];
    }
    else if (self.pos2){
        tmp = self.pos2;
        self.pos2 = nil;
        [self layoutConstraintsForInterfaceOrientation:self.interfaceOrientation];
    }
    
    [UIView animateWithDuration:.25
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         if (tmp){
                             [tmp removeFromSuperview];
                         }
                     }];
}
-(UIView *)firstViewWithOutSuperView{
    NSArray *views = @[self.view1, self.view2, self.view3];
    return views[[views indexOfObjectPassingTest:^(UIView *object, NSUInteger idx, BOOL *stop){
        if (!object.superview){
            *stop = YES;
            return YES;
        }
        return NO;
    }]];
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                        duration:(NSTimeInterval)duration{

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self layoutConstraintsForInterfaceOrientation:toInterfaceOrientation];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
