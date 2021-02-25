import crafttweaker.item.IItemStack;
import crafttweaker.game.IGame;
import mods.jei.JEI.addDescription;

addDescription(<contenttweaker:death_teleporter>, game.localize("item.contenttweaker.death_teleporter.jei.description"));
addDescription(<contenttweaker:nijigen_crystal>, game.localize("item.contenttweaker.nijigen_crystal.jei.description"));

val netherstar_blocks = [
	<contenttweaker:netherstar_block>,
	<contenttweaker:compressed_netherstar_block>,
	<contenttweaker:double_compressed_netherstar_block>,
	<contenttweaker:triple_compressed_netherstar_block>,
	<contenttweaker:quadruple_compressed_netherstar_block>,
	<contenttweaker:quintuple_compressed_netherstar_block>,
	<contenttweaker:sextuple_compressed_netherstar_block>,
	<contenttweaker:septuple_compressed_netherstar_block>,
	<contenttweaker:eightfold_compressed_netherstar_block>,
	<contenttweaker:ninefold_compressed_netherstar_block>
] as IItemStack[];
for index,item in netherstar_blocks {
	item.addTooltip(game.localize("tile.contenttweaker.netherstar_block.tooltips")+(pow(9,(index + 1)) as long));
}

<contenttweaker:gift>.addTooltip(game.localize("item.contenttweaker.gift.tooltips"));
addDescription(<contenttweaker:gift>, game.localize("item.contenttweaker.gift.jei.description"));
