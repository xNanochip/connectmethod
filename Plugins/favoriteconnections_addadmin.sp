#pragma semicolon 1
#include <sourcemod>

static String:KVPath2[PLATFORM_MAX_PATH];

public Plugin:myinfo =
{
	name = "Connect Method Plugin: Add to Admins.cfg",
  	author = "Wolvan",
  	description = "Add Player to Admin.cfg when he joins via favorites.",
	version = "1.0"
	url = "http://thecubeserver.org/"
};

public OnPluginStart()
{
	BuildPath(Path_SM, KVPath2, sizeof(KVPath2), "configs/admins.cfg");
}

public Action:ClientConnectedViaFavorites(client)
{
	GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid));
	GetClientName(client, name, sizeof(name));

	new Handle:DB2 = CreateKeyValues("Admins");
	FileToKeyValues(DB2, KVPath2);
	if (KvJumpToKey(DB2, authid, false))
	{
		return;
	}
	KvRewind(DB2);
	CloseHandle(DB2);

	ServerCommand("sm_adduserid \"%s\" Regular %s", authid, name);
	return Plugin_Continue;
}
