//
//  FirstViewController.h
//  MusicPlayerRemote
//
//  Created by Andy on 31/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteInterprocessConnection.h"

@interface FirstViewController : UIViewController

{
    IBOutlet UITextField *textMessage;

    RemoteInterprocessConnection *connection;
}

@property (nonatomic, retain) IBOutlet UITextField *textMessage;

-(IBAction) sendButton;

@end
