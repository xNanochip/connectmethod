#pragma semicolon 1
#include <sourcemod>
#include <morecolors>

#define PLUGIN_VERSION "1.0"

new Handle:hEnable = INVALID_HANDLE;
new bool:FirstTime[MAXPLAYERS+1] = true;
new bool:ThruFavs[MAXPLAYERS+1] = false;

public Plugin:myinfo =
{
	name = "Favorite Connections: Messages",
  	author = "Nanochip",
	version = PLUGIN_VERSION,
  	description = "Detect when a player connects to the server via favorites and prints messages.",
	url = "http://thecubeserver.org/"
};

public OnPluginStart()
{
	CreateConVar("favoriteconnections_messages_version", PLUGIN_VERSION, "Favorite Connections: Messages Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_UNLOGGED|FCVAR_DONTRECORD|FCVAR_REPLICATED|FCVAR_NOTIFY);
	hEnable = CreateConVar("favoriteconnections_messages_enable", "1", "Enable the plugin? 1 = Enable, 0 = Disable", FCVAR_NOTIFY);
	
	AutoExecConfig(true, "FavoriteConnections_Messages");
	
	HookEvent("player_team", OnPlayerTeam);
}

public Action:ClientConnectedViaFavorites(client)
{
	if (!GetConVarBool(hEnable)) {
		return Plugin_Continue;
	}
	
	if (GetUserFlagBits(client) != 0)
	{
		FirstTime[client] = false;
	}
	
	ThruFavs[client] = true;
	return Plugin_Continue;
}

public Action:OnPlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (!GetConVarBool(hEnable)) {
		return Plugin_Continue;
	}
	
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (FirstTime[client] && ThruFavs[client])
	{
		CPrintToChat(client, "{orange}THIS IS A TEST, HERP DERP");
	}
	return Plugin_Continue;
}
