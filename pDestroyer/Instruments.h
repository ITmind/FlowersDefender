#import "cocos2d.h"

@class FillBar;

@interface Instrument: CCNode
{
	bool isActive;
	bool _isRestores;
	CCSprite* sprite;
	FillBar* fillBar;
	ccTime restoreSpeed;
    int type;
    CGPoint startPosition;
    bool _isGas;
	int numGas;
}
@property CGPoint startPosition;
@property int type;
@property bool isActive;

-(void) instrumentOfType:(int) instrumenType  isRestores:(bool)isRestores;
-(void) restore;
-(void) restoreTimer:(ccTime) dt;
-(void) use;
-(void) addGas:(ccTime) dt;
-(int) getCurrentStatus;

@end

