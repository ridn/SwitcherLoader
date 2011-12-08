#import "SwitcherLoader.h"
#import <SpringBoard5.0/SBAppSwitcherBarView.h>
#include <dlfcn.h>
SwitcherLoader *switcherLoader;
%hook SBAppSwitcherBarView
- (void)addAuxiliaryViews:(NSArray *)arg1 {
    [switcherLoader loadItems];
    if([[switcherLoader defaultViews]count] < 1)
        [[switcherLoader defaultViews]addObjectsFromArray:arg1];
   
    NSMutableArray *plugins = [NSMutableArray array];
    NSMutableArray *indexed = [switcherLoader enabledPluginsIndexed];
  
    for(unsigned int i =0; i <[indexed count]; i++) {
        NSString *pid = [indexed objectAtIndex:i];
        if([switcherLoader viewForId:pid])
        [plugins addObject:[switcherLoader viewForId:pid]];
               
    }
    [switcherLoader setStatus:Normal];
  
    %orig(plugins);
}

- (void)viewWillAppear {
  if(switcherLoader.currentStatus == Update)
    [self addAuxiliaryViews:nil];
    %orig;
    
}



%end
%hook SBNowPlayingBarView
%new
-(NSString *)plugin_id {
    
    return @"springboard.sbnowplayingbarview";
}
%end
%hook SBAirPlayBarView
%new
-(NSString *)plugin_id {
    
    return @"springboard.sbairplaybarview";
}
%end
%ctor {
   switcherLoader = [[SwitcherLoader alloc]init];
    
}