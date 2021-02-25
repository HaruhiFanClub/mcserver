#priority 49

function BuildExecute (target as string, pos as string[], command as string) {
	return "execute "+ target + " " + pos[0]+ " " + pos[1]+ " " + pos[2]+ " " + command;
}

function BuildTellraw (target as string, raw_json_text as string[]) {
	var c = "";
	for item in raw_json_text {
		c += ("," + item);
	}
	return "tellraw "+ target + " [\"\"" + c + "]";
}
