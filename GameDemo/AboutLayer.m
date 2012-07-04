
#import "AboutLayer.h"
#import "MainMenuLayer.h"

@implementation AboutLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutLayer *layer = [AboutLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"AboutScene/bg.png"];
        bgSprite.anchorPoint = CGPointZero;
        [bgSprite setPosition:ccp(0,0)];
        [self addChild:bgSprite z:0 tag:0];
        
        CCMenuItem *closeMenuItem = [CCMenuItemImage itemFromNormalImage:@"Common/btn_close.png"
															 selectedImage:@"Common/btn_close_s.png"
																	target:self
																  selector:@selector(closeCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:closeMenuItem, nil];
        menu.position = ccp(240, 30);
        
        [self addChild:menu z:1 tag:1];
        
    }
	return self;
}

- (void) closeCallback: (id) sender {
	//NSLog(@"close pushed");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInB transitionWithDuration:0.5f scene:[MainMenuLayer scene]]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
