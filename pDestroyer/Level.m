//
//  HelloWorldLayer.mm
//  pDestroyer
//
//  Created by ITmind on 29.07.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "Level.h"
#import "SceneManager.h"
#import "Hud.h"
#import "SimpleAudioEngine.h"
#import "Bug.h"
#import "Flower.h"
#import "Instruments.h"

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation Level
@synthesize isPause;
@synthesize hud;
@synthesize sound;
@synthesize bugs, instruments, currentLevel;
@synthesize  xScale,yScale,fontSize;

float rand_FloatRange(float a, float b)
{
    return ((b-a)*((float)rand()/RAND_MAX))+a;
}

int randomBeetwen(int from, int to){
    return rand()%(to+1-from)+from;
}

int randomForPoint(int point){
    return randomBeetwen(point-200, point+200);
}

-(void) backgroundMusicFinished
{
    //NSLog(@"music stop");
    [self setBackgroundMusic];
}

-(void) setBackgroundMusic
{
    
    if(!music) return;
    //nt rndMusic = arc4random() % 5+1;
    
    //[[CDAudioManager sharedManager] playBackgroundMusic:[NSString stringWithFormat:@"track%i.mp3",rndMusic] loop:NO];
    
}

+(CCScene *) sceneForLevel:(Level *)level
{
	CCScene *scene = [CCScene node];
	[scene addChild: level];
    Hud* _hud = [Hud node];
    level.hud=_hud;
    [scene addChild:_hud z:5];
    [level.hud scoreLabelToDark];
	// return the scene
	return scene;
}


-(void) deleteSender:(id)sender{
    [self removeChild:sender cleanup:YES];
}

-(void) draw{
    [super draw];
    
    for (int i=0; i<100; i++) {
        ccDrawFilledCircle(star[i], 1, 0, 2*M_PI, 10);
    }
}

-(void) initLevel{
    isGround = NO;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [bugs removeAllObjects];
    //[instruments removeAllObjects];
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [layer1 stopAllActions];
    [sun stopAllActions];
    [fog stopAllActions];
    
    [layer1 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"background1_layer1.png"]];
    [layer2 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"background1_layer2.png"]]; 
    [layer3 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"background1_layer3.png"]]; 
    [layer4 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"background1_layer4.png"]];
    [layer5 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"background1_layer5.png"]]; 
    [flower initFlower];
    flower.position = ccp(winSize.width/2,10/yScale);
    
    layer1.opacity = 0.0f;
    [fog setOpacity:100];
    [self animateDayCycle];
    
    for (int i=0; i<currentLevel; i++) {
        [self addBaterfly];
    }
    
    [self schedule: @selector(ai:)interval:0.2f];
    [self schedule: @selector(killFlower:)interval:0.2f];
    [self schedule: @selector(everySecond:)interval:1.0f];
    [self schedule: @selector(addEnemy:)interval:7.0f];
}

-(void) addBaterfly{
    int x = randomBeetwen(100, 850)*xScale;
    int y = randomBeetwen(350, 600)*yScale;
    //NSLog(@"baterfly in %i:%i",x,y);
    int colorType = randomBeetwen(1, 3);
    Bug* bug = [Bug node];
    [bug bugOfType:@"baterfly" colorType:colorType];
    bug.position = ccp(x,y);
    bug.scale = 0.2f;
    [self addChild:bug z:7];
    [bugs addObject:bug];
}

