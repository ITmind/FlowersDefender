#import "Bug.h"


@implementation Bug
@synthesize type,isActive,move,x,y,z,eating,isGround,goFromInstr,colorType;

-(void) bugOfType:(NSString*)bugType colorType:(int)color
{
    move = false;
	type = bugType;
    colorType = color;
	isActive = true;
    x=0;y=0;z=1.0f;
    eating = NO;
    isGround = NO;
    goFromInstr = NO;
    

    sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@%i_anim0.png",type,colorType]];
    if(type == @"baterfly"){
        numAnimFrames = 6;
    }
    
    else if(type == @"bee"){
        numAnimFrames = 4;
    }
    else if(type == @"bee1"){
        numAnimFrames = 5;
    }
    else if(type == @"bug"){
        numAnimFrames = 4;
        isGround = YES;
    }
    
	//sprite.position = ccp(sprite.contentSize.width/2,sprite.contentSize.height/2);
	[self addChild:sprite];
	//CGSize size = CGSizeMake(sprite.contentSize.width,sprite.contentSize.height);
	//self.contentSize = size;
    
    CCAnimation* moveAnim = [self createAnim];
	CCAction* moveAnimAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:moveAnim restoreOriginalFrame:true]];
	//moveAnimAction->retain();
	[sprite runAction:moveAnimAction];
	
    
}

-(CCAnimation*) createAnim
{
    NSMutableArray *animFrames = [NSMutableArray array];
    for (int i = 0; i<numAnimFrames; i++) {
        CCSpriteFrame* tempSprite = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%i_anim%i.png",type,colorType,i]];
        [animFrames addObject: tempSprite];
    }
    for (int i = numAnimFrames-2; i>0; i--) {
        CCSpriteFrame* tempSprite = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%i_anim%i.png",type,colorType,i]];
        [animFrames addObject: tempSprite];
    }
    return [CCAnimation animationWithFrames:animFrames delay:0.1f];
}

-(void) AI{
    
}

-(void) kill{
    [self stopAllActions];
	isActive = false;
	move = false;
    CCAction* bugDeadAction = [CCCallFuncN actionWithTarget:self.parent selector:@selector(bugDead:)];
	[sprite runAction:[CCSequence actions:[CCFadeOut actionWithDuration:1.0f],bugDeadAction,nil]];
}

-(void) setColor:(ccColor3B)newColor{
    sprite.color = newColor;
}

-(void) flip:(bool) flip{
    [sprite runAction:[CCFlipX actionWithFlipX:flip]];
}
@end

