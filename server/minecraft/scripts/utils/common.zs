#priority 59

import crafttweaker.server.IServer;
import crafttweaker.command.ICommandManager;
import crafttweaker.command.ICommand;
import crafttweaker.command.ICommandSender;

function RunCmd (c as string) {
	server.commandManager.executeCommand(server,c);
}
