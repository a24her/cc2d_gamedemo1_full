
#import "GameLayer.h"
#import "MainMenuLayer.h"

#define IMG_WIDTH 1600 // 전체 이미지는 1600 이지만 2개(800씩) 잘라서 처리한다.

enum {
	kTag_Parallax = 0,
	kTag_ArrowButtonPressed = 1,
	kTag_ArrowButton = 2
};

@implementation GameLayer

@synthesize rightSprite, rightPressedSprite, leftSprite, leftPressedSprite;


// scene 를 생성하고 레이어를 포함시킨다음 scenen자체를 리턴한다.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
	if ((self = [super init])) {

        CCMenuItem *closeMenuItem = [CCMenuItemImage itemFromNormalImage:@"Common/btn_close.png"
                                                           selectedImage:@"Common/btn_close_s.png"
                                                                  target:self
                                                                selector:@selector(closeCallback:)];
		
        CCMenu *menu = [CCMenu menuWithItems:closeMenuItem, nil];
        menu.position = ccp(400, 300);
        
        [self addChild:menu z:1 tag:1];
		
        // 화면의 픽셀 크기를 구한다.
        winSize = [[CCDirector sharedDirector] winSize];
		
        [self createBackgroundParallax];
        [self createControlButtons];
        
        // CCLayer가 터치 이벤트를 처리할 수 있도록 활성화 한다.
        self.isTouchEnabled = YES;
	}
	
	return self;
	
}

- (void)dealloc {
	[rightSprite release];
	[rightPressedSprite release];
	[leftSprite release];
	[leftPressedSprite release];
	
	[super dealloc];
}

- (void) closeCallback: (id) sender {
	//NSLog(@"close pushed");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInB transitionWithDuration:0.5f scene:[MainMenuLayer scene]]];
}


#pragma mark -
#pragma mark CreatingSprite

- (void) createControlButtons {
	
	// 왼쪽 화살표
	CCSprite *sprite = [[CCSprite alloc] initWithFile:@"GameScene/arrow_left.png"];
	self.leftSprite = sprite;
	
	// 기본 anchorPoint가 가운데, 즉 (0.5, 0.5)이므로 이미지의 가로 세로 크기의 반에 5픽셀의 여유를 두고 화면 아래에 표시한다.
	self.leftSprite.position = ccp( 10 + self.leftSprite.contentSize.width / 2, self.leftSprite.contentSize.height / 2 + 5);
	[self addChild:self.leftSprite z:kTag_ArrowButton];
	[sprite release];
	
	// 눌렀을 때 쓰일 왼쪽 화살표
	sprite = [[CCSprite alloc] initWithFile:@"GameScene/arrow_left_s.png"];
	self.leftPressedSprite = sprite;
	
	// self.leftSprite와 같은 위치에 표시한다.
	self.leftPressedSprite.position = self.leftSprite.position;
	
	// 눌렀을 때의 화살표를 하위 zorder 로 넣는다.
	[self addChild:self.leftPressedSprite z:kTag_ArrowButtonPressed];
	[sprite release];
	
	// 오른쪽 화살표
	sprite = [[CCSprite alloc] initWithFile:@"GameScene/arrow_right.png"];
	self.rightSprite = sprite;
	
	// 왼쪽 화살표에서 15픽셀 오른쪽에 위치시킨다.
	self.rightSprite.position = ccp(self.leftSprite.position.x + self.rightSprite.contentSize.width + 15,
									self.leftSprite.position.y);
	[self addChild:self.rightSprite z:kTag_ArrowButton];
	[sprite release];
	
	// 눌렀을 때 쓰일 오른쪽 화살표
	sprite = [[CCSprite alloc] initWithFile:@"GameScene/arrow_right_s.png"];
	self.rightPressedSprite = sprite;
	
	// self.rightSprite와 같은 위치에 표시한다.
	self.rightPressedSprite.position = self.rightSprite.position;
	
	// 눌렀을 때의 화살표를 하위 z-order 로 넣는다.
	[self addChild:self.rightPressedSprite z:kTag_ArrowButtonPressed];
	[sprite release];
	
}


- (void) createBackgroundParallax {
	
	// 이미지로 백그라운드에 쓰일 CCSprite를 만든다.
	CCSprite *bgSprite1 = [CCSprite spriteWithFile:@"GameScene/background1.png"];
	CCSprite *bgSprite2 = [CCSprite spriteWithFile:@"GameScene/background2.png"];
	
	
	// Transform 할 때 사용하는 anchorPoint를 왼쪽 아래 귀퉁이(0,0)으로 잡는다.
	bgSprite1.anchorPoint = ccp(0,0);
	bgSprite2.anchorPoint = ccp(0,0);


	// 위에서 만든 sprite를 담을 parent로 CCParallaxNode를 만든다.
	CCParallaxNode *voidNode = [CCParallaxNode node];
	
	// 배경 sprite를 parallax에 넣는다.
	// parallaxRatio 는 가로/세로로 움직이는 속도로 보면 된다.
	// 횡스크롤만 할 때는 y값을 0으로 준다.
	// background1.png 파일의 세로 크기가 160픽셀이기 때문에 positionOffset을 이용하여 화면 위에 위치하도록 좌표를 조정
	// 뒤쪽에 놓인 배경 background1.png 는 좀 더 천천히 움직이도록 parallaxRatio 의 x 값을 1 보다 작은 0.4 로 설정
	[voidNode addChild:bgSprite1 z:0 parallaxRatio:ccp(0.4f, 0) positionOffset:ccp(0, winSize.height / 2)];
	[voidNode addChild:bgSprite2 z:1 parallaxRatio:ccp(1.0f,0) positionOffset:CGPointZero];
	
	[self addChild:voidNode z:kTag_Parallax tag:kTag_Parallax];
	
}

