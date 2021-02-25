import crafttweaker.player.IPlayer;
import crafttweaker.entity.IEntity;
import crafttweaker.entity.IEntityItem;
import crafttweaker.entity.IEntityLiving;
import crafttweaker.entity.IEntityLivingBase;
import crafttweaker.entity.IEntityEquipmentSlot;
import crafttweaker.events.IEventManager;
import crafttweaker.event.ILivingEvent;
import crafttweaker.event.PlayerLoggedInEvent;
import crafttweaker.event.PlayerAttackEntityEvent;
import crafttweaker.event.PlayerAnvilUpdateEvent;
import crafttweaker.event.PlayerRightClickItemEvent;
import crafttweaker.event.IEventCancelable;
import crafttweaker.server.IServer;
import crafttweaker.game.IGame;
import crafttweaker.data.IData;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IItemCondition;
import mods.zenutils.UUID;
import mods.ctutils.utils.Math;
import scripts.utils.common.RunCmd;
import scripts.utils.command.vanilla.BuildTellraw;
import scripts.utils.command.extend.BuildServerChan;

events.onPlayerLoggedIn(function(event as PlayerLoggedInEvent) {
	if (!event.player.world.remote) {
		val player = event.player;
		val name = player.name;
		val uuid = player.getUUID();
		
		val data = {PlayerPersisted:{loggedIn:0}} as IData + player.data;
		val logged_in = data.PlayerPersisted.loggedIn.asInt();

		if (logged_in != 0) {
			RunCmd(BuildTellraw(
				name,
				[
					"{\"translate\":\"message.shw.login.player.1\",\"with\":[\"" + name + "\"]}",
					"{\"selector\": \"@a[name=" + name + "]\"}"
				] as string[]
			));
		} else {
			RunCmd(BuildServerChan(
				"@a",
				[
					"{\"translate\":\"message.shw.login.newplayer.1\"}",
					"{\"selector\": \"@a[name=" + name + "]\"}"
				] as string[]
			));
			player.give(
				<contenttweaker:gift>.withTag({
					display: {
						Lore: ["§r属于" + name],
						Name: "§r§6初始物品包"
					},
					to: uuid,
					Items: [
						{Slot: 0 as byte, id: "waystones:return_scroll", Count: 8 as byte, Damage: 0 as short},
						{Slot: 1 as byte, id: "minecraft:flint_and_steel", Count: 1 as byte, Damage: 0 as short},
						{Slot: 1 as byte, id: "roughtweaks:bandage", Count: 1 as byte, Damage: 0 as short},
						{Slot: 3 as byte, id: "ebwizardry:scroll", Count: 1 as byte, Damage: 38 as short},
						{Slot: 4 as byte, id: "ebwizardry:scroll", Count: 1 as byte, Damage: 49 as short},
						{Slot: 5 as byte, id: "ebwizardry:scroll", Count: 1 as byte, Damage: 54 as short},
						{Slot: 6 as byte, id: "ebwizardry:scroll", Count: 1 as byte, Damage: 64 as short},
						{Slot: 7 as byte, id: "ebwizardry:scroll", Count: 1 as byte, Damage: 79 as short},
						{Slot: 8 as byte, id: "ebwizardry:scroll", Count: 1 as byte, Damage: 87 as short},
						{Slot: 9 as byte, id: "ebwizardry:scroll", Count: 1 as byte, Damage: 99 as short}
					]
				})
			);
		}

		RunCmd("scoreboard players set " + name + " loggedIn " + (logged_in+1));
		player.update({PlayerPersisted:{loggedIn:logged_in+1}} as IData);
	}
});


