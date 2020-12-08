import crafttweaker.entity.IEntity;
import crafttweaker.entity.IEntityEquipmentSlot;
import crafttweaker.data.IData;
import crafttweaker.world.IWorld;
import crafttweaker.player.IPlayer;
import mods.zenutils.UUID;
import mods.zenutils.StringList;
import mods.zenutils.command.ZenCommand;
import mods.zenutils.command.CommandUtils;
import mods.zenutils.command.IGetTabCompletion;
import scripts.utils.common.RunCmd;
import scripts.utils.command.vanilla.BuildTellraw;

val cmdLoginCount as ZenCommand = ZenCommand.create("login_count");
cmdLoginCount.getCommandUsage = function(sender) {
	return "command.shw.login_count.usage";
};
cmdLoginCount.requiredPermissionLevel = 4;
cmdLoginCount.tabCompletionGetters = [
	function(server, sender, pos) {
		return StringList.create(["get", "set"]);
	} as IGetTabCompletion, 
	IGetTabCompletion.player()
];
cmdLoginCount.execute = function(command, server, sender, args) {
	val player = CommandUtils.getCommandSenderAsPlayer(sender).getUUID();
	if ((args.length == 2) && (args[0] == "get")) {
		val target = CommandUtils.getPlayer(server, sender, args[1]);
		var count;
		if (!isNull(target.data.PlayerPersisted.loggedIn)) {
			count = target.data.PlayerPersisted.loggedIn;
		} else {
			count = "0";
		}
		RunCmd(BuildTellraw(player, ["{\"translate\":\"command.shw.login_count.message.1\", \"with\":[\""+target.name+"\", \""+count+"\"]}"] as string[]));
		return;
	}
	if ((args.length == 3) && (args[0] == "set")) {
		val target = CommandUtils.getPlayer(server, sender, args[1]);
		var before;
		if (!isNull(target.data.PlayerPersisted.loggedIn)) {
			before = target.data.PlayerPersisted.loggedIn;
		} else {
			before = "0";
		}
		target.update({PlayerPersisted:{loggedIn:(args[2] as int)}} as IData);
		val after = target.data.PlayerPersisted.loggedIn;
		RunCmd("scoreboard players set " + target.name + " loggedIn " + (after as int));
		RunCmd(BuildTellraw(player, ["{\"translate\":\"command.shw.login_count.message.2\", \"with\":[\""+target.name+"\", \""+before+"\", \""+after+"\"]}"] as string[]));
		return;
	}
	CommandUtils.notifyWrongUsage(command, sender);
	return;
};
cmdLoginCount.register();

val cmdHat as ZenCommand = ZenCommand.create("hat");
cmdHat.getCommandUsage = function(sender) {
	return "command.shw.hat.usage";
};
cmdHat.requiredPermissionLevel = 0;
cmdHat.tabCompletionGetters = [];
cmdHat.execute = function(command, server, sender, args) {
	if (args.length == 0) {
		val player = CommandUtils.getCommandSenderAsPlayer(sender);
		val item_hand = player.getItemInSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand());
		val item_head = player.getItemInSlot(crafttweaker.entity.IEntityEquipmentSlot.head());
		if ((!isNull(item_head)) && (item_head.tag has "ench") && !(player.creative)) {
			for index,item in item_head.tag.ench.asList() {
					if (item.id == 10 as short) {
					RunCmd(BuildTellraw(player.name,["{\"translate\":\"command.shw.hat.error\"}"]));
					return;
				}
			}
		}
		player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.head(), item_hand);
		player.setItemToSlot(crafttweaker.entity.IEntityEquipmentSlot.mainHand(), item_head);
		return;
	}
	CommandUtils.notifyWrongUsage(command, sender);
};
cmdHat.register();


val myScoreCmd as ZenCommand = ZenCommand.create("myscore");
myScoreCmd.getCommandUsage = function(sender) {
	return "command.shw.myscore.usage";
};
myScoreCmd.requiredPermissionLevel = 0;
myScoreCmd.tabCompletionGetters = [];
myScoreCmd.execute = function(command, server, sender, args) {
	val player = CommandUtils.getCommandSenderAsPlayer(sender).getUUID();
	if (args.length == 0) {
		val scoreObjective = {
			"loggedIn" : "message.1",
			"deathCount" : "message.2",
			"killCount" : "message.3"
		} as string[string];
		for obj, lang in scoreObjective {	
			RunCmd(BuildTellraw(player, ["{\"translate\":\"command.shw.myscore." + lang +"\"}", "{\"score\":{\"name\":\"*\",\"objective\":\"" + obj + "\"}}"] as string[]));
		}
		return;
	}
	CommandUtils.notifyWrongUsage(command, sender);
};
myScoreCmd.register();

val cmdSuicide as ZenCommand = ZenCommand.create("suicide");
cmdSuicide.getCommandUsage = function(sender) {
	return "command.shw.suicide.usage";
};
cmdSuicide.requiredPermissionLevel = 0;
cmdSuicide.tabCompletionGetters = [];
cmdSuicide.execute = function(command, server, sender, args) {
	if (args.length == 0) {
		val player = CommandUtils.getCommandSenderAsPlayer(sender);
		val uuid = player.getUUID();
		RunCmd("kill " + uuid);
		print("Player " + player.name +"("+uuid+") committed suicide");
		return;
	}
	CommandUtils.notifyWrongUsage(command, sender);
};
cmdSuicide.register();