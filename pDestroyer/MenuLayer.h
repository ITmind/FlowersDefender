//
//  MenuLayer.h
//  MenuLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "AppDelegate.h"

//#import "HelloWorldLayer.h"

@interface MenuLayer : CCLayerColor <GKLeaderboardViewControllerDelegate> {
    CCMenu* pMenu;
    UIViewController* tempVC;
    bool isConnectGC;
    
    float xScale,yScale,fontSize;
}

- (void)onNewGame:(id)sender;
- (void)onContinue:(id)sender;
- (void)onOptions:(id)sender;
- (void)onOptionsSound:(id)sender;
- (void)onOptionsMusic:(id)sender;
- (void)onBack:(id)sender;
- (void) showLeaderboard:(id) sender;

- (void)backgroundMusicFinished;
-(void) setBackgroundMusic;
-(void) loadSprite;
- (void) authenticateLocalPlayer;

@end
