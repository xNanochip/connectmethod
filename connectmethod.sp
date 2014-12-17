#pragma semicolon 1
#include <sourcemod>
#include <morecolors>

static String:KVPath2[PLATFORM_MAX_PATH];

public Plugin:myinfo =
{
	name = "Connect Method",
  	author = "Nanochip & Dovashin",
  	description = "Detect when a player connects to the server through favorites and apply commands.",
	url = "http://thecubeserver.org/"
};

public OnPluginStart()
{
	BuildPath(Path_SM, KVPath2, sizeof(KVPath2), "configs/admins.cfg");
}

public OnClientAuthorized(client, const String:auth[])
{ 
	new String:connectmethod[32], String:authid[32], String:name[32]; 
	if (GetClientInfo(client, "cl_connectmethod", connectmethod, sizeof(connectmethod))) { 
		if (StrEqual(connectmethod, "serverbrowser_favorites")) { 
          	GetClientAuthId(client, AuthId_Steam3, authid, sizeof(authid));
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
			ServerCommand("sm_reloadadmins");
			ServerCommand("sm plugins reload custom-chatcolors");
			CPrintToChatAll("{lime}%s {orange}has this server in his or her favorites therefore receives {mediumorchid}\"Regular\" {orange}rank!", name);
			
        }
    }
	return;
}
