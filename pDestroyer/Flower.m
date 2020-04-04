#import "Flower.h"
#import "Level.h"

@implementation Flower
@synthesize isGrowing;
@synthesize lives,full;

-(void) initFlower{
    full = NO;
    scaleFactor = 0;
    lives = 255;
    isGrowing = NO;
    isScale = NO;
    numBugs = 0;
    [sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"flower1_0.png"]];
    //Level* level = (Level*)self.parent;
    //sprite.scaleX = level.xScale;
    //sprite.scaleY = level.yScale;
    [self growing];
}

-(id) init{
    if( (self=[super init])) {
        sprite = [CCSprite node];
        [self addChild:sprite];
        CGSize size = CGSizeMake(sprite.contentSize.width,sprite.contentSize.height);
        self.contentSize = size; 
    }
    return self;
}

-(CGSize) getSize{
    return sprite.contentSize;
}

-(CGRect) boundingBox
{
    Level* level = (Level*)self.parent;
	CGRect bounding = sprite.boundingBox;
    bounding.origin.x*=level.yScale;
	bounding.origin.y*=level.xScale;
	bounding.origin.x+=self.position.x;
	bounding.origin.y+=self.position.y;
    bounding.size.height*=level.yScale;
    bounding.size.width*=level.xScale;
	return bounding;
}

-(void) removeLive;
{
	if(lives>0){
		lives--;
		sprite.color = ccc3(lives,lives,lives);
	}
}

-(void) addLives:(int) numLives
{
    ccColor3B curColor = sprite.color;
    if(curColor.b+numLives<255){
        lives = curColor.b+numLives;
    }
    else{
        lives = 255;
    }
    
    CCActionInterval* tineTo = [CCTintTo actionWithDuration: 0.3f red:lives green:lives blue:lives];
    [sprite runAction:tineTo];
    if(lives>200){
        [self growing];
    }
    //sprite.color = ccc3(lives,lives,lives);
}

-(void) addBug
{
	if(numBugs==0){
		[self schedule:@selector(removeLives:) interval:0.1f];
        numBugs++;
	}
	else if(numBugs<1){
		numBugs++;
	}
}

-(void) removeBug
{
	if(numBugs==0){
		[self unschedule:@selector(removeLives:)];
	}
	else if(numBugs>0){
		numBugs--;
	}
}

-(void) removeLives:(ccTime) dt
{
	[self removeLive];
    if(scaleFactor*36>lives){
        full = NO;
        [self growing];
    }
}

-(void) growing
{
    Level* level = (Level*)self.parent;
    //if(0<=scaleFactor && scaleFactor<7 && !isScale){
    if(!isScale){
        isScale = YES;
        [sprite stopAllActions];
        sprite.anchorPoint = ccp(0.5f,0);
        if(lives>200){
            CCFiniteTimeAction* scale = [CCScaleTo actionWithDuration:3.0f scale:1.1f];
            CCAction* endScaleAction = [CCCallFuncN actionWithTarget:self selector:@selector(endScale:)];
            CCAction* seq = [CCSequence actions:scale,endScaleAction,NULL];
            [sprite runAction:seq];
            isGrowing = YES;
        }
        else if ((scaleFactor*36>lives)) {
            CCFiniteTimeAction* scale = [CCScaleTo actionWithDuration:3.0f scale:0.9f];
            CCAction* endScaleAction = [CCCallFuncN actionWithTarget:self selector:@selector(endScale:)];
            CCAction* seq = [CCSequence actions:scale,endScaleAction,NULL];
            [sprite runAction:seq];
            isGrowing = NO;
        }
        else{
            isScale = NO;
            isGrowing = NO;
        }
        
    }
}

-(void) endScale:(CCNode*) sender
{
    if (((Level*)self.parent).isPause) {
        return;
    }
    isScale = NO;
    if(scaleFactor*36>lives && lives<=200){
        scaleFactor--;
        full = NO;
    }
    else{
        scaleFactor++;
        if (scaleFactor>6) {
            full = YES;
        }
    }
    
	if(0<=scaleFactor && scaleFactor<7){
		[self removeChild:sprite cleanup:YES];
		sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"flower1_%i.png",scaleFactor]];//(frname(scaleFactor));
		sprite.color = ccc3(lives,lives,lives);
        //Level* level = (Level*)self.parent;
        //sprite.scaleX = level.xScale;
        //sprite.scaleY = level.yScale;
		[self addChild:sprite];
        [self growing];
	}
    
    
}

@end
