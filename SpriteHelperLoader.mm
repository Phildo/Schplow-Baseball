//  This file was generated with SpriteHelper
//  http://spritehelper.wordpress.com
//
//  SpriteHelperLoader.mm
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  This notice may not be removed or altered from any source distribution.
//  By "software" the author refers to this code file and not the application 
//  that was used to generate this file.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "SpriteHelperLoader.h"

/// converts degrees to radians
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0f * (float)M_PI)
/// converts radians to degrees
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)

#if TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

#define LHRectFromString(str) CGRectFromString(str)
#define LHPointFromString(str) CGPointFromString(str)
#else
#define LHRectFromString(str) NSRectToCGRect(NSRectFromString(str))
#define LHPointFromString(str) NSPointToCGPoint(NSPointFromString(str))
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SpriteHelperLoader (Private)

-(CCSprite*) spriteFromDictionary:(NSDictionary*)spriteProp;

-(void) setSpriteProperties:(CCSprite*)ccsprite
           spriteProperties:(NSDictionary*)spriteProp
                   position:(CGPoint)point;

-(void) setFixtureDefPropertiesFromDictionary:(NSDictionary*)spritePhysic 
									  fixture:(b2FixtureDef*)shapeDef;

-(b2Body*) b2BodyFromDictionary:(NSDictionary*)spritePhysic
			   spriteProperties:(NSDictionary*)spriteProp
						   data:(CCSprite*)ccsprite 
						  world:(b2World*)world;

-(void)loadSpriteHelperSceneFile:(NSString*)levelFile 
                     inDirectory:(NSString*)subfolder
                    imgSubfolder:(NSString*)imgFolder;
@end

@implementation SpriteHelperLoader
////////////////////////////////////////////////////////////////////////////////////
-(id) initWithContentOfFile:(NSString*)sceneFile
{
	NSAssert(nil!=sceneFile, @"Invalid file given to SpriteHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"SpriteHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self loadSpriteHelperSceneFile:sceneFile inDirectory:@"" imgSubfolder:@""];
	
	
	return self;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithContentOfFile:(NSString*)sceneFile 
			 sceneSubfolder:(NSString*)sceneFolder
{
	NSAssert(nil!=sceneFile, @"Invalid file given to SceneHelperLoader");
	
	if(!(self = [super init]))
	{
		NSLog(@"SceneHelperLoader ****ERROR**** : [super init] failer ***");
		return self;
	}
	
	[self loadSpriteHelperSceneFile:sceneFile 
                       inDirectory:sceneFolder 
                      imgSubfolder:@""];
	
	return self;
	
}
////////////////////////////////////////////////////////////////////////////////
-(CCSprite*) spriteWithUniqueName:(NSString*)name 
                       atPosition:(CGPoint)point 
                          inLayer:(CCLayer*)layer
{
    NSDictionary* spriteProperties = [shSprites objectForKey:name];
    
    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        CCSprite* spr = [self spriteFromDictionary:texProp];
        
        [self setSpriteProperties:spr spriteProperties:texProp position:point];
        
        if(nil != layer)
            [layer addChild:spr z:[[texProp objectForKey:@"ZOrder"] intValue]];
        
        return spr;
    }
    
    return nil;
}
////////////////////////////////////////////////////////////////////////////////
-(CCSprite*) spriteWithUniqueName:(NSString*)name atPosition:(CGPoint)point
{
	return [self spriteWithUniqueName:name 
                           atPosition:point
                              inLayer:nil];
}
////////////////////////////////////////////////////////////////////////////////
-(CCSprite*) spriteWithUniqueName:(NSString*)name
{
	return [self spriteWithUniqueName:name 
                    atPosition:ccp(0.0f, 0.0f) 
                       inLayer:nil];
}
////////////////////////////////////////////////////////////////////////////////
-(CCAction*) actionForFrames:(NSArray*)frameNames delay:(float)delay
{
    if([frameNames count] == 0)
        return nil;
    
    NSString* frame1Name = [frameNames objectAtIndex:0];
    NSDictionary* spriteProperties = [shSprites objectForKey:frame1Name];

    
    NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
    CCSprite* spr = [self spriteFromDictionary:texProp];
    
    NSMutableArray *frames = [NSMutableArray array];
    
    for(unsigned int i = 1; i < [frameNames count]; ++i)
    {
        NSString* frameName = [frameNames objectAtIndex:i];

        NSDictionary* spriteProperties = [shSprites objectForKey:frameName];
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        
        CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:[spr texture] 
                                                          rect:LHRectFromString([texProp objectForKey:@"Frame"])];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame
                                                               name:frameName];
        
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                           frameName]];
        
    }        
    
    CCAnimation *anim = [CCAnimation animationWithFrames:frames delay:delay];
    
    CCAction* animAct = [CCRepeatForever actionWithAction:
                         [CCAnimate actionWithAnimation:anim 
                                   restoreOriginalFrame:NO]];
    
    return animAct;
    
}

