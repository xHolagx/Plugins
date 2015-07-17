using UnityEngine;
using Rust;
using Oxide.Core.Plugins;

namespace Oxide.Plugins
{
    [Info("Player Particles", "LaserHydra", "0.0.1", ResourceId = 0)]
    [Description("Particles at every admin")]
    public class PlayerParticles : RustPlugin
    {     
        void Loaded()
        {
            timer.Every(5, SendEffect);
        }
		
		void SendEffect()
		{
			foreach(BasePlayer player in BasePlayer.activePlayerList)
			{
				if(!player.IsAdmin()) continue;
				Effect.server.Run("fx/gas_explosion_small", player.transform.position, Vector3.up, null, true);
			}
		}
    }
}
