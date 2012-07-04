
#import "cocos2d.h"

@interface GameLayer : CCLayer
{
    CGSize winSize;

    CCSprite *rightSprite;
	CCSprite *rightPressedSprite;
	CCSprite *leftSprite;
	CCSprite *leftPressedSprite;
	
	BOOL isLeftPressed;
	BOOL isRightPressed;
}

@property (nonatomic, retain) CCSprite *rightSprite;
@property (nonatomic, retain) CCSprite *rightPressedSprite;
@property (nonatomic, retain) CCSprite *leftSprite;
@property (nonatomic, retain) CCSprite *leftPressedSprite;

+(CCScene *) scene;

- (void) createBackgroundParallax;
- (void) createControlButtons;
- (void) moveBackground;

@end
