#priority 4

#loader contenttweaker

import crafttweaker.data.IData;
import crafttweaker.world.IWorld;
import crafttweaker.entity.IEntity;
import crafttweaker.entity.IEntityLivingBase;
import crafttweaker.player.IPlayer;
import crafttweaker.game.IGame;
import crafttweaker.item.IItemStack;
import crafttweaker.block.IBlock;
import crafttweaker.block.IBlockState;
import crafttweaker.block.IBlockPattern;
import crafttweaker.entity.IEntityEquipmentSlot;
import crafttweaker.potions.IPotion;
import crafttweaker.potions.IPotionEffect;
import crafttweaker.util.Position3f;
import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.ItemFood;
import mods.contenttweaker.Commands;
import mods.contenttweaker.Player;
import mods.contenttweaker.Hand;
import mods.contenttweaker.ActionResult;
import mods.contenttweaker.IItemUse;
import mods.contenttweaker.IItemUseFinish;
import mods.contenttweaker.IItemUpdate;
import mods.contenttweaker.MutableItemStack;
import mods.zenutils.UUID;

function GTellraw (target as string, raw_json_text as string[]) {
	var c = "";
	for item in raw_json_text {
		c += ("," + item);
	}
	server.commandManager.executeCommand(server,"tellraw "+ target + " [\"\"" + c + "]");
}

val testItem = VanillaFactory.createItem("test_item");
testItem.register();

val faeces as ItemFood = VanillaFactory.createItemFood("faeces", 4);
faeces.saturation = 0.8;
faeces.alwaysEdible = true;
faeces.setCreativeTab(<creativetab:food>);
faeces.onItemFoodEaten = function(stack, world, player) {
	if (!world.remote) {
		player.addPotionEffect(<potion:minecraft:unluck>.makePotionEffect(12000, 15));
		player.addPotionEffect(<potion:minecraft:hunger>.makePotionEffect(1200, 15));
		player.addPotionEffect(<potion:minecraft:nausea>.makePotionEffect(1200, 4));
	}
};
faeces.register();

val phyExcalibur = VanillaFactory.createItem("physics_excalibur");
phyExcalibur.setMaxStackSize(1);
phyExcalibur.rarity = "epic";
phyExcalibur.itemRightClick = function(item, world, player, hand) {
	if (!world.remote && player.isSneaking) {
		if (item.matches(player.getHeldItem(Hand.main()))) {
			val tags = item.tag;
			if ((tags has "mode") && (tags.mode == 1)) {
				player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(), itemUtils.getItem("contenttweaker:physics_excalibur"));
			} else {
				player.setItemToSlot(
					crafttweaker.entity.IEntityEquipmentSlot.mainHand(),
					itemUtils.getItem("contenttweaker:physics_excalibur")
						.withTag({ench: [{lvl: 0 as short, id: -1 as short}], mode: 1} as IData)
						.withLore(["§7Actived"])
				);
			}
			return "SUCCESS";
		}
		return "PASS";
	}
	return "PASS";
};
phyExcalibur.register();

