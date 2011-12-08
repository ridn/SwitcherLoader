//
//  libswitcher.h
//  libswitcher
//
//  Created by Ryan Coffman on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef enum {
    Normal = 0,
    Update = 1
    
}
Status;

@interface SwitcherLoader : NSObject {
    NSMutableArray *plugins;
    NSMutableArray *identifiers;
    Status _currentStatus;
}
-(void)loadItems;
-(BOOL)isPluginEnabled:(NSString *)plugin_id;

-(UIView *)viewForId:(NSString *)plugin_id;
-(NSMutableArray *)plugins;
-(NSMutableArray *)enabledPluginsIndexed;
-(NSMutableArray *)disabledPlugins;
-(NSMutableArray *)defaultViews;
-(void)setStatus:(Status)theStatus;
@property (nonatomic, assign) Status currentStatus;
@end

@interface SwitcherLoader (plugin)
-(NSString *)plugin_id;
@end
