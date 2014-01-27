//
//  IntroScene.m
//  Menu Cascade Demo
//
//  Created by Richard Groves on 27/01/2014.
//  Copyright NoodlFroot Ltd. 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "NewtonScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Spinning scene button
    CCButton *spinningButton = [CCButton buttonWithTitle:@"[ Simple Sprite ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    spinningButton.positionType = CCPositionTypeNormalized;
    spinningButton.position = ccp(0.5f, 0.35f);
    [spinningButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:spinningButton];

    // Next scene button
    CCButton *newtonButton = [CCButton buttonWithTitle:@"[ Newton Physics ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    newtonButton.positionType = CCPositionTypeNormalized;
    newtonButton.position = ccp(0.5f, 0.20f);
    [newtonButton setTarget:self selector:@selector(onNewtonClicked:)];
    [self addChild:newtonButton];
	
	// RAG - Richard Groves - Demo menu here
	[self createTestMenu:ccp(self.contentSize.width/2, 0.8f*self.contentSize.height) withCascadeToItems:YES];
	
	[self createTestMenu:ccp(self.contentSize.width/2, 0.9f*self.contentSize.height) withCascadeToItems:NO];
	
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    // start newton scene with transition
    // the current scene is pushed, and thus needs popping to be brought back. This is done in the newton scene, when pressing back (upper left corner)
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene]
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------

#pragma mark - Create a test menu
// Params: where on the self node the menu goes, whether to cascade the opacity and colour flags down into the menuItems (ie demo the problem)
- (void)createTestMenu:(CGPoint)menuPos withCascadeToItems:(BOOL)cascadeToItems
{
	// Menu example - with cascade set to the 'menuItems'
	NSString* item1Title = [NSString stringWithFormat:@"Item1 - %@", cascadeToItems ? @"with cascade to items" : @"without cascade to items"];
	CCButton* item1 = [CCButton buttonWithTitle:item1Title];
	item1.block = ^(id sender)
	{
		// Item 1 chosen
	};
	
	CCButton* item2 = [CCButton buttonWithTitle:@"Item2"];
	item2.block = ^(id sender)
	{
		// Item 2 chosen
	};
	
	CCButton* item3 = [CCButton buttonWithTitle:@"Item3"];
	item3.block = ^(id sender)
	{
		// Item 2 chosen
	};
	
	NSArray* menuItems = @[item1, item2, item3];
	
	// Use 	CCLayoutBox to replicate the menu layout feature
	CCLayoutBox* menuBox = [[CCLayoutBox alloc] init];
	
	// Have to set up direction and spacing before adding children
	menuBox.direction = CCLayoutBoxDirectionHorizontal;
	menuBox.spacing = 20.0f;
	
	menuBox.position = menuPos;
	menuBox.anchorPoint = ccp(0.5f, 0.5f);
	
	menuBox.cascadeColorEnabled = YES;
	menuBox.cascadeOpacityEnabled = YES;
	
	// No direct way of adding an array of items (and also need to flip the cascade flags on them all...)
	for (CCNode* item in menuItems)
	{
		if (cascadeToItems)
			item.cascadeColorEnabled = item.cascadeOpacityEnabled = YES;
		
		[menuBox addChild:item];
	}
	
	// Have to do this *after* all children are added and have the cascade flags set
	menuBox.opacity = 0.0f;
	
	// RAG: this will only work if cascadeToItems is YES
	[menuBox runAction:[CCActionRepeatForever actionWithAction:[CCActionFadeIn actionWithDuration:1.0f]]];
	
	//	NSLog(@"Menu size: %.1f, %.1f", menuBox.contentSize.width, menuBox.contentSize.height);
	
	// Add the menu to this layer
	[self addChild:menuBox];
}

@end
