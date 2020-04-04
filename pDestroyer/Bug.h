#import "cocos2d.h"

@interface Bug : CCNode {
@private
    NSString* type;
    int colorType;
	bool isActive;
	CCSprite* sprite;
    bool move;
    int numAnimFrames;
    //CCAction* moveAnimAction;
    int x;
    int y;
    float z;
    bool eating;
    bool isGround;
    bool goFromInstr;
    
}

@property (retain) NSString* type;
@property bool isActive;
@property bool move;
@property int x;
@property int y;
@property float z;
@property bool eating;
@property bool isGround;
@property bool goFromInstr;
@property int colorType;

-(void) AI;
-(void) bugOfType:(NSString*)bugType colorType:(int)color;
-(void) kill;
-(CCAnimation*) createAnim;
-(void) setColor:(ccColor3B) newColor;
-(void) flip:(bool) flip;

@end

