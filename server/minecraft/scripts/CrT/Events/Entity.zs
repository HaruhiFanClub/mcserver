import crafttweaker.entity.IEntity;
import crafttweaker.entity.IEntityItem;
import crafttweaker.entity.IEntityLiving;
import crafttweaker.entity.IEntityLivingBase;
import crafttweaker.damage.IDamageSource;
import crafttweaker.events.IEventManager;
import crafttweaker.event.ILivingEvent;
import crafttweaker.event.EntityLivingDeathDropsEvent;
import crafttweaker.event.IEventCancelable;
import crafttweaker.server.IServer;
import crafttweaker.game.IGame;
import crafttweaker.data.IData;
import crafttweaker.item.IItemStack;
import mods.zenutils.UUID;
import mods.ctutils.utils.Math;

events.onEntityLivingDeathDrops(function(event as EntityLivingDeathDropsEvent){
	if ((!event.entityLivingBase.world.remote) && (event.damageSource.getDamageType() == "anvil") && (!isNull(event.entityLivingBase.definition))) {
		if (Math.random() > 0.95){
			event.addItem(<contenttweaker:nijigen_crystal>.createEntityItem(event.entityLivingBase.world, event.entityLivingBase.position));
		}
	}
});
