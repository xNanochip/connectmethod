#pragma semicolon 1
#include <sourcemod>
#include <morecolors>

public Plugin:myinfo =
{
	name = "Connect Method Plugin: Announce favorites join",
  	author = "Wolvan",
  	description = "Add Player to Admin.cfg when he joins via favorites.",
	version = "1.0"
	url = "http://thecubeserver.org/"
};

public Action:ClientConnectedViaFavorites(client)
{
	GetClientName(client, name, sizeof(name));
	CPrintToChatAll("{lime}%s {orange}has this server in his or her favorites therefore receives the {mediumorchid}Regular {orange}rank!", name);
	return Plugin_Continue;
}