-(CCAction*) actionForFrames:(NSString*)name 
                      frames:(int)frameNo 
                       delay:(float)delay
{
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    
    for(int i = 1; i < frameNo +1; ++i)
    {
        NSString* frame = [NSString stringWithFormat:@"%@%d", name, i];    
        [frames addObject:frame];
        
    }

    CCAction* act = [self actionForFrames:frames delay:delay];
    
    [frames release];
    
    return act;
}

-(CCSprite*) animSpriteWithUniqueName:(NSArray*)frameNames
                             position:(CGPoint)point
                                layer:(CCLayer*)layer
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction
{
    
    if([frameNames count] == 0)
        return nil;
    
    NSString* frame1Name = [frameNames objectAtIndex:0];
    NSDictionary* spriteProperties = [shSprites objectForKey:frame1Name];
    
    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        
        CCSprite* spr = [self spriteFromDictionary:texProp];
        [self setSpriteProperties:spr spriteProperties:texProp position:point];
        
        CCSpriteFrame* frame1 = [CCSpriteFrame frameWithTexture:[spr texture] 
                                                           rect:LHRectFromString([texProp objectForKey:@"Frame"])];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame1 
                                                               name:frame1Name];
        
        
        NSMutableArray *frames = [NSMutableArray array];
        
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                           frame1Name]];
        
        
        for(unsigned int i = 1; i < [frameNames count]; ++i)
        {
            NSString* frameName = [frameNames objectAtIndex:i];
            NSDictionary* frameSprite = [shSprites objectForKey:frameName];
            NSDictionary* rectTexProp = [frameSprite objectForKey:@"TextureProperties"];
            
            CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:[spr texture] 
                                                              rect:LHRectFromString([rectTexProp objectForKey:@"Frame"])];
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame 
                                                                   name:frameName];
            
            
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                               frameName]];            
        }
        
        CCAnimation *anim = [CCAnimation animationWithFrames:frames delay:delay];
        
        CCAction* animAct; 
        if(numberOfRepeats != 0)
            animAct = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:anim 
                                                           restoreOriginalFrame:NO] 
                                           times:numberOfRepeats];
        else
            animAct = [CCRepeatForever actionWithAction:
                                 [CCAnimate actionWithAnimation:anim 
                                           restoreOriginalFrame:NO]];
            
        [spr runAction:animAct];
                
        
        if(animAction != nil)
            *animAction = animAct;
        
        if(nil != layer)
            [layer addChild:spr z:[[texProp objectForKey:@"ZOrder"] intValue]];
        
        return spr;
    }
    
    return nil;

}

