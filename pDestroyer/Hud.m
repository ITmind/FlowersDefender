//
//  MenuLayer.m
//  MenuLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "Hud.h"

//@class HelloWorldLayer;

@implementation Hud
@synthesize score;

-(id) init
{
    if( (self=[super init])) {
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
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        //baveuse3.TTF
        //Ice Station Awesome.ttf
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"outlander.ttf" fontSize:50/fontSize]; //Marker Felt
		scoreLabel.position=ccp(517*xScale,winSize.height-50*yScale);
		//scoreLabel.color=ccc3(0,0,0);
		[self addChild:scoreLabel];
        score = [[NSUserDefaults standardUserDefaults] integerForKey:@"Score"];
        [self addScore:score];
        
		
    }
    
    return self;
}

-(void) addScore:(int)addscore
{
    score+=addscore;
    CCActionInterval* scaleTo = [CCScaleTo actionWithDuration:0.1f scale:2.0f];
	CCActionInterval* scaleToBack = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
	CCAction* seq = [CCSequence actions:scaleTo,scaleToBack,nil];
	[scoreLabel runAction:seq];
    scoreLabel.string = [NSString stringWithFormat:@"%i",score];
}

-(void) scoreLabelToDark{
    scoreLabel.color = ccc3(255,255,255);
    CCActionInterval* TineTo = [CCTintTo actionWithDuration: 5.0f red:0 green:0 blue:0];
    CCActionInterval* Delay = [CCDelayTime actionWithDuration:20.0f];
    CCActionInterval* TineToBack = [CCTintTo actionWithDuration: 5.0f red:255 green:255 blue:255];
    CCAction* seq = [CCSequence actions:TineTo,Delay,TineToBack,nil];
    [scoreLabel runAction:seq];
}


@end
