#pragma semicolon 1
#include <sourcemod>

new Handle:forward_connectmethodFavorites = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "Connect Method",
  	author = "Nanochip",
  	description = "Detect when a player connects to the server through favorites and apply commands.",
	url = "http://thecubeserver.org/"
};

public OnPluginStart()
{
	forward_connectmethodFavorites = CreateGlobalForward("ClientConnectedViaFavorites", ET_Event, Param_Cell);
}

public OnClientAuthorized(client, const String:auth[])
{ 
	new String:connectmethod[32], String:authid[32], String:name[32]; 
	if (GetClientInfo(client, "cl_connectmethod", connectmethod, sizeof(connectmethod)))
	{ 
		if (StrEqual(connectmethod, "serverbrowser_favorites"))
		{
			Call_StartForward(forward_connectmethodFavorites);
			Call_PushCell(client);
			Call_Finish(Plugin_Continue);
		}
	}
	return;
}
