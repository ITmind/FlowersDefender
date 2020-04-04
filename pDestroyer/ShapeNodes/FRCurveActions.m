//
//  FRCurveActions.m
//  Che
//
//  Created by Lam Pham on 11-01-29.
//  Copyright 2011 Fancy Rat Studios Inc. All rights reserved.
//

#import "FRCurveActions.h"


@implementation FRActionLagrangeTo

+(id) actionWithDuration: (ccTime) t lagrange:(ccBezierConfig) config
{	
	return [[[self alloc] initWithDuration:t lagrange:config rotare:NO] autorelease];
}

+(id) actionWithDuration: (ccTime) t lagrange:(ccBezierConfig) config rotare:(bool)rotare
{	
	return [[[self alloc] initWithDuration:t lagrange:config rotare:rotare] autorelease];
}

-(id) initWithDuration: (ccTime) t lagrange:(ccBezierConfig) config rotare:(bool)rotare
{
	if( (self=[super initWithDuration: t]) ) {
        _rotare = rotare;
		params_ = ccpCubicParamsMake(CGPointZero, config.controlPoint_1, config.controlPoint_2, config.endPosition);
	}
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	ccBezierConfig config;
	config.controlPoint_1 = params_.cp1;
	config.controlPoint_2 = params_.cp2;
	config.endPosition = params_.end;
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] lagrange: config rotare:_rotare];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	params_.start = CGPointZero;
	params_.start = [(CCNode*)target_ position];
}

-(void) update: (ccTime) t
{	
	
	CGPoint step = ccpAitkenLagrangeStep(t, (CGPoint*)&params_, CubicLagrangeKnotCount, CubicLagrangePinnedKnot, CubicLagrangeKnotCount);
    CGPoint start = ((CCNode*) target_).position;
	
    
    // calculate the rotation in degrees
    // find the point in time t with a quadratic bezier of the first 3 points
    //float qx = (powf(1-t,2)*xa + 2*(1-t)*t*xb+powf(t,2)*xc);
    //float qy = (powf(1-t,2)*ya + 2*(1-t)*t*yb+powf(t,2)*yc);
    
    // the tangent is equal to the slope between the position point and the point on the quadradic bezier
    double deltaX = (start.x-step.x);
    double deltaY = (start.y-step.y);
    //int angle = -60;
    //if(deltaY>0){ 
    //    deltaY*=-1;
    //    angle = -180;
   // }
    //else{
        
    //}
    
    //NSLog(@"%f : %f", deltaX, deltaY);
    if(_rotare && deltaY!=0 && deltaX !=0 ){
        double degrees = CC_RADIANS_TO_DEGREES(-ccpToAngle(CGPointMake(deltaX,deltaY)))-90;
        [target_ setRotation:degrees];
    }
    [target_ setPosition:step];
    //[target_ setPosition: ccpAdd( startPosition_, ccp(x,y))];
    
}

- (CCActionInterval*) reverse
{
	ccBezierConfig r;
	
	r.controlPoint_1 = ccpAdd(params_.cp2, ccpNeg(params_.end));
	r.controlPoint_2 = ccpAdd(params_.cp1, ccpNeg(params_.end));
	r.endPosition = params_.end;
	
	FRActionLagrangeTo *action = [[self class] actionWithDuration:[self duration] bezier:r];
	return action;
}

@end
