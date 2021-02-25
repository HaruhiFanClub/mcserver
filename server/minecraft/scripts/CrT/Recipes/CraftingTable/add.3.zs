// =================================================================//
//                       mod modification                       //
// =================================================================//
#priority 16

import crafttweaker.data.IData;
import crafttweaker.game.IGame;
import crafttweaker.item.IIngredient;
import crafttweaker.item.IItemStack;
import crafttweaker.oredict.IOreDictEntry;

recipes.addShaped(
	"blank_scroll.1",
	<ebwizardry:blank_scroll>,
	[
		[<ebwizardry:magic_crystal>, <ore:string>, <ebwizardry:magic_crystal>],
		[<ore:ingotGold>, <ore:paper>, <ore:ingotGold>],
		[<ebwizardry:magic_crystal>, <ore:string>, <ebwizardry:magic_crystal>],
	]
);

recipes.addShaped(
	"blank_scroll.2",
	<ebwizardry:blank_scroll>,
	[
		[<ebwizardry:magic_crystal>, <ore:string>, <ebwizardry:magic_crystal>],
		[<minecraft:emerald>, <ore:paper>, <minecraft:emerald>],
		[<ebwizardry:magic_crystal>, <ore:string>, <ebwizardry:magic_crystal>],
	]
);
