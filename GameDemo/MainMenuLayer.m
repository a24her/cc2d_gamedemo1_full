
#import "MainMenuLayer.h"
#import "GameLayer.h"
#import "HighScoreLayer.h"
#import "AboutLayer.h"

@implementation MainMenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
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
		
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"MainMenuScene/bg.png"];
        bgSprite.anchorPoint = CGPointZero;
        [bgSprite setPosition:ccp(0,0)];
        [self addChild:bgSprite z:0 tag:0];
        
		CCMenuItem *newGameMenuItem = [CCMenuItemImage itemFromNormalImage:@"MainMenuScene/new_game.png"
															 selectedImage:@"MainMenuScene/new_game_s.png"
																	target:self
																  selector:@selector(newGameMenuCallback:)];
		
		CCMenuItem *scoreMenuItem = [CCMenuItemImage itemFromNormalImage:@"MainMenuScene/high_score.png"
														   selectedImage:@"MainMenuScene/high_score_s.png"
																  target:self
																selector:@selector(highScoreMenuCallback:)];
		
		CCMenuItem *aboutMenuItem = [CCMenuItemImage itemFromNormalImage:@"MainMenuScene/about.png"
														   selectedImage:@"MainMenuScene/about_s.png"
																  target:self
																selector:@selector(aboutMenuCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:newGameMenuItem, scoreMenuItem, aboutMenuItem, nil];
		[menu alignItemsVertically];

        menu.position = ccp(menu.position.x, menu.position.y - 20);

        [self addChild:menu z:1 tag:1];
    
    }
	return self;
}

- (void) newGameMenuCallback: (id) sender {
	//NSLog(@"New Game Pushed");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameLayer scene]]];
}

- (void) highScoreMenuCallback: (id) sender {
	//NSLog(@"High Score Pushed");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HighScoreLayer scene]]];
}

- (void) aboutMenuCallback: (id) sender {
//	NSLog(@"About Pushed");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionShrinkGrow transitionWithDuration:0.5f scene:[AboutLayer scene]]];
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
