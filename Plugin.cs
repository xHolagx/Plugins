using System.Collections.Generic;
using System.Reflection;
using System;
using System.Data;
using UnityEngine;
using Oxide.Core;

namespace Oxide.Plugins
{
    [Info("Plugin", "LaserHydra", "1.0.0", ResourceId = 0)]
    [Description("Description")]
    class Plugin : RustPlugin
    {
        #region UsefulMethods
        //--------------------------->   Player finding   <---------------------------//

        BasePlayer GetPlayer(string searchedPlayer, BasePlayer executer, string prefix)
        {
            BasePlayer targetPlayer = null;
            List<string> foundPlayers = new List<string>();
            string searchedLower = searchedPlayer.ToLower();
            foreach (BasePlayer player in BasePlayer.activePlayerList)
            {
                string display = player.displayName;
                string displayLower = display.ToLower();

                if (!displayLower.Contains(searchedLower))
                {
                    continue;
                }
                if (displayLower.Contains(searchedLower))
                {
                    foundPlayers.Add(display);
                }
            }
            var matchingPlayers = foundPlayers.ToArray();

            if (matchingPlayers.Length == 0)
            {
                SendChatMessage(executer, prefix, "No matching players found!");
            }

            if (matchingPlayers.Length > 1)
            {
                SendChatMessage(executer, prefix, "Multiple players found:");
                string multipleUsers = "";
                foreach (string matchingplayer in matchingPlayers)
                {
                    if (multipleUsers == "")
                    {
                        multipleUsers = "<color=yellow>" + matchingplayer + "</color>";
                        continue;
                    }

                    if (multipleUsers != "")
                    {
                        multipleUsers = multipleUsers + ", " + "<color=yellow>" + matchingplayer + "</color>";
                    }

                }
                SendChatMessage(executer, prefix, multipleUsers);
            }

            if (matchingPlayers.Length == 1)
            {
                targetPlayer = BasePlayer.Find(matchingPlayers[0]);
            }
            return targetPlayer;
        }

        //---------------------------->   Converting   <----------------------------//

        string ArrayToString(string[] array, int first)
        {
            int count = 0;
            string output = array[first];
            foreach (string current in array)
            {
                if (count <= first)
                {
                    count++;
                    continue;
                }

                output = output + " " + current;
                count++;
            }
            return output;
        }

        //---------------------------->   Chat Sending   <----------------------------//

        void BroadcastChat(string prefix, string msg)
        {
            PrintToChat("<color=orange>" + prefix + "</color>: " + msg);
        }

        void SendChatMessage(BasePlayer player, string prefix, string msg)
        {
            SendReply(player, "<color=orange>" + prefix + "</color>: " + msg);
        }

        //---------------------------------------------------------------------------//
        #endregion
    }
}
