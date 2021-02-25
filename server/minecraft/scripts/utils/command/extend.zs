#priority 48

function BuildServerChan (target as string, raw_json_text as string[]) {
	var json = ["{\"translate\":\"character.server_chan.name\",\"bold\":true}"] as string[];
	for item in raw_json_text {
		json += item;
	}
	return scripts.utils.command.vanilla.BuildTellraw(target,json);
}
