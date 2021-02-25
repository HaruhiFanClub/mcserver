#priority 4

#loader contenttweaker

import mods.contenttweaker.VanillaFactory;
import mods.contenttweaker.Block;
import mods.contenttweaker.BlockMaterial;
import mods.contenttweaker.PushReaction;

val cot_netherstar_stack = [
	"netherstar_block",
	"compressed_netherstar_block",
	"double_compressed_netherstar_block",
	"triple_compressed_netherstar_block",
	"quadruple_compressed_netherstar_block",
	"quintuple_compressed_netherstar_block",
	"sextuple_compressed_netherstar_block",
	"septuple_compressed_netherstar_block",
	"eightfold_compressed_netherstar_block",
	"ninefold_compressed_netherstar_block",
] as string[];
val ns_block_resistance = [81, 243, 729, 2187, 6561, 19683, 59049, 117147, 589824, 1179648] as int[];
for index,item in cot_netherstar_stack {
	var item = VanillaFactory.createBlock(item, <blockmaterial:iron>);
	item.setBeaconBase(true);
	item.setEntitySpawnable(false);
	item.setBlockHardness(16*(index+1));
	item.setBlockResistance(ns_block_resistance[index]);
	item.setToolClass("pickaxe");
	item.setToolLevel(3);
	item.setBlockSoundType(<soundtype:metal>);
	item.setCreativeTab(<creativetab:buildingBlocks>);
	item.setWitherProof(true);
	item.setMobilityFlag(mods.contenttweaker.PushReaction.block());
	item.register();
}
