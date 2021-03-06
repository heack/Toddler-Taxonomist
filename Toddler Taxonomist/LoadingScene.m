//
//  LoadingScene.m
//  FieldHospital
//
//  Created by Clay Heaton on 4/26/12.
//  Copyright 2012 The Perihelion Group. All rights reserved.
//

#import "LoadingScene.h"
#import "MainMenuLayer.h"
#import "BoardLayer.h"
#import "InfoLayer.h"


@interface LoadingScene (PrivateMethods)
-(void) update:(ccTime)delta;
@end

@implementation LoadingScene

+(id) sceneWithTargetScene:(TargetScenes)targetScene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	// This creates an autorelease object of self (the current class: LoadingScene)
	return [[self alloc] initWithTargetScene:targetScene];

}

-(id) initWithTargetScene:(TargetScenes)targetScene
{
	if ((self = [super init]))
	{
		targetScene_ = targetScene;
		
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"Loading..." fntFile:@"audimat_36_white.fnt"];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position = CGPointMake(size.width / 2, size.height / 2);
		[self addChild:label];
		
		// Must wait one frame before loading the target scene!
		// Two reasons: first, it would crash if not. Second, the Loading label wouldn't be displayed.
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) update:(ccTime)delta
{
	// It's not strictly necessary, as we're changing the scene anyway. But just to be safe.
	[self unscheduleAllSelectors];
	
	// Decide which scene to load based on the TargetScenes enum.
	// You could also use TargetScene to load the same with using a variety of transitions.
	switch (targetScene_)
	{
		case TargetSceneMainMenuScene:
        {
            
            CCScene *mainMenuScene = [MainMenuLayer scene];
            MainMenuLayer *mainMenuLayer = (MainMenuLayer *)[mainMenuScene getChildByTag:1];
            
            InfoLayer *infoLayer = [[InfoLayer alloc] initWithColor:ccc4(0, 0, 0, 220)];
            
            [mainMenuLayer addInfoLayerAsChild:infoLayer];
            infoLayer = nil;
            
            //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mainMenuScene]];
            
            
            
            CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:1 scene:mainMenuScene withColor:ccBLACK];
			[[CCDirector sharedDirector] replaceScene:transition];
            break;
        }

		case TargetSceneBoardScene:
		{
            
			CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:1 scene:[BoardLayer scene] withColor:ccBLACK];
			[[CCDirector sharedDirector] replaceScene:transition];
			break;
		}
			
		default:
			// Always warn if an unspecified enum value was used. It's a reminder for yourself to update the switch
			// whenever you add more enum values.
			NSAssert2(nil, @"%@: unsupported TargetScene %i", NSStringFromSelector(_cmd), targetScene_);
			break;
	}

}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    // [super dealloc];
}

@end