val deathTeleporter = VanillaFactory.createItemFood("death_teleporter", 0);
deathTeleporter.setMaxStackSize(1);
deathTeleporter.setSaturation(0);
deathTeleporter.setAlwaysEdible(true);
deathTeleporter.setItemUseAction("BOW");
deathTeleporter.onItemUseFinish = function(item, world, player as IEntityLivingBase) {
	val player_uuid = player.getUUID();
	val tags = item.tag;
	if ((tags has "type") && (tags has "pos_x") && (tags has "pos_y") && (tags has "pos_z") && (tags has "dim") && (tags has "uuid")) {
		if (player_uuid == tags.uuid) {
			if (player.getDimension() == tags.dim) {
				if (!world.remote) {
					val pos_x = tags.pos_x;
					val pos_y = tags.pos_y;
					val pos_z = tags.pos_z;
					player.addPotionEffect(<potion:minecraft:invisibility>.makePotionEffect(300, 4));
					if (!(tags has "ench") && (tags.type == 0)) {
						player.addPotionEffect(<potion:minecraft:weakness>.makePotionEffect(12000, 4));
						player.addPotionEffect(<potion:minecraft:unluck>.makePotionEffect(24000, 4));
						player.addPotionEffect(<potion:minecraft:poison>.makePotionEffect(6000, 4));
						player.addPotionEffect(<potion:minecraft:blindness>.makePotionEffect(1200, 4));
						player.addPotionEffect(<potion:minecraft:slowness>.makePotionEffect(1200, 4));
					} else if (tags.type == 1) {

					} else if (tags.type >= 2) {
						player.addPotionEffect(<potion:minecraft:resistance>.makePotionEffect(1200, 1));
						player.addPotionEffect(<potion:minecraft:regeneration>.makePotionEffect(1200, 1));
						player.addPotionEffect(<potion:minecraft:saturation>.makePotionEffect(1200, 0));
					}
					server.commandManager.executeCommand(
						server,
						"teleport " + player_uuid + " " + pos_x + " " + pos_y + " " + pos_z
					);
				}
				return null;
			}
			if (!world.remote) {
				GTellraw(player_uuid,["{\"translate\":\"item.contenttweaker.death_teleporter.message.fail.3\"}"] as string[]);
			}
			return item;
		}
		if (!world.remote) {
			GTellraw(player_uuid,["{\"translate\":\"item.contenttweaker.death_teleporter.message.fail.2\"}"] as string[]);
		}
		return item;
	}
	if (!world.remote) {
		GTellraw(player_uuid,["{\"translate\":\"item.contenttweaker.death_teleporter.message.fail.1\"}"] as string[]);
	}
	return item;
};
deathTeleporter.register();

val NijigenCrystal = VanillaFactory.createItem("nijigen_crystal");
NijigenCrystal.register();

val giftItem = VanillaFactory.createItem("gift");
giftItem.setMaxStackSize(1);
giftItem.rarity = "epic";
giftItem.itemRightClick = function(item, world, player, hand) {
	if (!world.remote && player.isSneaking) {
		if (item.matches(player.getHeldItem(Hand.main()))) {
			val player_uuid = player.getUUID();
			val gift_tags = item.tag;
			if (gift_tags has "Items") {
				val items = gift_tags.Items as IData;
				if (items.length == 0) {
					GTellraw(player_uuid,["{\"translate\":\"item.contenttweaker.gift.message.fail.2\"}"] as string[]);
					return "PASS";
				}
				if (items.length > 36) {
					GTellraw(player_uuid,["{\"translate\":\"item.contenttweaker.gift.message.fail.3\"}"] as string[]);
					return "PASS";
				}
				if ((gift_tags has "to") && (gift_tags.to != player_uuid)) {
					GTellraw(player_uuid,["{\"translate\":\"item.contenttweaker.gift.message.fail.4\"}"] as string[]);
					return "PASS";
				}
				for index in 0 .. items.length {
					var item = items[index];
					if (item has "tag") {
						player.give(((itemUtils.getItem(item.id,item.Damage))*item.Count).withTag(item.tag as IData));
					} else {
						player.give(((itemUtils.getItem(item.id,item.Damage))*item.Count));
					}
				}
				if ((gift_tags has "Unlimited") && (gift_tags.Unlimited == 1)) {} else {
					player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(), null);
				}
				print("Player " + player.name +"("+player_uuid+") opened a gift pack (by itemRightClick) with NBT:");
				print("    " + gift_tags.asString());
				return "SUCCESS";
			}
			GTellraw(player_uuid,["{\"translate\":\"item.contenttweaker.gift.message.fail.1\"}"] as string[]);
			return "PASS";
		}
		return "PASS";
	}
	return "PASS";
};
giftItem.register();
