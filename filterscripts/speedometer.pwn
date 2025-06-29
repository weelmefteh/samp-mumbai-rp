#include <a_samp>
#include <zcmd>

#define UPDATE_INTERVAL 1000 // ms

new PlayerText:cWspeedo[MAX_PLAYERS][10];
new carfuel[MAX_VEHICLES] = {100, ...};
new PlayerSpeedo[MAX_PLAYERS]; // 0 = KM/H, 1 = MP/H 
new SpeedoTimer[MAX_PLAYERS];

public OnFilterScriptInit()
{
  print("Prospect Roleplay - Vehicle Speedometer loaded.");
  return 1;
}

// ... Keep your existing modelNames[], GetVehicleSpeed(), etc.

// Add this function:
forward UpdateSpeedo(playerid);
public UpdateSpeedo(playerid)
{
  if (!IsPlayerConnected(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    return 0;

  new vehicle = GetPlayerVehicleID(playerid);
  if (!IsVehicleStreamedIn(vehicle, playerid)) return 0;

  new Float:H;
  GetVehicleHealth(vehicle, H);

  new speed[16], vehfuel[16], vehiclehealth[16];
  format(speed, sizeof(speed), "%.0f", PlayerSpeedo[playerid] == 0 ? GetVehicleSpeed(vehicle) : GetVehicleSpeedMPH(vehicle));
  format(vehfuel, sizeof(vehfuel), "%d", carfuel[vehicle]);
  format(vehiclehealth, sizeof(vehiclehealth), "%.0f", H);

  PlayerTextDrawSetString(playerid, cWspeedo[playerid][3], speed);
  PlayerTextDrawSetString(playerid, cWspeedo[playerid][6], vehfuel);
  PlayerTextDrawSetString(playerid, cWspeedo[playerid][8], vehiclehealth);
  PlayerTextDrawSetString(playerid, cWspeedo[playerid][5], PlayerSpeedo[playerid] == 0 ? "KM/H" : "MP/H");

  return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
  if (newstate == PLAYER_STATE_DRIVER)
  {
    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsAbicycle(vehicleid))
      {
        new vstr[30];
        format(vstr, sizeof(vstr), "%s", GetVehicleName(vehicleid));
        PlayerTextDrawSetString(playerid, cWspeedo[playerid][4], vstr);
        PlayerTextDrawSetPreviewModel(playerid, cWspeedo[playerid][2], GetVehicleModel(vehicleid));
        PlayerTextDrawShow(playerid, cWspeedo[playerid][2]);
        for (new i = 0; i < 10; i++) PlayerTextDrawShow(playerid, cWspeedo[playerid][i]);

        if (SpeedoTimer[playerid] == 0)
            SpeedoTimer[playerid] = SetTimerEx("UpdateSpeedo", UPDATE_INTERVAL, true, "i", playerid);
      }
  }
  else if (oldstate == PLAYER_STATE_DRIVER)
  {
    for (new i = 0; i < 10; i++) PlayerTextDrawHide(playerid, cWspeedo[playerid][i]);

    if (SpeedoTimer[playerid] != 0)
    {
        KillTimer(SpeedoTimer[playerid]);
        SpeedoTimer[playerid] = 0;
    }
  }
  return 1;
}

// Remove PlayerTextDrawSetString from OnPlayerUpdate, or comment the body to reduce overhead.
public OnPlayerUpdate(playerid)
{
  return 1;
}