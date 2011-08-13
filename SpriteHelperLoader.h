//  This file was generated with SpriteHelper
//  http://spritehelper.wordpress.com
//
//  SpriteHelperLoader.h
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////
//
//  Version history
//  v1.0 first draft
//  v1.1 added new animation methods
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32 //you should only keep this here


@interface SpriteHelperLoader : NSObject {
	
	NSMutableDictionary* shSprites;
}

////////////////////////////////////////////////////////////////////////////////

-(id) initWithContentOfFile:(NSString*)sceneFile;

////////////////////////////////////////////////////////////////////////////////

-(id) initWithContentOfFile:(NSString*)sceneFile 
			 sceneSubfolder:(NSString*)sceneFolder;

////////////////////////////////////////////////////////////////////////////////

-(CCSprite*) spriteWithUniqueName:(NSString*)name 
                       atPosition:(CGPoint)point 
                          inLayer:(CCLayer*)layer;

-(CCSprite*) spriteWithUniqueName:(NSString*)name atPosition:(CGPoint)point;

-(CCSprite*) spriteWithUniqueName:(NSString*)name;

////////////////////////////////////////////////////////////////////////////////

/**
 repeats - if you pass 0 - the animation will run forever 
                            else will run the number you specified
 layer: if you pass nil - it will not add the sprite into a layer and you can
                        - use the returned CCSprite to add it as a child to 
                        - another CCSprite
 frameNames is an array of NSString* containing the sprite names in order
 */
-(CCSprite*) animSpriteWithUniqueName:(NSArray*)frameNames
                             position:(CGPoint)point
                                layer:(CCLayer*)layer
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction;

-(CCSprite*) animSpriteWithUniqueName:(NSString*)name 
                             position:(CGPoint)point
                                layer:(CCLayer*)layer
                               frames:(int)frameNo 
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction;

-(CCSprite*) animSpriteWithUniqueName:(NSString*)name 
                             position:(CGPoint)point
                                layer:(CCLayer*)layer
                           startFrame:(int)start
                             endFrame:(int)end
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction;

-(CCSprite*) animSpriteWithUniqueName:(NSString*)name 
                             position:(CGPoint)point
                               frames:(int)frameNo 
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction;

-(CCSprite*) animSpriteWithUniqueName:(NSString*)name 
                               frames:(int)frameNo 
                                delay:(float)delay
                              repeats:(int)numberOfRepeats
                           saveAction:(CCAction**)animAction;

////////////////////////////////////////////////////////////////////////////////

//frameNames is an array of NSString* containing the sprite names in order
-(CCAction*) actionForFrames:(NSArray*)frameNames delay:(float)delay;

-(CCAction*) actionForFrames:(NSString*)name 
                      frames:(int)frameNo 
                       delay:(float)delay;

////////////////////////////////////////////////////////////////////////////////

//b2Body returned has as UserData a CCSprite*
-(b2Body*) bodyWithUniqueName:(NSString*)name 
                     position:(CGPoint)point 
                        layer:(CCLayer*)layer 
                        world:(b2World*)world;

////////////////////////////////////////////////////////////////////////////////
//b2Body returned has as UserData a CCSprite*
-(b2Body*) animBodyWithUniqueName:(NSString*)name
                         position:(CGPoint)point 
                           frames:(int)frameNo
                            delay:(float)delay
                          repeats:(int)numberOfRepeats
                       saveAction:(CCAction**)animAction
                            layer:(CCLayer*)layer
                            world:(b2World*)world;

-(b2Body*) animBodyWithUniqueName:(NSArray*)frameNames
                         position:(CGPoint)point 
                            delay:(float)delay 
                       saveAction:(CCAction **)animAction 
                          repeats:(int)numberOfRepeats
                            layer:(CCLayer *)layer 
                            world:(b2World*)world;

////////////////////////////////////////////////////////////////////////////////
@end