-(void) initWithScale
{
    int x,y;
    for (int i=0; i<100; i++) {
        x = randomBeetwen(10, 1000)*xScale;
        y = randomBeetwen(500, 770)*yScale;
        star[i] = ccp(x,y);
    }
    currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"Level"];
    if (currentLevel==0) {
        currentLevel=1;
    }
    isPause = NO;
    bugs = [[NSMutableArray arrayWithCapacity:2] retain];
    instruments = [[NSMutableArray arrayWithCapacity:2] retain];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    layer1 = [CCSprite node];
    layer1.position = ccp(winSize.width/2,winSize.height/2);
    layer1.opacity = 0.0f;
    [self addChild:layer1 z:1];
    
    layer2 = [CCSprite node];
    layer2.position = ccp(winSize.width/2,winSize.height/2);
    layer2.scaleX = xScale;
    layer2.scaleY = yScale;
    [self addChild:layer2 z:3];
    
    layer3 = [CCSprite node];
    layer3.position = ccp(winSize.width/2,winSize.height/2);
    layer3.scaleX = xScale;
    layer3.scaleY = yScale;
    [self addChild:layer3 z:4];
    
    layer4 = [CCSprite node];
    layer4.position = ccp(winSize.width/2,winSize.height/2);
    layer4.scaleX = xScale;
    layer4.scaleY = yScale;
    [self addChild:layer4 z:4];
    
    layer5 = [CCSprite node];
    layer5.position = ccp(winSize.width/2,50*yScale);
    NSLog(@"%f",yScale);
    layer5.scaleX = xScale;
    layer5.scaleY = yScale;
    [self addChild:layer5 z:5];
    
    sun = [CCSprite spriteWithSpriteFrameName:@"sun.png"];
    sun.scaleX = xScale;
    sun.scaleY = yScale;
    [self addChild:sun z:2];
    
    fog = [CCLayerColor node];
    [fog initWithColor:ccc4(0,0,0,255)];
    fog.position=CGPointZero;
    [self addChild:fog z:20];
    
    flower = [Flower node];
    flower.position = ccp(winSize.width/2,10*yScale);
    flower.scaleX = xScale;
    flower.scaleY = yScale;
    [self addChild:flower z:4];
    
    Instrument* watteringCan = [Instrument node];
    [watteringCan instrumentOfType:0 isRestores:YES];
    watteringCan.startPosition = ccp(800*xScale,20*yScale);
    watteringCan.position = ccp(800*xScale,20*yScale);
    watteringCan.scaleX = xScale;
    watteringCan.scaleY = yScale;
    [self addChild:watteringCan z:8];
    [instruments addObject:watteringCan];
    [watteringCan restore];
    
    Instrument* gas0 = [Instrument node];
    [gas0 instrumentOfType:1 isRestores:NO];
    gas0.startPosition = ccp(30*xScale,20*yScale);
    gas0.position = ccp(30*xScale,20*yScale);
    gas0.scaleX = xScale;
    gas0.scaleY = yScale;
    [self addChild:gas0 z:8];
    [instruments addObject:gas0];
    
    Instrument* gas1 = [Instrument node];
    [gas1 instrumentOfType:2 isRestores:NO];
    gas1.startPosition = ccp(110*xScale,20*yScale);
    gas1.position = ccp(110*xScale,20*yScale);
    gas1.scaleX = xScale;
    gas1.scaleY = yScale;
    [self addChild:gas1 z:8];
    [instruments addObject:gas1];
    
    Instrument* gas2 = [Instrument node];
    [gas2 instrumentOfType:3 isRestores:NO];
    gas2.startPosition = ccp(190*xScale,20*yScale);
    gas2.position = ccp(190*xScale,20*yScale);
    gas2.scaleX = xScale;
    gas2.scaleY = yScale;
    [self addChild:gas2 z:8];
    [instruments addObject:gas2];
    
    
    
    //        frcurve_ = [[FRCurve curveFromType:kFRCurveLagrange order:kFRCurveCubic segments:64]retain];
    //		[frcurve_ setWidth:10.f];
    //		[frcurve_ setShowControlPoints:YES];
    //		[self addChild:frcurve_ z:10];
    
    pauseButton = [CCMenuItemImage itemFromNormalImage:@"button_pause2.png" selectedImage:@"button_pause2.png" target:self selector:@selector(pauseClick:)];
    pauseButton.scaleX = xScale;
    pauseButton.scaleY = yScale;
    pauseButton.position = ccp(winSize.width - 65*xScale, winSize.height - 43*yScale);
    CCMenu* pMenu = [CCMenu menuWithItems:pauseButton, nil];
    pMenu.position= CGPointZero;
    [self addChild:pMenu z:10];
    
    
    [self initLevel];
}

-(id) init
{

    xScale = 1;
    yScale = 1;
    fontSize = 1;
	if( (self=[super initWithColor:ccc4(0, 0, 0, 255)])) {
    //if( (self=[super init])) {
		// enable touches
		self.isTouchEnabled = YES;
		//self.isAccelerometerEnabled = YES;
        //MUSIC
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"Music"]==1){
            music = NO;
        }
        else{
            music = YES;
        }
