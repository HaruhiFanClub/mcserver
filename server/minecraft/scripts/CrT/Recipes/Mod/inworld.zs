import crafttweaker.data.IData;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IIngredient;
import mods.inworldcrafting.FluidToFluid;
import mods.inworldcrafting.FluidToItem;

FluidToFluid.transform(<liquid:holy_water>, <liquid:blood>, [<ebwizardry:master_healing_wand>], true);

val arms = [
	<minecraft:iron_sword>,
	<minecraft:wooden_sword>,
	<minecraft:stone_sword>,
	<minecraft:diamond_sword>,
	<minecraft:golden_sword>,
	<bewitchment:silver_sword>,
	<bewitchment:cold_iron_sword>,
	<cfm:item_knife>,
	<randomthings:spectresword>,
	<atum:stoneguard_greatsword>,
	<atum:limestone_sword>,
	<atum:iron_dagger>,
	<atum:dagger_poison>,
	<atum:iron_scimitar>,
	<atum:iron_greatsword>,
	<atum:iron_club>
] as IItemStack[];
for item in arms {
	FluidToItem.transform(item.withTag({ench: [{lvl: 13 as short, id: 17 as short}]} as IData), <liquid:holy_water>, [item], true);
}