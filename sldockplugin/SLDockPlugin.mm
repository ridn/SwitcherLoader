#import <objc/runtime.h>
#import <SpringBoard5.0/SBIconController.h>
#import <SpringBoard5.0/SBIconModel.h>
#import <SpringBoard5.0/SBIconView.h>
#import <SpringBoard5.0/SBIconViewDelegate-Protocol.h>
#import <SpringBoard5.0/SBApplicationIcon.h>
#import <SpringBoard5.0/SBDockIconListView.h>


@interface SLDockPlugin_view : UIView<SBIconViewDelegate> {
    
}
@end
@implementation SLDockPlugin_view
-(id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {

    }
    return self;
}

-(void)layoutSubviews {
    NSLog(@"OVERALL");
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
        [view release];
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:@"/var/mobile/Library/SpringBoard/IconState.plist"];
    
    NSArray *icondict = [[NSArray alloc]initWithArray:[dict objectForKey:@"buttonBar"]];
    

    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height/2,self.frame.size.width,self.frame.size.height/2)];
    background.image = [objc_getClass("SBDockIconListView") backgroundImageForOrientation:1];
    [self addSubview:background];
        for (unsigned int i = 0; i < [icondict count]; i++) {
            SBIcon *sbicon = [[objc_getClass("SBIconModel") sharedInstance] applicationIconForDisplayIdentifier:[icondict objectAtIndex:i]];
            SBIconView *view = [[objc_getClass("SBIconView") alloc]initWithDefaultSize];
            [view setIcon:sbicon];
            view.delegate = self;
            NSLog(@"view1");

        view.center = CGPointMake(i*(self.frame.size.width/4)+ (view.frame.size.width/1.5), self.center.y + 5);
            NSLog(@"View2");
        [self addSubview:view];
    }    
    [icondict release];
    [dict release];
}


- (BOOL)iconAllowJitter:(SBIconView *)arg1 {
    
    return YES;
}
- (BOOL)iconPositionIsEditable:(id)arg1 {
    
    return NO;
}
- (void)iconHandleLongPress:(SBIconView *)arg1 {
    
   // [arg1 setIsJittering:YES];
}
- (void)iconTouchBegan:(SBIconView *)arg1 {
    [arg1 setHighlighted:YES];
    
    
}
- (void)icon:(id)arg1 touchMovedWithEvent:(id)arg2 {
    
    
}
- (void)icon:(SBIconView *)arg1 touchEnded:(BOOL)arg2 {
    [arg1 setHighlighted:NO delayUnhighlight:NO];

}
- (BOOL)iconShouldAllowTap:(id)arg1 {
    return YES;
}
- (void)iconTapped:(SBIconView *)arg1 {
    [arg1.icon launchFromViewSwitcher];
}
- (BOOL)icon:(id)arg1 canReceiveGrabbedIcon:(id)arg2 {
    return NO;
}

- (int)closeBoxTypeForIcon:(id)arg1 {
    
    return 1;
}
- (void)iconCloseBoxTapped:(id)arg1 {
    
}
- (BOOL)iconShouldPrepareGhostlyImage:(id)arg1 {
    
    return YES;
}
- (BOOL)iconViewDisplaysBadges:(id)arg1 {
    
    return NO;
}
@end
