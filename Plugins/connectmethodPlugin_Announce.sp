#pragma semicolon 1
#include <sourcemod>

public Plugin:myinfo =
{
	name = "Favorite Connections Plugin: Announce Favorites Join",
  	author = "Wolvan",
  	description = "Announce when a player joins through his/her favorites.",
	version = "1.0",
	url = "http://thecubeserver.org/"
};

public Action:ClientConnectedViaFavorites(client)
{
	new String:name[MAX_NAME_LENGTH];
	GetClientName(client, name, sizeof(name));
	PrintToChatAll("%s joined this server through his/her favorites! Thank you!", name);
	return Plugin_Continue;
}
