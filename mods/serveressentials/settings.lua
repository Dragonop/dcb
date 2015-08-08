AFK_CHECK = true --Whether or not to automatically kick afk players
MAX_AFK_TIME = 600 --Max time allowed afk before kick 
AFK_CHECK_INTERVAL = 1 --Number of seconds between activity checks
AFK_WARN_TIME = 20 --Number of seconds before being kicked that a player will start to be warned

SHOW_FIRST_TIME_JOIN_MSG = true --Whether or not to show FIRST_TIME_JOIN_MSG if a new player joins
--FIRST_TIME_JOIN_MSG = " has joined the server for the first time, Welcome!" --Message to broadcast to all players when a new player joins the server, will follow the players name
local name = minetest.setting_get("server_name") or "[SERVER]"
FIRST_TIME_JOIN_MSG = " has joined the server for the first time!  Welcome to "..name --minetest.setting_get("server_name")

--BROADCAST_PREFIX = "[SERVER]" --All messages sent with the /broadcast command will be prefixed with this
BROADCAST_PREFIX = minetest.setting_get("broadcast_prefix") or "[SERVER]"

DISALLOWED_NODES = { --These nodes will be immediatly removed if they are placed. Players with the disallowednodes priv can place them
	"tnt:tnt",
}

REMOVE_BONES = false --If true, remove bones after REMOVE_BONES_TIME seconds
--REMOVE_BONES_TIME = 600 --Remove bones after this amount of time (seconds)
REMOVE_BONES_TIME = minetest.setting_get("remove_bones_time") or 600

KICK_CHATSPAM = true --Ilf true, players who send a chat message longer than MAX_CHAT_MSG_LENGTH will be kicked
--MAX_CHAT_MSG_LENGTH = 400
MAX_CHAT_MSG_LENGTH = minetest.setting_get("max_chat_msg_length") or 400