events.onPlayerAttackEntity(function(event as PlayerAttackEntityEvent){
	var player = event.player as IPlayer;
	var target = event.target as IEntity;
	if (!player.world.remote && !target.world.remote) {
		var item = event.player.currentItem;
		if (isNull(item)) {return;}
		if (item.definition.id == "contenttweaker:physics_excalibur" ) {
			if (player.creative) {
				val target_uuid = target.getUUID();
				val player_uuid = player.getUUID();
				if ((item.tag has "mode") && (item.tag.mode == 1)) {
					event.cancel();
					target.setDead();
					print("Player " + player.name + "(" + player_uuid + ") with NBT: " + player.getNBT().asString() + " removed entity " + target.definition.id + "(" + target_uuid + ") with NBT: " + target.getNBT().asString() +" by contenttweaker:physics_excalibur in dimension " + player.dimension);
					val tellraw = BuildTellraw(
						"@a",
						[
							"{\"translate\":\"item.contenttweaker.physics_excalibur.message.success.1\",\"color\":\"gray\"}",
							"{\"text\":\""+player.name+"\",\"color\":\"gray\",\"hoverEvent\":{\"action\":\"show_text\",\"value\":\"Name:§7 "+player.name+"\n§rUUID:§7 "+player_uuid+"\n§rPos:§7 X:"+player.posX+",Y:"+player.posY+",Z:"+player.posZ+",DIM:"+player.dimension+"\"}}",
							"{\"translate\":\"item.contenttweaker.physics_excalibur.message.success.2\",\"color\":\"gray\"}",
							"{\"translate\":\"item.contenttweaker.physics_excalibur.name\",\"color\":\"gray\",\"hoverEvent\":{\"action\":\"show_item\",\"value\":\"{\\\"id\\\":\\\"contenttweaker:physics_excalibur\\\",\\\"Count\\\":1}\"}}",
							"{\"translate\":\"item.contenttweaker.physics_excalibur.message.success.3\",\"color\":\"gray\"}",
							"{\"text\":\""+target.definition.name+"\",\"color\":\"gray\",\"hoverEvent\":{\"action\":\"show_text\",\"value\":\"Name:§7 "+target.definition.name+"\n§rDisplay Name:§7 "+target.displayName+"\n§rCustom Name:§7 "+target.customName+"\n§rID:§7 "+target.definition.id+"\n§rUUID:§7 "+target_uuid+"\n§rPos: §7 X:"+target.posX+",Y:"+target.posY+",Z:"+target.posZ+",DIM:"+target.dimension+"\"}}",
							"{\"translate\":\"item.contenttweaker.physics_excalibur.message.success.4\",\"color\":\"gray\"}"
						] as string[]
					);
					RunCmd(tellraw);
					player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(), <contenttweaker:physics_excalibur>);
					return;
				}
				if (player.isSneaking) {
					event.cancel();
					val tellraw = BuildTellraw(
						player_uuid,
						[
							"{\"translate\":\"item.contenttweaker.physics_excalibur.message.info.1\"}",
							"{\"text\":\"\n  \"}","{\"text\":\"ID:\"}","{\"text\":\" " + target.definition.id + "\"}",
							"{\"text\":\"\n  \"}","{\"text\":\"UUID:\"}","{\"text\":\" " + target_uuid + "\",\"insertion\":\"" + target_uuid + "\",\"hoverEvent\":{\"action\":\"show_text\",\"value\":\"Shift-click to insert into chat input\"}}",
							"{\"text\":\"\n  \"}","{\"translate\":\"item.contenttweaker.physics_excalibur.message.info.2\"}","{\"text\":\" " + target.definition.name + "\"}",
							"{\"text\":\"\n  \"}","{\"translate\":\"item.contenttweaker.physics_excalibur.message.info.4\"}","{\"text\":\" " + target.displayName + "\"}",
							"{\"text\":\"\n  \"}","{\"translate\":\"item.contenttweaker.physics_excalibur.message.info.5\"}","{\"text\":\" " + target.customName + "\"}",
							"{\"text\":\"\n  \"}","{\"translate\":\"item.contenttweaker.physics_excalibur.message.info.3\"}","{\"text\":\" X:"+target.posX+",Y:"+target.posY+",Z:"+target.posZ+",DIM:"+target.dimension+"\"}",
						] as string[]
					);
					RunCmd(tellraw);
					return;
				}
				event.cancel();
				RunCmd(BuildTellraw(player.name,["{\"translate\":\"item.contenttweaker.physics_excalibur.message.fail.2\"}"]));

			} else {
				event.cancel();
				RunCmd(BuildTellraw(player.name,["{\"translate\":\"item.contenttweaker.physics_excalibur.message.fail.1\"}"]));
			}
		}
	}
});


