//
//  MenuLayer.m
//  MenuLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "MenuLayer.h"
#import "SceneManager.h"
#import "SimpleAudioEngine.h"
#import "Level.h"

//@class HelloWorldLayer;

@implementation MenuLayer

-(void) backgroundMusicFinished
{
    //NSLog(@"music stop");
    [self setBackgroundMusic];
}

-(void) setBackgroundMusic
{

    int rndMusic = arc4random() % 5+1;
        
    //[[CDAudioManager sharedManager] playBackgroundMusic:[NSString stringWithFormat:@"track%i.mp3",rndMusic] loop:NO];

}

-(id) init{
    isConnectGC = NO;
    
	self = [super initWithColor:ccc4(255, 255, 0, 255)];
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
    //[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(backgroundMusicFinished)]; 
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"Music"]==0){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"day3.mp3"loop:YES];
    }
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int y = winSize.height/2;
    int x = winSize.width/2;
    
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        NSLog(@"iPad");
        xScale = 1.0f;
        yScale = 1.0f; 
        fontSize = 1;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && CC_CONTENT_SCALE_FACTOR() == 2){
        NSLog(@"Retina");
        xScale = (float)960/(float)1024;
        yScale = (float)640/(float)768; 
        fontSize = 2;
    }
    else{
        NSLog(@"iPhone");
        xScale = (float)480/(float)1024;
        yScale = (float)320/(float)768; 
        fontSize = 2;
    }
    
    CCSprite* background;
    background = [CCSprite spriteWithFile:@"background1.png"];
    background.position = ccp(winSize.width/2,winSize.height/2);
    background.scaleX = xScale;
    background.scaleY = yScale;
    [self addChild:background];

    [CCMenuItemFont setFontName:@"outlander.ttf"];
    [CCMenuItemFont setFontSize:80/fontSize];
    
    CCMenuItemFont* single = [CCMenuItemFont itemFromString:@"New game" target:self selector: @selector(onNewGame:)];
    single.color = ccc3(0, 100, 0);
    
    CCMenuItemFont* continueLevel = [CCMenuItemFont itemFromString:@"Continue" target:self selector: @selector(onContinue:)];
    continueLevel.color = ccc3(0, 100, 0);
    
    CCMenuItemFont* clear = [CCMenuItemFont itemFromString:@"Options" target:self selector: @selector(onOptions:)];
    clear.color = ccc3(0, 100, 0);
    
    CCMenuItemFont* leaderboard = [CCMenuItemFont itemFromString:@"Leaderboard" target:self selector: @selector(showLeaderboard:)];
    leaderboard.color = ccc3(0, 100, 0);
    
    
    int l = [[NSUserDefaults standardUserDefaults] integerForKey:@"Level"];
    int s = [[NSUserDefaults standardUserDefaults] integerForKey:@"Score"];
    if(l==0 || (l == 1 && s == 0)){
        pMenu = [CCMenu menuWithItems:single, clear, leaderboard, nil];
    }
    else{
        pMenu = [CCMenu menuWithItems:continueLevel, single, clear,leaderboard, nil];
    }
	
   	pMenu.position = ccp(x, y);
	[pMenu alignItemsVerticallyWithPadding: 30.0f];
	[self addChild:pMenu z: 2];
       
    [self authenticateLocalPlayer];
    
	return self;
}

- (void)onOptions:(id)sender{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"Sound"]==0){
     [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int y = winSize.height/2;
    int x = winSize.width/2;
    
    CCLayerColor* fog = [CCLayerColor node];
	[fog initWithColor:ccc4(0,0,0,200)];
    [self addChild:fog z:20];
    fog.position=CGPointZero;
      
	CCLabelTTF* label1 = [CCLabelTTF labelWithString:@"OPTIONS"fontName:@"outlander.ttf" fontSize:58/fontSize];
	label1.position=ccp(winSize.width/2-30,winSize.height-100);
    [fog addChild:label1 z:1];
    
    //[CCMenuItemFont setFontName: @"Chicken Butt.ttf"];
    [CCMenuItemFont setFontSize:60/fontSize];
    CCMenuItemFont* titleSound = [CCMenuItemFont itemFromString:@"Sound"];
    [titleSound setIsEnabled:NO];
    
    CCMenuItemToggle *item1 = [CCMenuItemToggle itemWithTarget:self selector:@selector(onOptionsSound:) items:
                               [CCMenuItemFont itemFromString: @"On"],
                               [CCMenuItemFont itemFromString: @"Off"],
                               nil];
    

    CCMenuItemFont* titleMusic = [CCMenuItemFont itemFromString:@"Music"];
    [titleMusic setIsEnabled:NO];
    //[CCMenuItemFont setFontName: @"Marker Felt"];
    //[CCMenuItemFont setFontSize:34];
    CCMenuItemToggle *item2 = [CCMenuItemToggle itemWithTarget:self selector:@selector(onOptionsMusic:) items:
                               [CCMenuItemFont itemFromString: @"On"],
                               [CCMenuItemFont itemFromString: @"Off"],
                               nil];
    
    int soundIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"Sound"];
    int musicIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"Music"];
    item1.selectedIndex = soundIndex;
    item2.selectedIndex = musicIndex;
    
	CCMenuItemFont* back = [CCMenuItemFont itemFromString:@"Back" target:self selector:@selector(onBack:)];
	//back.position = ccp(0,0);
    //[self removeChild:pMenu cleanup:YES];
    
    pMenu = [CCMenu menuWithItems:
                    titleSound, titleMusic,
                    item1, item2,
                    back, nil]; // 9 items.
    [pMenu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:1],
     nil];
    
    //pMenu = [CCMenu menuWithItems:back, nil];
    pMenu.position = ccp(x, y-100);
	[fog addChild:pMenu z:30];
}

