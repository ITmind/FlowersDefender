#import "cocos2d.h"

@interface Flower: CCNode
{
	CCSprite* sprite;
    int scaleFactor;
	int lives;
	int numBugs;
    bool isGrowing;
    bool isScale;
    bool full;
}
@property bool isGrowing;
@property int lives;
@property bool full;

-(void) initFlower;
-(CGSize) getSize;
-(CGRect) boundingBox;
-(void) growing;
-(void) endScale:(CCNode*) sender;
-(void) removeLive;

-(void) addBug;
-(void) removeBug;

-(void) removeLives:(ccTime) dt;
-(void) addLives:(int) numLives;

@end