//        
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"Sound"]==1){
            sound = NO;
        }
        else{
            sound = YES;
        }     
        		
	}
	return self;
}

-(void) animateDayCycle{
    //[[CDAudioManager sharedManager] stopBackgroundMusic];
    if(music){
        int rndMusic = rand() % 3;
        [[CDAudioManager sharedManager] playBackgroundMusic:[NSString stringWithFormat:@"day%i.mp3",rndMusic] loop:YES];
    }
    //move sun 
    sun.position=ccp(50*xScale,300*yScale);
    ccBezierConfig bezier;
    bezier.controlPoint_1 = ccp(150*xScale, 800*yScale);
    bezier.controlPoint_2 = ccp(900*xScale, 800*yScale);
    bezier.endPosition = ccp(960*xScale,300*yScale);
    [sun runAction:[CCBezierTo actionWithDuration:30.0f bezier:bezier]];

    
    //dark
    CCActionInterval* tineTo = [CCTintTo actionWithDuration: 5.0f red:255 green:255 blue:255];
    CCActionInterval* delay = [CCDelayTime actionWithDuration:20.0f];
    CCActionInterval* tineToBack = [CCTintTo actionWithDuration: 5.0f red:0 green:0 blue:0];
    CCAction* seq = [CCSequence actions:tineTo,delay,tineToBack,nil];
    [self runAction:seq];
    
    sun.color = ccc3(150,120,120);
    CCActionInterval* sunTineTo = [CCTintTo actionWithDuration: 10.0f red:255 green:255 blue:255];
    CCActionInterval* sunDelay = [CCDelayTime actionWithDuration:10.0f];
    CCActionInterval* sunTineToBack = [CCTintTo actionWithDuration: 10.0f red:150 green:120 blue:120];
    CCAction* endSunMoveAction = [CCCallFuncN actionWithTarget:self selector:@selector(endSunMove:)];
    CCAction* startNightAction = [CCCallFuncN actionWithTarget:self selector:@selector(startNight:)];
    CCAction* sunSeq = [CCSequence actions:sunTineTo,sunDelay,sunTineToBack,startNightAction,sunDelay,endSunMoveAction,nil];
    [sun runAction:sunSeq];
    
    CCActionInterval* skyFadeIn = [CCFadeIn actionWithDuration:5.0f];
    CCActionInterval* skyDelay = [CCDelayTime actionWithDuration:20.0f];
    CCActionInterval* skyFadeOut = [CCFadeOut actionWithDuration: 5.0f];
    CCAction* skySeq = [CCSequence actions:skyFadeIn,skyDelay,skyFadeOut,nil];
    [layer1 runAction:skySeq];
    
    CCActionInterval* fogFadeIn = [CCFadeTo actionWithDuration:5.0f opacity:100];
    CCActionInterval* fogDelay = [CCDelayTime actionWithDuration:20.0f];
    CCActionInterval* fogFadeOut = [CCFadeTo actionWithDuration: 5.0f opacity:0];
    CCAction* fogSeq = [CCSequence actions:fogFadeOut,fogDelay,fogFadeIn,nil];
    [fog runAction:fogSeq];
    
    [hud scoreLabelToDark];
    
}

-(void) startNight:(id)sender{
    //[[CDAudioManager sharedManager] stopBackgroundMusic];
    if(music){
        [[CDAudioManager sharedManager] playBackgroundMusic:@"night.mp3" loop:YES];
    }
}

