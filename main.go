package main

import (
	"projmxd/model"
)

func main() {
	model.InitLog()
	model.FmtLog("server start")

	// model.InitExecl("execl.xlsx")
	// model.ReadFirstRow(0)
	model.InitDB()
	// dat := map[string]string{}
	// dat["user_key"] = "aaaaaa"
	// dat["mission_type"] = "bbbbbb"
	// dat["mission_title"] = "cccccc"
	// dat["mission_result"] = "dddddd"
	// model.InstallData(dat)

	// p := lib.UserTable{Id: 7, UserKey: "", MissionType: "", MissionTitle: "", MissionResult: ""}
	// ret := model.FindData("user_tab", 1, lib.UserTable{})
	// fmt.Print(ret)
	model.InitNet()
}