events.onPlayerAnvilUpdate(function(event as PlayerAnvilUpdateEvent){
	var left = event.leftItem;
	var right = event.rightItem;
	var left_allows = [
		"minecraft:iron_sword",
		"minecraft:wooden_sword",
		"minecraft:stone_sword",
		"minecraft:diamond_sword",
		"minecraft:golden_sword",

		"minecraft:iron_axe",
		"minecraft:wooden_axe",
		"minecraft:stone_axe",
		"minecraft:diamond_axe",
		"minecraft:golden_axe",

		"minecraft:leather_helmet",
		"minecraft:chainmail_helmet",
		"minecraft:iron_helmet",
		"minecraft:diamond_helmet",
		"minecraft:golden_helmet",

		"minecraft:leather_chestplate",
		"minecraft:chainmail_chestplate",
		"minecraft:iron_chestplate",
		"minecraft:diamond_chestplate",
		"minecraft:golden_chestplate",

		"minecraft:leather_leggings",
		"minecraft:golden_leggings",
		"minecraft:diamond_leggings",
		"minecraft:iron_leggings",
		"minecraft:chainmail_leggings",

		"minecraft:leather_boots",
		"minecraft:chainmail_boots",
		"minecraft:iron_boots",
		"minecraft:diamond_boots",
		"minecraft:golden_boots",

		"minecraft:iron_pickaxe",
		"minecraft:wooden_pickaxe",
		"minecraft:stone_pickaxe",
		"minecraft:diamond_pickaxe",
		"minecraft:golden_pickaxe",

		"minecraft:iron_shovel",
		"minecraft:wooden_shovel",
		"minecraft:golden_shovel",
		"minecraft:stone_shovel",
		"minecraft:diamond_shovel",

		"minecraft:wooden_hoe",
		"minecraft:stone_hoe",
		"minecraft:iron_hoe",
		"minecraft:diamond_hoe",
		"minecraft:golden_hoe"
	] as string[];
	if (right.matches(<contenttweaker:enchantment_booster>)) {

		for item_id in left_allows {
			if (left.definition.id == item_id) {

				var tags = left.tag as IData;
				if (!(tags has "ench")) {
					break;
				}
				val old_enchs = tags.ench as IData;

				var ench_count = old_enchs.length as int;
				var highest_lvl = 0;
				for index in 0 .. ench_count {
					var _lvl = old_enchs[index].lvl as int;
					if (_lvl > highest_lvl) { // 获取最高等级
						highest_lvl = _lvl;
					}
					if ((old_enchs[index].id == 10 as short) || (old_enchs[index].id == 71 as short)) { // 在附魔条数中剔除诅咒
						ench_count -= 1;
					}
				}
				if (ench_count > 7) { // 限制最多允许条数为7
					ench_count = 7;
				}
				// print("ench_count:"+ench_count);

				tags -= {ench:old_enchs} as IData; // 清除原有附魔

				// if (!(tags has "RepairCost")) { // 模拟铁砧机制
				// 	event.xpCost = 1;
				// 	tags += {RepairCost:1};
				// } else {
				// 	val _cost = tags.RepairCost as int;
				// 	val _next = (_cost * 2) + 1;
				// 	tags -= {RepairCost:(_cost as int)};
				// 	tags += {RepairCost:(_next as int)};
				// } 
				event.xpCost = 6;

				var _strengthened = 1; // 记录强化次数
				if (tags has "strengthened") {
					_strengthened = (tags.strengthened as int) + 1;
				}
				tags += {strengthened:(_strengthened as int)} as IData;

				tags += {HideFlags:63} as IData; // 隐藏属性

				var new_enchs = {ench:[]} as IData;
				if (ench_count >= highest_lvl) { // N≥X

					// print("N≥X");
					if (Math.random() < ((1  as double) / (highest_lvl as double)) as double) { // 1/X
						// print("1/X");
						for index in 0 .. ench_count {
							var _ench = old_enchs[index];
							new_enchs += {ench:[{id: _ench.id as short, lvl: (_ench.lvl + 1) as short}]} as IData;
						}
						event.outputItem = left.withTag(tags + new_enchs);
						break;
					}

					// print("other");
					val random_index = (Math.random() * ench_count) as int;
					for index in 0 .. ench_count {
						var _ench = old_enchs[index];
						if (index == random_index) {
							new_enchs += {ench:[{id: _ench.id as short, lvl: (_ench.lvl + 1) as short}]} as IData;
						} else {
							new_enchs += {ench:[{id: _ench.id as short, lvl: _ench.lvl as short}]} as IData;
						}
					}
					event.outputItem = left.withTag(tags + new_enchs);
					break;

				} else { // N＜X 
					// print("N<X");

					if (Math.random() < ((1  as double) / (highest_lvl as double)) as double) { // 1/X
						// print("1/X");
						for index in 0 .. ench_count {
							var _ench = old_enchs[index];
							new_enchs += {ench:[{id: _ench.id as short, lvl: (_ench.lvl + 1) as short}]} as IData;
						}
						event.outputItem = left.withTag(tags + new_enchs);
						break;
					}

					if (Math.random() < ((ench_count  as double) / (highest_lvl as double)) as double) { // N/X
						// print("N/X");
						val random_index = (Math.random() * ench_count) as int;
						for index in 0 .. ench_count {
							var _ench = old_enchs[index];
							if (index == random_index) {
								new_enchs += {ench:[{id: _ench.id as short, lvl: (_ench.lvl + 1) as short}]} as IData;
							} else {
								new_enchs += {ench:[{id: _ench.id as short, lvl: _ench.lvl as short}]} as IData;
							}
						}
						event.outputItem = left.withTag(tags + new_enchs);
						break;
					}

					// print("other");
					event.outputItem = left.withTag((tags +{ench:[{id: -1 as short, lvl: 0 as short}]} as IData) as IData);
					break;

				}
			}
		}
	}
});

events.onPlayerRightClickItem(function(event as PlayerRightClickItemEvent) { // 主手Shift右击模拟鉴定
	val player = event.player as IPlayer;
	if (player.world.remote) {return;}
	var item = event.item;
	if (isNull(item)) {return;}
	if (player.isSneaking) {
		if (item.matches(player.getItemInSlot(IEntityEquipmentSlot.mainHand()))) {
			var tags = item.tag as IData;
			if (tags has "strengthened") {
				player.setItemToSlot(IEntityEquipmentSlot.mainHand(), item.withTag(tags - {HideFlags:63} as IData)); // 移除隐藏属性标签
			}
			return;
		}
	}

});