-(void) endSunMove:(id)sender{
    if(flower.full) {
       [self levelComplite];
        return;
    }
    
    if (!isPause) {
        [self showText:[NSString stringWithFormat:@"Day bonus +%i",currentLevel*50]];
        [hud addScore:currentLevel*50];
    }
    [self animateDayCycle];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isPause) return;
    UITouch* touch = (UITouch*)( [touches anyObject] );
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	touchLocation = [self convertToNodeSpace:touchLocation];
    CGPoint originalTouch = touchLocation;
    
    if(isMoveInstument){
		touchLocation.x+=touchLoc.width;
		touchLocation.y+=touchLoc.height;
		isMoveInstument = NO;
        CCSprite* par;
        CCAction* deleteSenderAction = [CCCallFuncN actionWithTarget:self selector:@selector(deleteSender:)];
        
        switch (moveInstument.type) {
            case 0:
                
                if(CGRectIntersectsRect(moveInstument.boundingBox,[flower boundingBox]))
                {
                    if(sound) [[SimpleAudioEngine sharedEngine] playEffect:@"water.mp3"];
                    int curStatus = [moveInstument getCurrentStatus];
                    [flower addLives:curStatus];
                    [moveInstument restore];
                    [moveInstument use];
                }
                
                break;
            case 1:
            case 2:
            case 3:
                if(moveInstument.isActive){
                    if (sound) [[SimpleAudioEngine sharedEngine] playEffect:@"par.mp3"];
                    par = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"par%i.png",moveInstument.type-1]];
                    par.position = originalTouch;
                    par.scaleX = xScale;
                    par.scaleY = yScale;
                    [moveInstument use];
                    [self addChild:par z:8];
                    for (Bug* node in bugs) {
                        CGRect rect = node.boundingBox;
                        if(CGRectIntersectsRect(rect,par.boundingBox))
                        {
                            if(node.colorType == moveInstument.type){
                                if(sound) [[SimpleAudioEngine sharedEngine] playEffect:@"kill.mp3"];
                                [hud addScore:10];
                                [node kill];
                            }
                        }
                    }
                    
                    [par runAction:[CCSequence actions:
                                    [CCScaleTo actionWithDuration:0.3f scale:2.0f*xScale],
                                    [CCFadeOut actionWithDuration:0.3f],
                                    deleteSenderAction,nil]];
                    
                }
                break;
                
            default:
                break;
        }

            
        
		[moveInstument runAction:[CCMoveTo actionWithDuration:1.0f position:moveInstument.startPosition]];
	}
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isPause) return;
    //for( UITouch *touch in touches ) {
	//	CGPoint location = [touch locationInView: [touch view]];
	//	location = [[CCDirector sharedDirector] convertToGL: location];
    //}
    UITouch* touch = (UITouch*)( [touches anyObject] );
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	touchLocation = [self convertToNodeSpace:touchLocation];
    for (Instrument* node in instruments) {
        CGRect rect = node.boundingBox;
        if(CGRectContainsPoint(rect,touchLocation))
        {
            isMoveInstument = true;
            touchLoc.height = node.position.y-touchLocation.y;
            touchLoc.width = node.position.x-touchLocation.x;
            moveInstument = node;
            break;
        }
    }
   
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(isPause) return;
    UITouch* touch = (UITouch*)( [touches anyObject] );
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	touchLocation = [self convertToNodeSpace:touchLocation];
	
	if(isMoveInstument)
	{
		touchLocation.x+=touchLoc.width;
		touchLocation.y+=touchLoc.height;
		moveInstument.position = touchLocation;
        
	}
	    
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{

    return;
    if(isPause) return;
	//float x = (float)acceleration.x;
    float y = (float)acceleration.y;
    
    if(y > 0.1) //Left
    {
        if(layer4.position.x>500*xScale){
            //layer2.position=ccpAdd(layer2.position,ccp(-1,0));
            [layer2 runAction:[CCMoveTo actionWithDuration:0.1f position:ccpAdd(layer2.position,ccp(-1,0))]];
            [layer3 runAction:[CCMoveTo actionWithDuration:0.1f position:ccpAdd(layer3.position,ccp(-3,0))]];
            [layer4 runAction:[CCMoveTo actionWithDuration:0.1f position:ccpAdd(layer4.position,ccp(-7,0))]];
            //layer3.position=ccpAdd(layer3.position,ccp(-3,0));
            //layer4.position=ccpAdd(layer4.position,ccp(-7,0));
            //flower.position=ccpAdd(flower.position,ccp(-7,0));
            //for (Bug* node in bugs) {
            //    node.position = ccpAdd(node.position,ccp(-7,0));
            //}
        }
    }
    else if(y < -0.1) //Right
    {
        if(layer4.position.x<650*xScale){
            [layer2 runAction:[CCMoveTo actionWithDuration:0.1f position:ccpAdd(layer2.position,ccp(1,0))]];
            [layer3 runAction:[CCMoveTo actionWithDuration:0.1f position:ccpAdd(layer3.position,ccp(3,0))]];
            [layer4 runAction:[CCMoveTo actionWithDuration:0.1f position:ccpAdd(layer4.position,ccp(7,0))]];
            //layer3.position=ccpAdd(layer3.position,ccp(3,0));
            //layer4.position=ccpAdd(layer4.position,ccp(7,0));
            //flower.position=ccpAdd(flower.position,ccp(7,0));
            //for (Bug* node in bugs) {
            //   node.position = ccpAdd(node.position,ccp(7,0));
            //}
        }
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

-(void) addEnemy: (ccTime) dt{
    if (adView.hidden) {
        //[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        adView.hidden = NO;
    }
    else{
        //[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        adView.hidden = YES;
    }
    for (int i=bugs.count; i<((currentLevel<30)?currentLevel:30); i++) {
        [self addBaterfly];
    }
    if (currentLevel>10 && !isGround) {
        int x = randomBeetwen(100*xScale, 850*xScale);
        int y = 30*yScale;
        Bug* bug = [Bug node];
        [bug bugOfType:@"bug" colorType:1];
        bug.position = ccp(x,y);
        //bug.scale = 0.2f;
        [self addChild:bug z:8];
        [bugs addObject:bug];
        isGround = YES;
    }
}

-(void) everySecond: (ccTime) dt{
    [[NSUserDefaults standardUserDefaults] setInteger:currentLevel forKey:@"Level"];
    [[NSUserDefaults standardUserDefaults] setInteger:hud.score forKey:@"Score"];
    if(isPause) return;
    if(flower.isGrowing) [hud addScore:currentLevel];
    if(flower.lives<10) [self levelLost];
}

-(void) killFlower: (ccTime) dt{
    if(isPause) return;
	bool eatflower = NO;
    
	for (Bug* node in bugs) {
		//if(node.eating){ 
        if(CGRectIntersectsRect(flower.boundingBox,node.boundingBox)){
			eatflower = YES;
			break;
		}
	}
    
	if(eatflower) [flower addBug];
	else [flower removeBug];
}

-(void) ai: (ccTime) dt;
{
    //return;
    if(isPause) return;
    srand(time(NULL)|clock());
    
    for (Bug* node in bugs) {
        if(!node.isActive) continue;
        
        //if flower near
        CGRect flowerBox = [flower boundingBox];
        flowerBox.origin.x -=300*xScale;
        flowerBox.origin.y -=300*yScale;
        flowerBox.size.height +=600*yScale;
        flowerBox.size.width +=600*xScale;
        
        CGRect instrumentBox;
        if(isMoveInstument){
            instrumentBox = moveInstument.boundingBox;
            instrumentBox.origin.x -=100*xScale;
            instrumentBox.origin.y -=100*yScale;
            instrumentBox.size.height +=200*yScale;
            instrumentBox.size.width +=200*xScale;
        }
        
        ccTime moveTime = 10.0f;
        ccBezierConfig bezier;
        
        //select action
        
        //esli radom ubivalka to valim
        if(CGRectIntersectsRect(instrumentBox,node.boundingBox)){	
			if(node.goFromInstr) return;
            node.x = (rand() % 900)*xScale;
            node.y = (rand() % 600)*yScale;
            node.z = 10.0f;// +/- 2.0f
            
            CGPoint start_ = node.position;
            CGPoint end_ = ccp(node.x,node.isGround?start_.y:node.y);
            CGPoint point1 = ccpLerp(start_, end_, 1/3.f);
            CGPoint point2 = ccpLerp(start_, end_, 2/3.f);
            
            if(node.isGround){
                bezier.controlPoint_1 = point1;
                bezier.controlPoint_2 = point2;
                bezier.endPosition = end_;
            }
            else{
                point1.x +=10*xScale;
                point1.y -=10*yScale;
                point2.x -=10*xScale;
                point1.y +=10*yScale;
                //bezier.controlPoint_1 = ccp(node.position.x+50, node.position.y-50);
                //bezier.controlPoint_2 = ccp(node.x-50, node.y+50);
                bezier.controlPoint_1 = point1;
                bezier.controlPoint_2 = point2;
                bezier.endPosition = ccp(node.x,node.y);
            }
            
            node.move = YES;
            node.goFromInstr = YES;
            [node stopAllActions];
            node.eating = NO;
        }
        //if bug in rectangle flower then go to flower
        else if(CGRectIntersectsRect(flowerBox,node.boundingBox))
        {
            if(node.move) continue;
            node.move = YES;
            
            int x10p = [flower boundingBox].size.width*0.1;
            int y10p = [flower boundingBox].size.height*0.1;
            
            int x1 = [flower boundingBox].origin.x+x10p;
            int y1 = [flower boundingBox].origin.y + [flower boundingBox].size.height - y10p*4;
            int x2 = [flower boundingBox].origin.x + [flower boundingBox].size.width - x10p*5;
            int y2 = [flower boundingBox].origin.y + [flower boundingBox].size.height - y10p;
            
            
            node.x = rand()%(x2-x1)+x1;//x1;
            node.y = rand()%(y2-y1)+y1;//;/y1;
            node.z = 1.0f;
            
            CGPoint start_ = node.position;
            CGPoint end_ = ccp(node.x,node.isGround?start_.y:node.y);
            CGPoint point1 = ccpLerp(start_, end_, 1/3.f);
            CGPoint point2 = ccpLerp(start_, end_, 2/3.f);
            
            if(node.isGround){
                bezier.controlPoint_1 = point1;
                bezier.controlPoint_2 = point2;
                end_.x = flower.position.x+flower.contentSize.width/2+20;
                bezier.endPosition = end_;
                
            }
            else{
                point1.x +=10*xScale;
                point1.y -=10*yScale;
                point2.x -=10*xScale;
                point1.y +=10*yScale;
                //bezier.controlPoint_1 = ccp(node.position.x+50, node.position.y-50);
                //bezier.controlPoint_2 = ccp(node.x-50, node.y+50);
                bezier.controlPoint_1 = point1;
                bezier.controlPoint_2 = point2;
                bezier.endPosition = ccp(node.x,node.y);
            }
            node.eating = YES;
            
        }
        //else goto to random point
        else
        {
            if(node.move) continue;
            node.move = YES;
            
            node.eating = NO;
            
            //node.x = rand() % 900;
            //node.y = rand() % 600;
            while (YES) {
                node.x = randomForPoint(node.position.x)*xScale;
                if ((60*xScale)<node.x && node.x<(950*xScale)) {
                    break;
                }
            }
            
            while (YES) {
                node.y = randomForPoint(node.position.y)*yScale;
                if ((30*yScale)<node.y && node.y<(650*yScale)) {
                    break;
                }
            }
            node.z = rand_FloatRange(0.5f,1.2f);// +/- 2.0f
            
            CGPoint start_ = node.position;
            CGPoint end_ = ccp(node.x,node.isGround?start_.y:node.y);
            CGPoint point1 = ccpLerp(start_, end_, 1/3.f);
            CGPoint point2 = ccpLerp(start_, end_, 2/3.f);
            
            if(node.isGround){
                bezier.controlPoint_1 = point1;
                bezier.controlPoint_2 = point2;
                bezier.endPosition = ccp(node.x,start_.y);
            }
            else{
                point1.x +=10*xScale;
                point1.y -=10*yScale;
                point2.x -=10*xScale;
                point1.y +=10*yScale;
                //bezier.controlPoint_1 = ccp(node.position.x+50, node.position.y-50);
                //bezier.controlPoint_2 = ccp(node.x-50, node.y+50);
                bezier.controlPoint_1 = point1;
                bezier.controlPoint_2 = point2;
                bezier.endPosition = ccp(node.x,node.y);	
            }
        }
        
        if(node.z == 10.0f){
            moveTime = 0.5f;
            node.z = 1.0f;
        }
        else if(node.z>1.0f){
            moveTime = 3.0f;
        }
        else if(node.z<1.0f){
            moveTime = 2.0f;
        }
        
//        [frcurve_ setType:kFRCurveLagrange];
//        [frcurve_ setOrder:kFRCurveCubic];
//        // We use curve parameters to create our curve
//        [frcurve_ setPoint:node.position atIndex:0];
//        [frcurve_ setPoint:bezier.controlPoint_1 atIndex:1];
//        [frcurve_ setPoint:bezier.controlPoint_2 atIndex:2];
//        [frcurve_ setPoint:bezier.endPosition atIndex:3];
//        [frcurve_ setWidth:1.f];
//        frcurve_.curve->widthFunc = &ccpCurveWidthStandard;
//        [frcurve_ invalidate];
        if (node.isGround) {
            int dx = bezier.endPosition.x - node.position.x;
            if(dx>0){
                [node flip:YES];
            }
            else{
                [node flip:NO];
            }
        }
        node.z *= xScale;
        CCAction* endMoveAction = [CCCallFuncN actionWithTarget:self selector:@selector(endMove:)];
        [node runAction:[CCScaleTo actionWithDuration:2.0f scale:node.z]];
        [node runAction:[CCSequence actions:[FRActionLagrangeTo actionWithDuration:moveTime lagrange:bezier rotare:node.isGround?NO:YES],endMoveAction,nil]];
        
    }
}

-(void) endMove:(id)sender{
    ((Bug*) sender).move = NO;
    ((Bug*) sender).goFromInstr = NO;
}

-(void) bugDead:(id)sender{
    if(((Bug*)((CCNode*)sender).parent).isGround) isGround = NO;
    [bugs removeObject:((CCNode*)sender).parent];
    [self removeChild:((CCNode*)sender).parent cleanup:YES];
}


-(void)pauseClick:(id)sender
{
    if(sound){
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    isPause = YES;
    for (Bug* node in bugs){
        [node stopAllActions];
        node.move = NO;
    }
   // [self schedule: @selector(timer:)interval:1.0f];
    //[self unschedule:@selector(timer:)];
	pauseButton.isEnabled = NO;

	menuFog = [CCLayerColor node];
	[menuFog initWithColor:ccc4(0,0,0,140)];
    [self addChild:menuFog z:30];
    menuFog.position=CGPointZero;
    
	//[CCMenuItemFont setFontName:@"Chicken Butt.ttf"];
    [CCMenuItemFont setFontSize:48/fontSize];
    CCMenuItemFont *resume = [CCMenuItemFont itemFromString:@"Resume" target:self selector: @selector(resumeClick:)];
	CCMenuItemFont *mainMenu = [CCMenuItemFont itemFromString:@"Main menu" target:self selector: @selector(mainMenuClick:)];
    
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    pauseMenu = [CCMenu menuWithItems:resume,mainMenu, nil];
	pauseMenu.position = ccp(winSize.width/2,winSize.height/2);
	[pauseMenu alignItemsVerticallyWithPadding:20.0f];
	[pauseMenu setColor:ccc3(255,255,255)];
	
	[menuFog addChild:pauseMenu z:2];
}

-(void) resumeClick:(id)sender
{
    if(sound){
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    isPause = NO;
    //[self schedule: @selector(timer:)interval:1.0f];
    pauseButton.isEnabled = YES;
    [menuFog removeAllChildrenWithCleanup:YES];
    [self removeChild:menuFog cleanup:YES];
}

-(void)mainMenuClick:(id)sender
{
    if(sound){
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    [SceneManager goMenu];
}


-(void) levelLost
{
    if(sound){
        [[SimpleAudioEngine sharedEngine] playEffect:@"levelLost.mp3"];
    }
    [self unscheduleAllSelectors];
    for (Bug* node in bugs){
        [node stopAllActions];
        [self removeChild:node cleanup:YES];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Level"];
    [[NSUserDefaults standardUserDefaults] setInteger:hud.score forKey:@"Score"];
    
    [self reportScore:hud.score forCategory:@"top"];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    isPause = YES;
	//fog = [CCLayerColor node];
	//[fog initWithColor:ccc4(0,0,0,150)];
    //[self addChild:fog z:20];
    //fog.position=CGPointZero;
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [layer1 stopAllActions];
    [sun stopAllActions];
    [fog stopAllActions];
    
    [fog setOpacity:150];
    
    hud.visible = NO;
    
    CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"outlander.ttf" fontSize:88/fontSize];
	label1.position = ccp(winSize.width/2,winSize.height-200*yScale);
	[fog addChild:label1];
    
    label1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You score : %i",hud.score] fontName:@"outlander.ttf" fontSize:50/fontSize];
	label1.position = ccp(winSize.width/2,winSize.height-300*yScale);
	[fog addChild:label1];
    
    //[CCMenuItemFont setFontName:@"Chicken Butt.ttf"];
    [CCMenuItemFont setFontSize:50/fontSize];
    
    CCMenuItemFont *mainMenu = [CCMenuItemFont itemFromString:@"MAIN MENU" target:self selector: @selector(mainMenuClick:)];
    CCMenuItemFont *replay = [CCMenuItemFont itemFromString:@"REPLAY" target:self selector: @selector(replayClick:)];
	
	CCActionInterval* color_action = [CCTintBy actionWithDuration:0.5f red:0 green:-255 blue:-255];
	CCActionInterval* color_back = [color_action reverse];
	CCFiniteTimeAction* seq = [CCSequence actions:color_action, color_back, nil];
	[replay runAction:[CCRepeatForever actionWithAction:(CCActionInterval*)seq]]; 
    
	pauseMenu = [CCMenu menuWithItems:mainMenu,replay, nil];
	pauseMenu.position = ccp(winSize.width/2,winSize.height/2-50*yScale);
    [pauseMenu alignItemsHorizontallyWithPadding:40.0f];
    [pauseMenu setColor:ccc3(255, 255, 255)];
	
	[fog addChild:pauseMenu z:2];
}

-(void) replayClick:(id)sender
{
    if(sound){
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Level"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Score"];
    
    [self stopAllActions];
    [hud setScore:0];
    currentLevel = 1;
    hud.visible = YES;
    isPause = NO;
    //[self removeAllChildrenWithCleanup:YES];
    //[self release];
    //Level* level = [Level node];
    //[SceneManager go: [Level sceneForLevel:level] i:0];
    [fog removeAllChildrenWithCleanup:YES];
    [self initLevel];
    //[hud init];
}

-(void) levelComplite{
    for (Bug* node in bugs){
        [node stopAllActions];
        [self removeChild:node cleanup:YES];
    }
    isPause = NO;
    currentLevel++;
    [hud addScore:currentLevel*2*50];
    [self showText:[NSString stringWithFormat:@"Next level bonus +%i",currentLevel*2*50]];
    [fog removeAllChildrenWithCleanup:YES];
    [self initLevel];
}

-(void) showText:(NSString *)text
{
    if(sound){
        [[SimpleAudioEngine sharedEngine] playEffect:@"bonus.mp3"];
    }
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCLabelTTF* textLabel = [CCLabelTTF labelWithString:text fontName:@"outlander.ttf" fontSize:70/fontSize]; //Marker Felt
    textLabel.position=ccp(winSize.width/2,winSize.height/2);
    textLabel.color=ccc3(10,255,10);
    textLabel.scale = 0.3f;
    [self addChild:textLabel z:30];
    [textLabel runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5f scale:1.0f],
                          [CCFadeOut actionWithDuration:0.5f],
                          [CCCallFuncN actionWithTarget:self selector:@selector(deleteSender:)],
                          nil]];
}

- (void) reportScore: (int) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            NSLog(@"ERROR sending score");
        }
    }];
}

