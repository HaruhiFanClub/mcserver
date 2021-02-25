// =================================================================//
//                       vanilla modification                       //
// =================================================================//
#priority 18

import crafttweaker.data.IData;
import crafttweaker.game.IGame;
import crafttweaker.item.IIngredient;
import crafttweaker.item.IItemStack;
import crafttweaker.oredict.IOreDictEntry;

recipes.addShaped(
	"redstone_repeater",
	<minecraft:repeater>,
	[
		[<ore:dustRedstone>, null, <ore:dustRedstone>],
		[<ore:stickWood>, <ore:dustRedstone>, <ore:stickWood>],
		[<ore:stone>, <ore:stone>, <ore:stone>],
	]
);

recipes.addShaped(
	"chest_minecart",
	<minecraft:chest_minecart>,
	[
		[null, null, null],
		[<ore:ingotIron>, <ore:chestWood>, <ore:ingotIron>],
		[<ore:ingotIron>, <ore:ingotIron>, <ore:ingotIron>],
	]
);

recipes.addShaped(
	"furnace_minecart",
	<minecraft:furnace_minecart>,
	[
		[null, null, null],
		[<ore:ingotIron>, <minecraft:furnace>, <ore:ingotIron>],
		[<ore:ingotIron>, <ore:ingotIron>, <ore:ingotIron>],
	]
);

recipes.addShaped(
	"hopper_minecart",
	<minecraft:hopper_minecart>,
	[
		[null, null, null],
		[<ore:ingotIron>, <minecraft:hopper>, <ore:ingotIron>],
		[<ore:ingotIron>, <ore:ingotIron>, <ore:ingotIron>],
	]
);

recipes.addShaped(
	"tnt_minecart",
	<minecraft:tnt_minecart>,
	[
		[null, null, null],
		[<ore:ingotIron>, <minecraft:tnt>, <ore:ingotIron>],
		[<ore:ingotIron>, <ore:ingotIron>, <ore:ingotIron>],
	]
);


val blockwool = {
	<minecraft:wool:0>: <ore:dyeWhite>,
	<minecraft:wool:1>: <ore:dyeOrange>,
	<minecraft:wool:2>: <ore:dyeMagenta>,
	<minecraft:wool:3>: <ore:dyeLight_blue>,
	<minecraft:wool:4>: <ore:dyeYellow>,
	<minecraft:wool:5>: <ore:dyeLime>,
	<minecraft:wool:6>: <ore:dyePink>,
	<minecraft:wool:7>: <ore:dyeGray>,
	<minecraft:wool:8>: <ore:dyeLightGray>,
	<minecraft:wool:9>: <ore:dyeCyan>,
	<minecraft:wool:10>: <ore:dyePurple>,
	<minecraft:wool:11>: <ore:dyeBlue>,
	<minecraft:wool:12>: <ore:dyeBrown>,
	<minecraft:wool:13>: <ore:dyeGreen>,
	<minecraft:wool:14>: <ore:dyeRed>,
	<minecraft:wool:15>: <ore:dyeBlack>
} as IOreDictEntry[IItemStack];
for key, value in blockwool {
	recipes.addShapeless(key, [value, <ore:wool>]);
}
for key, value in blockwool {
	recipes.addShapeless(key*8, [<ore:wool>, <ore:wool>, <ore:wool>, <ore:wool>, value, <ore:wool>, <ore:wool>, <ore:wool>, <ore:wool>]);
}
