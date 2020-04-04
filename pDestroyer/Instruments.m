#import "Instruments.h"
#import "FillBar.h"

@implementation Instrument
@synthesize startPosition,type,isActive;

-(void) instrumentOfType:(int) instrumenType  isRestores:(bool)isRestores{
    type = instrumenType;
	restoreSpeed = 0.5f;
	_isRestores = isRestores;
	isActive = true;
    numGas = 4;
    int addWidth= 0 ;
	switch(instrumenType){
        case 0:
            sprite = [CCSprite spriteWithFile:@"WatteringCan.png"];
            break;
        case 1:
            sprite = [CCSprite spriteWithSpriteFrameName:@"gas0_4.png"];
            _isGas = YES;
            addWidth = 30;
            break;
        case 2:
            sprite = [CCSprite spriteWithSpriteFrameName:@"gas1_4.png"];
            _isGas = YES;
            addWidth = 30;
            break;
        case 3:
            sprite = [CCSprite spriteWithSpriteFrameName:@"gas2_4.png"];
            _isGas = YES;
            addWidth = 30;
            break;
        case 4:
            sprite = [CCSprite spriteWithFile:@"shovel.png"];
            break;
	}
    
	sprite.position = ccp(sprite.contentSize.width/2+addWidth,sprite.contentSize.height/2+15);
	[self addChild:sprite];
    
	int fillBarHeight = 0;
	if(_isRestores)
	{
		fillBar = [[FillBar alloc] init];
		fillBarHeight = fillBar.contentSize.height;
		fillBar.position = ccp(15,0);
		[self addChild:fillBar];
	}
    
	CGSize size = CGSizeMake(sprite.contentSize.width+addWidth,sprite.contentSize.height+fillBarHeight);
	self.contentSize = size;
}

-(void) restore{
    if(_isRestores)
	{
		[self schedule:@selector(restoreTimer:) interval:0.2f];
	}
}
-(void) restoreTimer:(ccTime) dt{
    [fillBar addProgres];
	if(fillBar.currentProgress==100){
		[self unschedule:@selector(restoreTimer:)];
	}
}

-(void) use{
    if(_isRestores)
	{
		[fillBar setProgres:0];
		[self restore];
	}
    else if(_isGas){
        numGas--;
		[self unschedule:@selector(addGas:)];
        [self schedule:@selector(addGas:) interval:2.0f];
		if(numGas == 0 ){
			isActive = NO;
            [sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gasEmpety.png"]];
		}
		else if(numGas>0) {			
            [sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"gas%i_%i.png",type-1,numGas]]];
		}
    }
}

-(void) addGas:(ccTime) dt
{
	if(numGas<4){
		numGas++;
        isActive = YES;
		[sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"gas%i_%i.png",type-1,numGas]]];
	}
	else{
		[self unschedule:@selector(addGas:)];
	}
}

-(int) getCurrentStatus{
    return fillBar.currentProgress;
}

@end


