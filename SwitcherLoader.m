//
//  libswitcher.m
//  libswitcher
//
//  Created by Ryan Coffman on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SwitcherLoader.h"
#define PLUGIN_PATH @"/Library/SwitcherLoader/Plugins"
#define SETTINGS_PATH @"/var/mobile/Library/Preferences/com.fr0zensun.switcherloader.plist"
#import <objc/runtime.h>
#import <AppSupport/AppSupport.h>

static NSMutableArray *defaultViews = nil;
static BOOL hasLoadedPlugins = NO;
@implementation SwitcherLoader
@synthesize currentStatus  = _currentStatus;

-(id)init {
    if((self = [super init])) {
   plugins = [[NSMutableArray alloc]init];
    identifiers = [[NSMutableArray alloc]init];
    CPDistributedMessagingCenter *messagingCenter;
    messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.fr0zensun.switcherloader.message.center"];
    [messagingCenter runServerOnCurrentThread];
    [messagingCenter registerForMessageName:@"Plugins" target:self selector:@selector(returnPlugins)];
    [messagingCenter registerForMessageName:@"LoadPlugins" target:self selector:@selector(loadItems)];
    [messagingCenter registerForMessageName:@"Update" target:self selector:@selector(update)];


    }
    return self;
    
}

-(void)update {
    [self setStatus:Update];
    
    
}
-(void)setStatus:(Status)theStatus {
    
    self.currentStatus = theStatus;
    
}
-(NSDictionary *)returnPlugins {
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self enabledPluginsIndexed], [self disabledPlugins],nil] forKeys:[NSArray arrayWithObjects:@"EnabledPlugins",@"DisabledPlugins",nil]];

    return dict;
    
}

-(BOOL)isOSVersionSupported:(NSString *)minOS {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if (!minOS || minOS.length < 1 ||[systemVersion compare:minOS options:NSNumericSearch] != NSOrderedAscending)
        return YES;
    else
        return NO;
    
}
-(void)loadItems {
    if(!hasLoadedPlugins) {
    [plugins removeAllObjects];
    [identifiers removeAllObjects];
    NSFileManager *fm = [[NSFileManager alloc]init];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:PLUGIN_PATH error:nil];
  
    for(unsigned int i = 0; i < [dirContents count]; i++) {
        NSString *path = [PLUGIN_PATH stringByAppendingPathComponent:[dirContents objectAtIndex:i]];
    
        if([[path pathExtension]isEqualToString:@"bundle"]) {
            NSBundle *bundle = [NSBundle bundleWithPath:path];
            NSError *error = nil;
            if ([self isOSVersionSupported:[bundle objectForInfoDictionaryKey:@"MinimumOSVersion"]] ) {
                
            
            [bundle loadAndReturnError:&error];
            if(!error) {
                UIView *view = [[[bundle principalClass] alloc]initWithFrame:CGRectMake(0,0,320,94)];
            [identifiers addObject:[bundle bundleIdentifier]];
            view.tag = [plugins count];

                [plugins addObject:view];
            [view release];
            }
            }
            
        }
    }
    [identifiers addObject:@"springboard.sbnowplayingbarview"];
    [identifiers addObject:@"springboard.sbairplaybarview"];
   

    [fm release];
    
    hasLoadedPlugins = YES;
    }
    
}


-(NSMutableArray *)enabledPluginsIndexed {
    [self loadItems];
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i< [identifiers count]; i++) {
        NSString *pid = [identifiers objectAtIndex:i];
        
        if([self isPluginEnabled:pid])
            [array addObject:pid];
        
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_PATH];
    if ([[dict objectForKey:@"Plugins"]objectForKey:@"Enabled"] ) {
    NSArray *dictArray = [NSArray arrayWithArray:[[dict objectForKey:@"Plugins"]objectForKey:@"Enabled"]];
        
        for (int i = 0; i < [dictArray count]; i++) {
        
            NSString *pid = [dictArray objectAtIndex:i];
            if([array containsObject:pid])
                [array exchangeObjectAtIndex:i withObjectAtIndex:[array indexOfObject:pid]];
        
        }
        
    }
    return array; 
    
}
-(UIView *)viewForId:(NSString *)plugin_id {
    
    NSUInteger index = [identifiers indexOfObject:plugin_id];
    for(int i = 0; i <[defaultViews count]; i++) {
        if(plugin_id == [[defaultViews objectAtIndex:i]plugin_id])
            return [defaultViews objectAtIndex:i];
        
    }
    for(int i =0; i < [plugins count]; i++) {
        if(index == [[plugins objectAtIndex:i]tag])
            return [plugins objectAtIndex:i];
        
        
    }
    
    return nil;
    
}

-(NSMutableArray *)disabledPlugins {
    [self loadItems];
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i< [identifiers count]; i++) {
        NSString *pid = [identifiers objectAtIndex:i];
        
        if(![self isPluginEnabled:pid])
            [array addObject:pid];
        
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_PATH];
    if ([[dict objectForKey:@"Plugins"]objectForKey:@"Disabled"] ) {
        NSArray *dictArray = [NSArray arrayWithArray:[[dict objectForKey:@"Plugins"]objectForKey:@"Disabled"]];
        
        for (int i = 0; i < [dictArray count]; i++) {
            
            NSString *pid = [dictArray objectAtIndex:i];
            if([array containsObject:pid])
            [array exchangeObjectAtIndex:i withObjectAtIndex:[array indexOfObject:pid]];
        }
        
    }

    return array;
    
}


-(BOOL)isPluginEnabled:(NSString *)plugin_id {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:SETTINGS_PATH];
    if ([[dict objectForKey:@"Plugins"]objectForKey:@"Disabled"] ) {
        
    
        NSArray *array = [NSArray arrayWithArray:[[dict objectForKey:@"Plugins"]objectForKey:@"Disabled"]];
    if(![array containsObject:plugin_id])
    return YES;
    else return NO;
    }
    else
        return YES;
    
}

-(NSMutableArray *)defaultViews {
         if(!defaultViews)
             defaultViews = [[NSMutableArray alloc]init];
    return defaultViews;
           
}
-(NSMutableArray *)plugins {
    return plugins;
}


@end

