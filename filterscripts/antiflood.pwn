#include <a_samp>
#include <core>
#include <float>

#define MAX_BAN_RECORDS 100

new g_WarningCount[MAX_PLAYERS];
new g_BanTime[MAX_PLAYERS];
new g_IsBanned[MAX_PLAYERS];

enum BanData {
  Name[MAX_PLAYER_NAME],
  IP[16],
  BanEndTimestamp 
};
new BanList[MAX_BAN_RECORDS][BanData];

public CheckIfFlood(playerid)
{
  g_WarningCount[playerid]++;

  if (g_WarningCount[playerid] == 5)
  {
    SendClientMessage(playerid, 0xFFFF00AA, "[WARNING] Stop flooding or you will be kicked.");
  }
  else if (g_WarningCount[playerid] == 10)
  {
    SendClientMessage(playerid, 0xFF0000AA, "[KICKED] You have been kicked for excessive spamming.");
    Kick(playerid);
  }
  else if (g_WarningCount[playerid] >= 20)
  {
    new pname[MAX_PLAYER_NAME], pip[16];
    GetPlayerName(playerid, pname, sizeof(pname));
    GetPlayerIp(playerid, pip, sizeof(pip));

    for(new i = 0; i < MAX_BAN_RECORDS; i++)
    {
        if(BanList[i][BanEndTimestamp] == 0)
        {
            format(BanList[i][Name], MAX_PLAYER_NAME, "%s", pname);
            format(BanList[i][IP], 16, "%s", pip);
            BanList[i][BanEndTimestamp] = gettime() + 172800;
            break;
        }
    }

    g_IsBanned[playerid] = true;
    g_BanTime[playerid] = 172800;

    new msg[144];
    format(msg, sizeof(msg), "[WARNING] %s | IP: %s has been banned for 2 days.", pname, pip);
    SendClientMessage(playerid, 0xAA0000FF, msg);

    new timerMsg[144];
    format(timerMsg, sizeof(timerMsg), "[WARNING] You are banned for 2 days. [Timer: %d seconds]", g_BanTime[playerid]);
    SendClientMessage(playerid, 0xAA0000FF, timerMsg);

    SetTimerEx("UpdateBanTimer", 1000, true, "i", playerid);
  }
  return 1;
}

forward UpdateBanTimer(playerid);
public UpdateBanTimer(playerid)
{
  if (!g_IsBanned[playerid]) return 0;

  g_BanTime[playerid]--;

  if (g_BanTime[playerid] % 60 == 0)
  {
    new msg[144];
    format(msg, sizeof(msg), "[BAN-TIMER] Time left: %d seconds", g_BanTime[playerid]);
    SendClientMessage(playerid, 0xFF8800FF, msg);
  }

  if (g_BanTime[playerid] <= 0)
  {
    g_IsBanned[playerid] = false;
    g_WarningCount[playerid] = 0;
    SendClientMessage(playerid, 0x00FF00AA, "[INFO] Your ban has expired. Welcome back!");
    return 0;
  }
  return 1;
}

public OnPlayerConnect(playerid)
{
  new pname[MAX_PLAYER_NAME], pip[16];
  GetPlayerName(playerid, pname, sizeof(pname));
  GetPlayerIp(playerid, pip, sizeof(pip));

  for(new i = 0; i < MAX_BAN_RECORDS; i++)
  {
    if((!strcmp(pname, BanList[i][Name], false) || !strcmp(pip, BanList[i][IP], false)) && gettime() < BanList[i][BanEndTimestamp])
    {
        SendClientMessage(playerid, 0xAA0000FF, "[ERROR] You are still banned. Try again later.");
        Kick(playerid);
        return 0;
    }
  }

  g_WarningCount[playerid] = 0;
  g_IsBanned[playerid] = false;
  g_BanTime[playerid] = 0;

  SetTimerEx("CheckIfFlood", 1000, true, "i", playerid);
  return 1;
}

