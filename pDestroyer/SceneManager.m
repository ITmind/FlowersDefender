//
//  SceneManager.m
//  SceneManager
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "SceneManager.h"


@interface SceneManager ()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end


@implementation SceneManager

+(void) goMenu{
	CCLayer *layer = [MenuLayer node];
	[SceneManager go: layer];
}

+(void) go: (CCLayer *) layer{
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
	if ([director runningScene]) {
		[director replaceScene:newScene];
	}else {
		[director runWithScene:newScene];		
	}
}

+(void) go: (CCScene*) scene i:(int) i
{
	CCDirector *director = [CCDirector sharedDirector];
	if ([director runningScene]) {
		[director replaceScene:scene];
	}else {
		[director runWithScene:scene];		
	}
}

+(CCScene *) wrap: (CCLayer *) layer{
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}

@end
