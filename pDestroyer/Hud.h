//
//  MenuLayer.h
//  MenuLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Hud : CCLayer {
    int score;
    CCLabelTTF* scoreLabel;
    float xScale,yScale,fontSize;
    
}
@property int score;

-(void) addScore:(int) addscore;
-(void) scoreLabelToDark;

@end
