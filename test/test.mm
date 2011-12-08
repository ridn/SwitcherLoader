#import <libswitcher/libswitcher.h>
@interface test_view : UIView

@end
@implementation test_view
-(id)init {
self = [super init];
self.frame = CGRectMake(0,0,320,94);
self.backgroundColor = [UIColor redColor];
return self;
}

@end
