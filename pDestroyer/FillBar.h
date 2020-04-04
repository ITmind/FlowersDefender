#import "cocos2d.h"



@interface FillBar: CCNode
{
	CCSprite* sprite;
    int currentProgress;
}
@property int currentProgress;

-(void) drawFill;
	//progres from 0 to 100
-(void) setProgres:(int) progres;
	//add 1
-(void) addProgres;

@end