-(void) onOptionsCallback:(id)sender{
    //NSLog(@"selected item: %@ index:%u", [sender selectedItem], (unsigned int) [sender selectedIndex] );
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"Sound"]==0){
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
}

-(void) onOptionsSound:(id)sender{
    if (((unsigned int)[sender selectedIndex])==0) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"select.mp3"loop:YES];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:(unsigned int)[sender selectedIndex] forKey:@"Sound"];
}
-(void) onOptionsMusic:(id)sender{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"Sound"]==0){
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:(unsigned int)[sender selectedIndex] forKey:@"Music"];
    if (((unsigned int)[sender selectedIndex])==0) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"day3.mp3"loop:YES];
    }
    else{
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
    
    //[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(backgroundMusicFinished)];
}

- (void)onNewGame:(id)sender{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"Sound"]==0){
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Level"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Score"];
    [self loadSprite];
    Level* level = [Level node];
    level.xScale = xScale;
    level.yScale = yScale;
    level.fontSize = fontSize;
    [level initWithScale];
	[SceneManager go: [Level sceneForLevel:level] i:0];
    
}

- (void)onContinue:(id)sender{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"Sound"]==0){
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    [self loadSprite];
    Level* level = [Level node];
    level.xScale = xScale;
    level.yScale = yScale;
    level.fontSize = fontSize;
    [level initWithScale];
	[SceneManager go: [Level sceneForLevel:level] i:0];
    
}

- (void)onBack:(id)sender{
    //[[SimpleAudioEngine sharedEngine] playEffect:@"bombplanted.wav"];
	[SceneManager goMenu];
}

-(void)onExit:(id)sender{
    //[[CCDirector sharedDirector] end];
}

-(void)onClear:(id)sender{
    //[[SimpleAudioEngine sharedEngine] playEffect:@"bombplanted.wav"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"numCompleteLevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"bombNumber"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"bombPower"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"playerLife"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"playerSpeed"];
}

-(void) loadSprite{
    CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [cache addSpriteFramesWithFile:@"baterfly.plist"];
	[cache addSpriteFramesWithFile:@"flower1.plist"];
	[cache addSpriteFramesWithFile:@"gas.plist"];
    [cache addSpriteFramesWithFile:@"bee.plist"];
	[cache addSpriteFramesWithFile:@"bee1.plist"];
	[cache addSpriteFramesWithFile:@"bug1.plist"];
    [cache addSpriteFramesWithFile:@"par.plist"];
	[cache addSpriteFrame:[[CCSprite spriteWithFile:@"background1_layer1.png"] displayedFrame] name:@"background1_layer1.png"];
	[cache addSpriteFrame:[[CCSprite spriteWithFile:@"background1_layer2.png"] displayedFrame] name:@"background1_layer2.png"];
	[cache addSpriteFrame:[[CCSprite spriteWithFile:@"background1_layer3.png"] displayedFrame] name:@"background1_layer3.png"];
	[cache addSpriteFrame:[[CCSprite spriteWithFile:@"background1_layer4.png"] displayedFrame] name:@"background1_layer4.png"];
    [cache addSpriteFrame:[[CCSprite spriteWithFile:@"background1_layer5.png"] displayedFrame] name:@"background1_layer5.png"];
	[cache addSpriteFrame:[[CCSprite spriteWithFile:@"par.png"] displayedFrame] name:@"par.png"];
	[cache addSpriteFrame:[[CCSprite spriteWithFile:@"sun.png"] displayedFrame] name:@"sun.png"];
}

- (void) authenticateLocalPlayer
{
    //if (isConnectGC) {
    //    return;
    //}
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            isConnectGC = YES;
            // Perform additional tasks for the authenticated player.
        }
    }];
}

- (void) showLeaderboard:(id) sender
{
    tempVC = [[UIViewController alloc] init];
    
	GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
	if (leaderboardController != nil)
	{
		leaderboardController.leaderboardDelegate = self;
		[[[[CCDirector sharedDirector] openGLView] window] addSubview:tempVC.view];
		[tempVC presentModalViewController:leaderboardController animated: YES];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppDelegate *app = [[UIApplication sharedApplication] delegate];	
    
	[tempVC dismissModalViewControllerAnimated:YES];
	[tempVC.view removeFromSuperview];
	[SceneManager goMenu];
    
	[app.window bringSubviewToFront:[app.viewController view]];
}

@end