-(CCSprite*) animSpriteWithUniqueName:(NSString*)name 
                             position:(CGPoint)point
                                layer:(CCLayer*)layer
                               frames:(int)frameNo 
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction
{
 
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    
    for(int i = 1; i < frameNo +1; ++i)
    {
        NSString* frame = [NSString stringWithFormat:@"%@%d", name, i];    
        [frames addObject:frame];
        
    }
    
    CCSprite* spr = [self animSpriteWithUniqueName:frames
                                          position:point
                                             layer:layer
                                             delay:delay
                                           repeats:numberOfRepeats
                                        saveAction:animAction];
    
    [frames release];
    
    return spr;

}
////////////////////////////////////////////////////////////////////////////////
-(CCSprite*) animSpriteWithUniqueName:(NSString*)name 
                             position:(CGPoint)point
                               frames:(int)frameNo 
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction
{
    return [self animSpriteWithUniqueName:name 
                                 position:point 
                                    layer:nil 
                                   frames:frameNo 
                                    delay:delay
                                  repeats:numberOfRepeats
                               saveAction:animAction];
}
////////////////////////////////////////////////////////////////////////////////
-(CCSprite*) animSpriteWithUniqueName:(NSString*)name 
                               frames:(int)frameNo 
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction
{
    return [self animSpriteWithUniqueName:name 
                                 position:ccp(0.0f, 0.0f)
                                    layer:nil 
                                   frames:frameNo 
                                    delay:delay
                                  repeats:numberOfRepeats
                               saveAction:animAction];    
}

-(CCSprite*) animSpriteWithUniqueName:(NSString*)name 
                             position:(CGPoint)point
                                layer:(CCLayer*)layer
                           startFrame:(int)start
                             endFrame:(int)end
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction
{
    
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    
    for(int i = start; i < end +1; ++i)
    {
        NSString* frame = [NSString stringWithFormat:@"%@%d", name, i];    
        [frames addObject:frame];
        
    }
    
    CCSprite* spr = [self animSpriteWithUniqueName:frames
                                          position:point
                                             layer:layer
                                             delay:delay
                                           repeats:numberOfRepeats
                                        saveAction:animAction];
    
    [frames release];
    
    return spr;

}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
-(b2Body*) bodyWithUniqueName:(NSString*)name 
                     position:(CGPoint)point 
                        layer:(CCLayer*)layer 
                        world:(b2World*)world
{
    
    NSDictionary* spriteProperties = [shSprites objectForKey:name];
    
    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        CCSprite* spr = [self spriteFromDictionary:texProp];
        [self setSpriteProperties:spr spriteProperties:texProp position:point];
        
        NSDictionary* phyProp = [spriteProperties objectForKey:@"PhysicProperties"];

        
        b2Body* body = [self b2BodyFromDictionary:phyProp
                                 spriteProperties:texProp
                                             data:spr
                                            world:world];
        if(nil != layer)
            [layer addChild:spr z:[[texProp objectForKey:@"ZOrder"] intValue]];
        
        return body;
    }

	return 0;
}

-(b2Body*) animBodyWithUniqueName:(NSArray*)frameNames
                         position:(CGPoint)point 
                            delay:(float)delay 
                       saveAction:(CCAction **)animAction 
                          repeats:(int)numberOfRepeats
                            layer:(CCLayer *)layer 
                            world:(b2World*)world
{
    if([frameNames count] == 0)
        return nil;
    
    NSString* frame1Name = [frameNames objectAtIndex:0];
    NSDictionary* spriteProperties = [shSprites objectForKey:frame1Name];

    if(nil != spriteProperties)
    {
        NSDictionary* texProp = [spriteProperties objectForKey:@"TextureProperties"];
        
        CCSprite* spr = [self animSpriteWithUniqueName:frameNames 
                                              position:point
                                                 layer:layer
                                                 delay:delay
                                               repeats:numberOfRepeats
                                            saveAction:animAction];
        
        NSDictionary* phyProp = [spriteProperties objectForKey:@"PhysicProperties"];
        
        
        b2Body* body = [self b2BodyFromDictionary:phyProp
                                 spriteProperties:texProp
                                             data:spr
                                            world:world];
        
        return body;
    }
    
	return 0;
}

