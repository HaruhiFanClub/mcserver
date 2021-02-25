#priority 17

import crafttweaker.data.IData;
import crafttweaker.game.IGame;
import crafttweaker.item.IIngredient;
import crafttweaker.item.IItemStack;
import crafttweaker.oredict.IOreDictEntry;

recipes.addShapeless(<minecraft:nether_star>*9, [<contenttweaker:netherstar_block>]);
recipes.addShapeless(<contenttweaker:netherstar_block>*9, [<contenttweaker:compressed_netherstar_block>]);
recipes.addShapeless(<contenttweaker:compressed_netherstar_block>*9, [<contenttweaker:double_compressed_netherstar_block>]);
recipes.addShapeless(<contenttweaker:double_compressed_netherstar_block>*9, [<contenttweaker:triple_compressed_netherstar_block>]);
recipes.addShapeless(<contenttweaker:triple_compressed_netherstar_block>*9, [<contenttweaker:quadruple_compressed_netherstar_block>]);
recipes.addShapeless(<contenttweaker:quadruple_compressed_netherstar_block>*9, [<contenttweaker:quintuple_compressed_netherstar_block>]);
recipes.addShapeless(<contenttweaker:quintuple_compressed_netherstar_block>*9, [<contenttweaker:sextuple_compressed_netherstar_block>]);
recipes.addShapeless(<contenttweaker:sextuple_compressed_netherstar_block>*9, [<contenttweaker:septuple_compressed_netherstar_block>]);
recipes.addShapeless(<contenttweaker:septuple_compressed_netherstar_block>*9, [<contenttweaker:eightfold_compressed_netherstar_block>]);
recipes.addShapeless(<contenttweaker:eightfold_compressed_netherstar_block>*9, [<contenttweaker:ninefold_compressed_netherstar_block>]);

recipes.addShapeless(
	"tditp",
	<contenttweaker:death_teleporter>,
	[
		<gravestone:death_info>
			.only(function (item) {
				if ((item.tag has "info") && !(item.tag has "transformed")) {
					return true;
				}
				return false;
			})
			.marked("mark")
	],
	function(out,ins,cInfo){
		val info = ins.mark.tag.info;
		return out.updateTag(info - "items" + {type: 0}).withLore([
				"§r§7Name: "+info.name,
				"§r§7UUID: "+info.uuid,
				"§r§7Pos: "+"("+info.pos_x+","+info.pos_y+","+info.pos_z+","+info.dim+")",
				"§r§7Time: "+info.time
			]);
	},
	null
);

recipes.addShaped(
	"ench_tditp_1",
	<contenttweaker:death_teleporter>,
	[
		[null, <ore:enderpearl>, null],
		[
			<ore:enderpearl>,
			<contenttweaker:death_teleporter>
				.only(function (item) {
					if (!(item.tag has "ench") && (item.tag has "type") && (item.tag.type == 0)) {
						return true;
					}
					return false;
				})
				.marked("mark"),
			<ore:enderpearl>
		],
		[null, <ore:enderpearl>, null],
	],
	function(out,ins,cInfo){
		val data = ins.mark.tag;
		return out.updateTag(data + {ench: [{lvl: 0 as short, id: -1 as short}], type: 1} as IData).withLore(["§r§7Upgrade: Ender pearl"]);
	},
	null
);

recipes.addShapeless(
	"ench_tditp_2",
	<contenttweaker:death_teleporter>,
	[
		<minecraft:golden_apple>,
		<minecraft:golden_apple>,
		<contenttweaker:death_teleporter>
			.only(function (item) {
				if (!(item.tag has "ench") && (item.tag has "type") && (item.tag.type == 0)) {
					return true;
				}
				return false;
			})
			.marked("mark"),
	],
	function(out,ins,cInfo){
		val data = ins.mark.tag;
		return out.updateTag(data + {ench: [{lvl: 0 as short, id: -1 as short}], type: 3} as IData).withLore(["§r§7Upgrade: Golden apple x2"]);
	},
	null
);

recipes.addShapeless(
	"ench_tditp_3",
	<contenttweaker:death_teleporter>,
	[
		<minecraft:golden_apple>,
		<contenttweaker:death_teleporter>
			.only(function (item) {
				if ((item.tag has "ench") && (item.tag has "type") && (item.tag.type == 1)) {
					return true;
				}
				return false;
			})
			.marked("mark")
	],
	function(out,ins,cInfo){
		val data = ins.mark.tag;
		return out.updateTag(data + {type: 2} as IData).withLore(["§r§7Upgrade: Golden apple"]);
	},
	null
);