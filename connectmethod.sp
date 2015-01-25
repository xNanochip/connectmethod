#pragma semicolon 1
#include <sourcemod>

new Handle:forward_connectmethodFavorites = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "Favorite Connections",
  	author = "Nanochip",
	version = "1.0"
  	description = "Detect when a player connects to the server through favorites and apply commands.",
	url = "http://thecubeserver.org/"
};

public OnPluginStart()
{
	forward_connectmethodFavorites = CreateGlobalForward("ClientConnectedViaFavorites", ET_Event, Param_Cell);
	CreateConVar("favoriteconnections_version", "1.0", "Favorite Connections Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_UNLOGGED|FCVAR_DONTRECORD|FCVAR_REPLICATED|FCVAR_NOTIFY);
}

public OnClientAuthorized(client, const String:auth[])
{ 
	new String:connectmethod[32]; 
	if (GetClientInfo(client, "cl_connectmethod", connectmethod, sizeof(connectmethod)))
	{ 
		if (StrEqual(connectmethod, "serverbrowser_favorites"))
		{
			new Action:result = Plugin_Continue;
			Call_StartForward(forward_connectmethodFavorites);
			Call_PushCell(client);
			Call_Finish(result);
		}
	}
	return;
}
