//
//  HelloWorldLayer.h
//  pDestroyer
//
//  Created by ITmind on 29.07.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "FRCurve.h"
#import "FRLines.h"
#import "FRCurveActions.h"
#import <iAd/iAd.h>

// HelloWorldLayer

@class SneakyJoystick;
@class SneakyButton;

@class Hud;
@class Flower;
@class Instrument;

@interface Level : CCLayerColor <ADBannerViewDelegate>
{
    
    NSMutableArray* bugs;
    NSMutableArray* instruments;
    bool isPause;
    Flower* flower;
    CCSprite* layer1;
    CCSprite* layer2;
    CCSprite* layer3;
    CCSprite* layer4;
    CCSprite* layer5;
    CCSprite* sun;
    
    CGPoint star[100];

	bool isMoveInstument;
	CGSize touchLoc;
	Instrument* moveInstument;
    
    
    CCLayerColor* fog;
    CCLayerColor* menuFog;
    CCMenu* pauseMenu;
    CCMenuItemImage* pauseButton;
    Hud* hud;
    
    int currentLevel;
    
    CCLabelTTF* timerLabel;
    int minutes;
    int seconds;
    
    bool music;
    bool sound;
    //CCLabelTTF* startlabel;
    
    FRCurve *frcurve_;
    
    bool isGround;
    ADBannerView *adView;
    
    float xScale,yScale,fontSize;
}
@property (retain) NSMutableArray* bugs;
@property (retain) NSMutableArray* instruments;
@property (retain) Hud* hud;
@property bool isPause;
@property int currentLevel;
@property bool sound;
@property float xScale;
@property float yScale;
@property float fontSize;

+(CCScene *) sceneForLevel:(Level*) level;

-(void) backgroundMusicFinished;
-(void) setBackgroundMusic;

-(void) initLevel;
-(void) initWithScale;

-(void) ai: (ccTime) dt;
-(void) killFlower: (ccTime) dt;
-(void) everySecond: (ccTime) dt;
-(void) addEnemy: (ccTime) dt;

//MENU
-(void) pauseClick:(id)sender;
-(void) resumeClick:(id)sender;
-(void) mainMenuClick:(id)sender;
-(void) replayClick:(id)sender;
-(void) levelLost;
-(void) levelComplite;

-(void) deleteSender:(id)sender;
-(void) endMove:(id)sender;
-(void) endSunMove:(id)sender;
-(void) startNight:(id)sender;
-(void) bugDead:(id)sender;

-(void) animateDayCycle;
-(void) showText:(NSString*) text;
-(void) addBaterfly;
- (void) reportScore: (int) score forCategory: (NSString*) category;

@end
