//
//  RemoteInterprocessConnection.cpp
//  MusicPlayer
//
//  Created by Andy on 28/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "RemoteInterprocessConnection.h"

RemoteInterprocessConnection::RemoteInterprocessConnection () : InterprocessConnection(true)
{
    //remoteNumConnections++;
}

RemoteInterprocessConnection::~RemoteInterprocessConnection()
{
    
}

void RemoteInterprocessConnection::connectionMade()
{
    DBG("Connection # - connection started");
    DBG("Connected to = " << getConnectedHostName());
    
    String chickens ("cheese");
    MemoryBlock messageData (chickens.toUTF8(), (size_t) chickens.getNumBytesAsUTF8());
    sendMessage(messageData);
}

void RemoteInterprocessConnection::connectionLost()
{
    DBG("Connection # - connection lost");
    //remoteNumConnections--;
}

void RemoteInterprocessConnection::messageReceived (const MemoryBlock& message)
{
    String stringMessage = message.toString();
    DBG("Connection - message received: " + stringMessage);
}

void RemoteInterprocessConnection::sendString(String incomingMessage)
{
    MemoryBlock messageData (incomingMessage.toUTF8(), (size_t) incomingMessage.getNumBytesAsUTF8());
    sendMessage(messageData);
}