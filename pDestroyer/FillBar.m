#import "FillBar.h"

void ccDrawFilledRect( CGPoint v1, CGPoint v2 );
void ccDrawFilledRect2( CGRect rect );

@implementation FillBar
@synthesize currentProgress;

-(id) init{
    if( (self=[super init])) {
        currentProgress=0;
        sprite = [CCSprite spriteWithFile:@"fillbar.png"];
        sprite.position = ccp(sprite.contentSize.width/2,sprite.contentSize.height/2);
        [self addChild:sprite z:1];
        
        CGSize size = CGSizeMake(sprite.contentSize.width,sprite.contentSize.height);
        self.contentSize=size;
    }
    
    return self;
}

-(void) draw{
    [super draw];
	
	glColor4f(0.14, 0.87, 1.0, 1.0);
	
	[self drawFill];
}

//progres from 0 to 100
-(void) setProgres:(int) progress{
    if(progress<100){
		currentProgress = progress;
	}
    else{
        currentProgress = 0;
    }
    
}
//add 1
-(void) addProgres{
    if(currentProgress<100){
		currentProgress++;
	}
}

-(void) drawFill
{
	CGRect rect = sprite.boundingBox;
	CGRect newrect = sprite.boundingBox;
    
    if(currentProgress<=2)
    {
        newrect.origin.y = rect.origin.y + 2;
        newrect.origin.x = rect.origin.x + 1;
        newrect.size.height = rect.size.height - 5;
        newrect.size.width = currentProgress;
        ccDrawFilledRect2(newrect);
    }
    
    else if(2<currentProgress && currentProgress<=5)
    {
        newrect.origin.y = rect.origin.y + 2;
        newrect.origin.x = rect.origin.x + 1;
        newrect.size.height = rect.size.height - 5;
        newrect.size.width = 2;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y + 1;
        newrect.origin.x = rect.origin.x + 3;
        newrect.size.height = rect.size.height - 2;
        newrect.size.width = currentProgress-2;
        ccDrawFilledRect2(newrect);
    }
    else if(5<currentProgress && currentProgress<=94)
    {
        newrect.origin.y = rect.origin.y + 2;
        newrect.origin.x = rect.origin.x + 1;
        newrect.size.height = rect.size.height - 5;
        newrect.size.width = 2;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y + 1;
        newrect.origin.x = rect.origin.x + 3;
        newrect.size.height = rect.size.height - 2;
        newrect.size.width = 3;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y;
        newrect.origin.x = rect.origin.x + 6;
        newrect.size.height = rect.size.height;
        newrect.size.width = currentProgress-5;
        ccDrawFilledRect2(newrect);
    }
    else if(94<currentProgress && currentProgress<=97)
    {
        newrect.origin.y = rect.origin.y + 2;
        newrect.origin.x = rect.origin.x + 1;
        newrect.size.height = rect.size.height - 5;
        newrect.size.width = 2;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y + 1;
        newrect.origin.x = rect.origin.x + 3;
        newrect.size.height = rect.size.height - 2;
        newrect.size.width = 5;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y;
        newrect.origin.x = rect.origin.x + 6;
        newrect.size.height = rect.size.height;
        newrect.size.width = 90;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y + 1;
        newrect.origin.x = rect.origin.x + 95;
        newrect.size.height = rect.size.height-2;
        newrect.size.width = currentProgress-94;
        ccDrawFilledRect2(newrect);
    }
    else if(97<currentProgress && currentProgress<100)
    {
        newrect.origin.y = rect.origin.y + 2;
        newrect.origin.x = rect.origin.x + 1;
        newrect.size.height = rect.size.height - 5;
        newrect.size.width = 2;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y + 1;
        newrect.origin.x = rect.origin.x + 3;
        newrect.size.height = rect.size.height - 2;
        newrect.size.width = 5;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y;
        newrect.origin.x = rect.origin.x + 6;
        newrect.size.height = rect.size.height;
        newrect.size.width = 90;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y + 1;
        newrect.origin.x = rect.origin.x + 95;
        newrect.size.height = rect.size.height-2;
        newrect.size.width = 3;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y+2;
        newrect.origin.x = rect.origin.x + 98;
        newrect.size.height = rect.size.height-5;
        newrect.size.width = currentProgress-98;
        ccDrawFilledRect2(newrect);
    }
    else if(currentProgress==100)
    {
        newrect.origin.y = rect.origin.y + 2;
        newrect.origin.x = rect.origin.x + 1;
        newrect.size.height = rect.size.height - 5;
        newrect.size.width = 2;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y + 1;
        newrect.origin.x = rect.origin.x + 3;
        newrect.size.height = rect.size.height - 2;
        newrect.size.width = 5;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y;
        newrect.origin.x = rect.origin.x + 6;
        newrect.size.height = rect.size.height;
        newrect.size.width = 90;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y + 1;
        newrect.origin.x = rect.origin.x + 95;
        newrect.size.height = rect.size.height-2;
        newrect.size.width = 3;
        ccDrawFilledRect2(newrect);
        
        newrect.origin.y = rect.origin.y+2;
        newrect.origin.x = rect.origin.x + 98;
        newrect.size.height = rect.size.height-5;
        newrect.size.width = 1;
        ccDrawFilledRect2(newrect);
    }
}

@end


void ccDrawFilledRect( CGPoint v1, CGPoint v2 )
{
	CGPoint poli[]={v1,CGPointMake(v1.x,v2.y),v2,CGPointMake(v2.x,v1.y)};


	CC_DISABLE_DEFAULT_GL_STATES();
	glEnableClientState(GL_VERTEX_ARRAY);

	glVertexPointer(2, GL_FLOAT, 0, poli);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);

	CC_ENABLE_DEFAULT_GL_STATES();

}

void ccDrawFilledRect2(CGRect rect)
{
	CGPoint from = rect.origin;
	CGPoint to = rect.origin;
	to.x+=rect.size.width;
	to.y+=rect.size.height;
	ccDrawFilledRect( from, to );
}