#pragma mark -
#pragma mark Moving and Actions


/*
 - (void) onEnter {
 
 [super onEnter];
 
 [self moveBackground];
 
 }
 */


- (void) startMovingBackground {
	
	// 만약 버튼 두 개가 다 눌러졌으면 화면을 이동시키지 않는다.
	if (isLeftPressed == YES && isRightPressed == YES) {
		return;
	}
	
	NSLog(@"start moving");
	[self schedule:@selector(moveBackground)];
	
}

- (void) stopMovingBackground {
	
	NSLog(@"stop moving");
	[self unschedule:@selector(moveBackground)];
	
}


- (void) moveBackground {
	
	// 현재 layer에 있는 parallax node를 getChildByTag로 받는다.
	CCNode *voidNode = [self getChildByTag:kTag_Parallax];
	
	/*
     // onEnter 를 이용해서 움직일 때
     // 배경화면을 왼쪽끝에서 오른쪽 끝까지 약 8초동안 움직인다.
     CGFloat duration = 8.0f;
     CGFloat xRatio = 1.0; // CCParallaxNode를 만들 때 정해주었던 X parallaxRatio 값
     id go = [CCMoveBy actionWithDuration:duration position:ccp(-(IMG_WIDTH - winSize.width) / xRatio, 0)];
     id goBack = [go reverse];
     
     // 왼쪽/오른쪽으로 계속해서 움직인다.
     id seq = [CCSequence actions:go, goBack, nil];
     [voidNode runAction:[CCRepeatForever actionWithAction:seq]];
     */
	
	// 매프레임마다 움직일 거리
	CGPoint moveStep = ccp(3,0);
	
	// 오른쪽 버튼이 눌러졌을 때는 반대로 움직인다.
	if (isRightPressed) {
		moveStep.x = -moveStep.x;
	}
	
	CGFloat bgParallaxRatio = 1.0f;
	
	CGPoint newPos = ccp(voidNode.position.x + moveStep.x, voidNode.position.y);
	
	// 배경이 양쪽 끝에 도달하면 더 이상 움직이지 않는다.
	if (isLeftPressed == YES && newPos.x > 0) {
		newPos.x = 0;
	} else if (isRightPressed == YES && newPos.x < -(IMG_WIDTH - winSize.width) / bgParallaxRatio) {
		newPos.x = -(IMG_WIDTH - winSize.width) / bgParallaxRatio;
	}
	
	voidNode.position = newPos;
	
}

#pragma mark -
#pragma mark TouchDelegate

- (BOOL)isTouchInside:(CCSprite*)sprite withTouch:(UITouch*)touch {
	
	// cocoa 좌표
	CGPoint location = [touch locationInView:[touch view]];
	
	// cocoa좌표를 cocos2d 좌표로 변환
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	
	CGFloat halfWidth = sprite.contentSize.height / 2.0;
	CGFloat halfHeight = sprite.contentSize.height / 2.0;
    
	if (convertedLocation.x > (sprite.position.x + halfWidth) ||
		convertedLocation.x < (sprite.position.x - halfWidth) ||
		convertedLocation.y < (sprite.position.y - halfHeight) ||
		convertedLocation.y > (sprite.position.y + halfHeight) ) {
		return NO;
	}
	
	return YES;
    
}

// 손가락이 닿는 순간 호출된다.
- (void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	
	UITouch *touch = [touches anyObject];
	
	isLeftPressed = NO;
	isRightPressed = NO;
	
	// 터치가 왼쪽 또는 오른쪽 화살표 안에 들어왔는지 확인
	if ([self isTouchInside:self.leftSprite withTouch:touch] == YES) {
		// 왼쪽 화살표를 안 보이게 한다. 아래쪽 이미지가 나타난다.
		self.leftSprite.visible = NO;
		
		isLeftPressed = YES;
	} else if ([self isTouchInside:self.rightSprite withTouch:touch] == YES) {
		// 오른쪽 화살표를 안 보이게 한다.
		self.rightSprite.visible = NO;
		isRightPressed = YES;
	}
	
	// 버튼이 눌러졌으면 화면을 움직인다.
	if (isLeftPressed == YES || isRightPressed == YES) {
		[self startMovingBackground];
	}
	
}

// 손가락을 떼는 순간 호출된다.
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent*)event {
	
	// 배경화면을 멈춘다.
	if (isLeftPressed == YES || isRightPressed == YES) {
		[self stopMovingBackground];
	}
	
	
	// 감춰졌던 버튼 이미지를 다시 보이게 한다.
	if (isLeftPressed == YES) {
		self.leftSprite.visible = YES;
	}
	
	if (isRightPressed == YES) {
		self.rightSprite.visible = YES;
	}
	
}

// 손가락을 움직이면 계속해서 호출된다.
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// 손가락이 버튼을 벗어나면 움직임이 중단된다.
	if (isLeftPressed == YES && [self isTouchInside:self.leftSprite withTouch:touch] == NO) {
		self.leftSprite.visible = YES;
		[self stopMovingBackground];
	} else if (isRightPressed == YES && [self isTouchInside:self.rightSprite withTouch:touch] == NO) {
		self.rightSprite.visible = YES;
		[self stopMovingBackground];
	}
    
}




@end