-(void)onEnter
{
    NSLog(@"onEnter called");
    
    [super onEnter];
    //return;
    adView = [[ADBannerView alloc]initWithFrame:CGRectZero];
    adView.delegate = self;
    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    [[[CCDirector sharedDirector] openGLView] addSubview:adView];
    //adView.center = CGPointMake(adView.frame.size.width/2,40);
    adView.hidden = YES;
}

-(void)onExit
{
    adView.delegate = nil;
    [adView removeFromSuperview];
    [adView release];
    adView = nil;
    [super onExit];
}

- (BOOL)allowActionToRun
{
    NSLog(@"allowActionToRun called");
    return TRUE;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"bannerViewDidLoadAd called");
    // [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    adView.hidden = NO;
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"bannerView called - potentially with error %@",error);
    //[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    adView.hidden = YES;
    
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"bannerViewActionDidFinish called");
    
    // I resume game and music here, when paused
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
    
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"bannerViewActionShould Begin called");
    
    BOOL shouldExecuteAction = [self allowActionToRun];
    if (!willLeave && shouldExecuteAction)
    {
        //I pause my game here when the iAd is tapped
        NSLog(@"stopActionsForAd called");
        [[CCDirector sharedDirector] stopAnimation];
        [[CCDirector sharedDirector] pause];
    }
    return shouldExecuteAction;
}

@end
