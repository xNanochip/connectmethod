#pragma semicolon 1
#include <sourcemod>

//CVAR Handlers
new Handle:hEnable = INVALID_HANDLE;
new Handle:hFlags = INVALID_HANDLE;
new Handle:hImmunity = INVALID_HANDLE;
new Handle:hGroup = INVALID_HANDLE;

//File Path for Key Values
static String:kvPath[PLATFORM_MAX_PATH];

//My plugin information
public Plugin:myinfo =
{
	name = "Favorite Connections: Add Admin",
  	author = "Nanochip",
	version = "1.0",
  	description = "Detect when a player connects to the server via favorites and add them to admins.cfg.",
	url = "http://thecubeserver.org/"
};

public OnPluginStart()
{
  	//Creating CVARS
	CreateConVar("favoriteconnections_addadmin_version", "1.0", "Favorite Connections: Add Admins Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_UNLOGGED|FCVAR_DONTRECORD|FCVAR_REPLICATED|FCVAR_NOTIFY);
	hEnable = CreateConVar("favoriteconnections_addadmin_enable", "1", "Enable the plugin? 1 = Enable, 0 = Disable", FCVAR_NOTIFY);
	hFlags = CreateConVar("favoriteconnections_addadmin_flags", "", "Set the flags of the user", FCVAR_NOTIFY);
	hImmunity = CreateConVar("favoriteconnections_addadmin_immunity", "", "Set the immunity level of the user", FCVAR_NOTIFY);
	hGroup = CreateConVar("favoriteconnections_addadmin_group", "", "Set the group of the user", FCVAR_NOTIFY);
  
  	//Auto execute and create the config for CVARS
	AutoExecConfig(true, "FavoriteConnections_AddAdmin.cfg");
	
  	//Building the file path for KV
	BuildPath(Path_SM, kvPath, sizeof(kvPath), "configs/admins.cfg");
}

public Action:ClientConnectedViaFavorites(client)
{
  	//Should the plugin be enabled?
	if (!GetConVarBool(hEnable)) {
		return Plugin_Continue;
	}
	
  	//Declaring variables
	new String:name[32], String:authid[32], String:flags[32], String:immunity[10], String:group[32];
	
  	//Assigning variables
	GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid));
	GetClientName(client, name, sizeof(name));
	GetConVarString(hFlags, flags, sizeof(flags));
	GetConVarString(hImmunity, immunity, sizeof(immunity));
	GetConVarString(hGroup, group, sizeof(group));

  	//Create File Handler for Key Values in admins.cfg
	new Handle:hFileHandler = CreateKeyValues("Admins");
	FileToKeyValues(hFileHandler, kvPath);
  
  	//Check if the user already exists in the admins.cfg
	if (KvJumpToKey(hFileHandler, authid, false))
	{
		return Plugin_Continue;
	}
	KvRewind(hFileHandler);
	
  	//Add the user to admins.cfg
	if (KvJumpToKey(hFileHandler, authid, true))
	{
		KvSetString(hFileHandler, "name", name);
		KvSetString(hFileHandler, "auth", "steam");
		KvSetString(hFileHandler, "identity", authid);
		if (!StrEqual(flags, ""))
			KvSetString(hFileHandler, "flags", flags);
		if (!StrEqual(immunity, ""))
			KvSetString(hFileHandler, "immunity", immunity);
		if (!StrEqual(group, ""))
			KvSetString(hFileHandler, "group", group);
	}
	KvRewind(hFileHandler);
	KeyValuesToFile(hFileHandler, kvPath);
	CloseHandle(hFileHandler);
	
  	//Finisher
	PrintToServer("[Favorite Connections: Add Admin] %s(%s) joined the server via favorites - added to admins.cfg", name, authid);
	ServerCommand("sm_reloadadmins");
	
	return Plugin_Continue;
}