-(b2Body*) animBodyWithUniqueName:(NSString*)name
                         position:(CGPoint)point 
                           frames:(int)frameNo
                            delay:(float)delay
                          repeats:(int)numberOfRepeats
                       saveAction:(CCAction**)animAction
                            layer:(CCLayer*)layer
                            world:(b2World*)world
{
    
    
    
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    
    for(int i = 1; i < frameNo +1; ++i)
    {
        NSString* frame = [NSString stringWithFormat:@"%@%d", name, i];    
        [frames addObject:frame];
        
    }
    
    b2Body* body = [self animBodyWithUniqueName:frames
                                       position:point
                                          delay:delay 
                                     saveAction:animAction 
                                        repeats:numberOfRepeats
                                          layer:layer 
                                          world:world];
    
    [frames release];
    
    return body;

}
////////////////////////////////////////////////////////////////////////////////
-(void) release
{
	[shSprites release];
}
///////////////////////////PRIVATE METHODS//////////////////////////////////////
-(CCSprite*) spriteFromDictionary:(NSDictionary*)spriteProp
{
	return [CCSprite spriteWithFile:[spriteProp objectForKey:@"Image"] 
                               rect:LHRectFromString([spriteProp objectForKey:@"Frame"])];
}
////////////////////////////////////////////////////////////////////////////////
-(void) setSpriteProperties:(CCSprite*)ccsprite
           spriteProperties:(NSDictionary*)spriteProp
                   position:(CGPoint)point
{
	[ccsprite setPosition:point];
	[ccsprite setOpacity:255*[[spriteProp objectForKey:@"Opacity"] floatValue]];
	CGRect color = LHRectFromString([spriteProp objectForKey:@"Color"]);
	[ccsprite setColor:ccc3(255*color.origin.x, 255*color.origin.y, 255*color.size.width)];
	CGPoint scale = LHPointFromString([spriteProp objectForKey:@"Scale"]);
	[ccsprite setScaleX:scale.x];
	[ccsprite setScaleY:scale.y];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) setFixtureDefPropertiesFromDictionary:(NSDictionary*)spritePhysic 
									  fixture:(b2FixtureDef*)shapeDef
{
	shapeDef->density = [[spritePhysic objectForKey:@"Density"] floatValue];
	shapeDef->friction = [[spritePhysic objectForKey:@"Friction"] floatValue];
	shapeDef->restitution = [[spritePhysic objectForKey:@"Restitution"] floatValue];
	shapeDef->isSensor = [[spritePhysic objectForKey:@"IsSensor"] boolValue];
	
	shapeDef->filter.categoryBits = [[spritePhysic objectForKey:@"Category"] intValue];
	shapeDef->filter.maskBits = [[spritePhysic objectForKey:@"Mask"] intValue];
	shapeDef->filter.groupIndex = [[spritePhysic objectForKey:@"Group"] intValue];
}
////////////////////////////////////////////////////////////////////////////////////
-(b2Body*) b2BodyFromDictionary:(NSDictionary*)spritePhysic
			   spriteProperties:(NSDictionary*)spriteProp
						   data:(CCSprite*)ccsprite 
						  world:(b2World*)_world
{
	b2BodyDef bodyDef;	
	
	//b2Vec2 position = b2Vec2([ccsprite position].x/PTM_RATIO,[ccsprite position].y/PTM_RATIO);
	
	bodyDef.type = (b2BodyType)[[spritePhysic objectForKey:@"PhysicType"] intValue];
	bodyDef.position.Set([ccsprite position].x/PTM_RATIO,[ccsprite position].y/PTM_RATIO);
	//bodyDef.angle = DEGREES_TO_RADIANS(-1*[[spriteProp objectForKey:@"Angle"] floatValue]);
	
	bodyDef.userData = ccsprite;
	b2Body* body = _world->CreateBody(&bodyDef);
	
	body->SetFixedRotation([[spritePhysic objectForKey:@"IsFixedRot"] boolValue]);
	
	NSArray* fixtures = [spritePhysic objectForKey:@"Fixtures"];
    
	CGPoint scale = LHPointFromString([spriteProp objectForKey:@"Scale"]); 
	CGRect frame = LHRectFromString([spriteProp objectForKey:@"Frame"]);
    CGSize size = frame.size;
    
	if(fixtures == nil || [fixtures count] == 0 || [[fixtures objectAtIndex:0] count] == 0)
	{
		b2PolygonShape shape;
		b2FixtureDef fixture;
		b2CircleShape circle;
		[self setFixtureDefPropertiesFromDictionary:spritePhysic fixture:&fixture];
		
        int shapeBorder = [[spritePhysic objectForKey:@"ShapeBorder"] intValue];
        
		if([[spritePhysic objectForKey:@"IsCircle"] boolValue])
		{
			circle.m_radius = (size.width*scale.x - shapeBorder)/2/PTM_RATIO;
			fixture.shape = &circle;
		}
		else
		{
			shape.SetAsBox((size.width*scale.x - shapeBorder)/PTM_RATIO/2, 
						   (size.height*scale.y - shapeBorder)/PTM_RATIO/2);
			
			fixture.shape = &shape;
		}
		
		body->CreateFixture(&fixture);
	}
	else
	{
		for(NSArray* curFixture in fixtures)
		{
			int size = (int)[curFixture count];
			b2Vec2 *verts = new b2Vec2[size];
			b2PolygonShape shape;
			int i = 0;
			for(NSString* pointStr in curFixture)
			{
				CGPoint point = LHPointFromString(pointStr);
				verts[i] = b2Vec2(point.x*(scale.x)/PTM_RATIO, 
								  point.y*(scale.y)/PTM_RATIO);
				++i;
			}
			shape.Set(verts, size);		
			b2FixtureDef fixture;
			[self setFixtureDefPropertiesFromDictionary:spritePhysic fixture:&fixture];
			fixture.shape = &shape;
			body->CreateFixture(&fixture);
			delete verts;
		}
	}
	
	return body;
	
}
////////////////////////////////////////////////////////////////////////////////////
-(void)loadSpriteHelperSceneFile:(NSString*)sceneFile 
                     inDirectory:(NSString*)subfolder
                    imgSubfolder:(NSString *)imgFolder
{
	NSString *path = [[NSBundle mainBundle] pathForResource:sceneFile 
                                                     ofType:@"pshs" 
                                                inDirectory:subfolder]; 
	
	NSAssert(nil!=path, @"Invalid scene file. Please add the SpriteHelper scene file to Resource folder. Please do not add extension in the given string.");
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
	bool fileInCorrectFormat =	![[dictionary objectForKey:@"Author"] isEqualToString:@"Bogdan Vladu"] || 
                                ![[dictionary objectForKey:@"CreatedWith"] isEqualToString:@"SpriteHelper"];
	
	NSAssert(true !=fileInCorrectFormat, @"This file was not created with SpriteHelper or file is damaged.");
		
	////////////////////////LOAD SPRITES////////////////////////////////////////////////////
    shSprites = [[NSMutableDictionary alloc] init];
    
    NSArray* tempArray = [dictionary objectForKey:@"SPRITES_INFO"];
    //we do this in order to be easier to find a sprite info when we want to 
    //create a body or a CCSprite
    for(NSDictionary* curSprite in tempArray)
    {
        NSDictionary* sprProp = [curSprite objectForKey:@"TextureProperties"];
        if(nil != sprProp)
        {
            [shSprites setObject:curSprite 
                          forKey:[sprProp objectForKey:@"Name"]];
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////
@end
