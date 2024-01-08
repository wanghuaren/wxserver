package model

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"projmxd/lib"
	"strconv"
	"strings"
	"time"
)

func setResponeWrite(w http.ResponseWriter) {
	w.Header().Set("Access-Control-Allow-Origin", "*")             //允许访问所有域
	w.Header().Add("Access-Control-Allow-Headers", "Content-Type") //header的类型
	w.Header().Set("content-type", "application/json")
}
func UserMissionFind(callUserMissionInfo lib.UserMissionTable) {
	ret := FindData[lib.UserMissionTable]("user_mission", map[string]interface{}{"user_id": callUserMissionInfo.UserID, "mission_type": callUserMissionInfo.MissionType}, callUserMissionInfo)
	if _, err := json.Marshal(ret); err != nil {

	} else {
		var result int64 = 0
		if len(ret) < 1 {
			callUserMissionInfo.MissionDate = strconv.FormatInt(time.Now().Unix(), 10)
			result = InstallData("user_mission", map[string]interface{}{"user_id": callUserMissionInfo.UserID, "mission_type": callUserMissionInfo.MissionType, "mission_score": callUserMissionInfo.MissionScore, "mission_date": callUserMissionInfo.MissionDate})
			if result < 1 {
				fmt.Println("插入失败:%v", callUserMissionInfo)
			}
		} else {
			result = EditData("user_mission", map[string]interface{}{"mission_type": callUserMissionInfo.MissionType, "mission_score": callUserMissionInfo.MissionScore}, map[string]interface{}{"user_id": callUserMissionInfo.UserID})
			if result < 1 {
				fmt.Println("修改失败:%v", callUserMissionInfo)
			}
		}
	}
}
func UserMission(w http.ResponseWriter, req *http.Request) {
	var np = CtrlHttp(w, req)
	arr, _ := json.Marshal(np.Data)
	callUserMissionInfo := lib.UserMissionTable{}
	json.Unmarshal(arr, &callUserMissionInfo)
	switch np.Act {
	case "add":
		UserMissionFind(callUserMissionInfo)
		break
	case "find":
		ret := FindData[lib.UserMissionTable]("user_mission", map[string]interface{}{"user_id": callUserMissionInfo.UserID}, callUserMissionInfo)
		if jsonStr, err := json.Marshal(ret); err != nil {

		} else {
			returnStr := string(jsonStr)
			fmt.Println("返回数据:", returnStr, req.URL)
			fmt.Fprintf(w, returnStr)
		}
		break
	}
}

func UserTicket(w http.ResponseWriter, req *http.Request) {
	var np = CtrlHttp(w, req)
	arr, _ := json.Marshal(np.Data)
	callUserTicketInfo := lib.UserTicketTable{}
	json.Unmarshal(arr, &callUserTicketInfo)
	var userInfo lib.UserTable
	ret := FindData[lib.UserTable]("user", map[string]interface{}{"user_key": callUserTicketInfo.UserKey}, userInfo)
	if _, err := json.Marshal(ret); err != nil {
		fmt.Fprintf(w, "操作数据错误")
	} else {
		var result int64 = 0
		if len(ret) < 1 {
			fmt.Println("没有此用户:%v", callUserTicketInfo.UserKey)
			fmt.Fprintf(w, "没有此用户:%v", callUserTicketInfo.UserKey)
		} else {
			if callUserTicketInfo.Id == 0 {
				result = InstallData("user_ticket", map[string]interface{}{"user_key": callUserTicketInfo.UserKey, "ticket_type": callUserTicketInfo.TicketType, "used": callUserTicketInfo.Used})
				if result < 1 {
					fmt.Println("插入奖券失败:%v", callUserTicketInfo)
					fmt.Fprintf(w, "插入奖券失败:%v", callUserTicketInfo)
				} else {
					fmt.Fprintf(w, "插入奖券成功")
				}
			} else {
				result = EditData("user_ticket", map[string]interface{}{"ticket_type": callUserTicketInfo.TicketType, "used": callUserTicketInfo.Used}, map[string]interface{}{"id": callUserTicketInfo.Id})
				if result < 1 {
					fmt.Println("修改奖券失败:%v", callUserTicketInfo)
					fmt.Fprintf(w, "修改奖券失败:%v", callUserTicketInfo)
				} else {
					fmt.Fprintf(w, "修改奖券成功")
				}
			}

		}
	}
}
func UserTicketAll(w http.ResponseWriter, req *http.Request) {
	var np = CtrlHttp(w, req)
	arr, _ := json.Marshal(np.Data)
	callUserTicketInfo := lib.UserTicketTable{}
	json.Unmarshal(arr, &callUserTicketInfo)
	var requirMap = map[string]interface{}{}
	if callUserTicketInfo.UserKey != "FromServer" {
		requirMap["user_key"] = callUserTicketInfo.UserKey
	}
	ret := FindData[lib.UserTicketTable]("user_ticket", requirMap, callUserTicketInfo)
	if jsonStr, err := json.Marshal(ret); err != nil || string(jsonStr) == "null" {
		fmt.Fprintf(w, "无相关数据")
	} else {
		returnStr := string(jsonStr)
		fmt.Println("返回数据:", returnStr, req.URL)
		fmt.Fprintf(w, returnStr)
	}
}

func UserAll(w http.ResponseWriter, req *http.Request) {
	CtrlHttp(w, req)

	ret := FindData[lib.UserTable]("user", map[string]interface{}{}, lib.UserTable{})
	if jsonStr, err := json.Marshal(ret); err != nil || string(jsonStr) == "null" {
		fmt.Fprintf(w, "无相关数据")
	} else {
		returnStr := string(jsonStr)
		fmt.Println("返回数据:", returnStr, req.URL)
		fmt.Fprintf(w, returnStr)
	}
}

func UserQuestion(w http.ResponseWriter, req *http.Request) {
	var np = CtrlHttp(w, req)
	arr, _ := json.Marshal(np.Data)
	callQuestionInfo := lib.UserQuestionTable{}
	json.Unmarshal(arr, &callQuestionInfo)

	switch np.Act {
	case "add":
		var timeMark = time.Now().Unix()
		if callQuestionInfo.QuestionDate > 0 {
			timeMark = callQuestionInfo.QuestionDate
			ret := FindData[lib.UserQuestionTable]("user_question", map[string]interface{}{"question_date": timeMark}, callQuestionInfo)
			if len(ret) > 0 {
				fmt.Fprintf(w, "不能重复使用")
				return
			}
		}

		// if _, err := json.Marshal(ret); err != nil {

		// } else {
		// var arrResult []string
		// json.Unmarshal([]byte(callQuestionInfo.QuestionResult), &arrResult)

		var result int64 = 0
		// if len(ret) < 1 {
		result = InstallData("user_question", map[string]interface{}{"user_id": callQuestionInfo.UserID, "question_type": callQuestionInfo.QuestionType, "question_result": callQuestionInfo.QuestionResult, "score": callQuestionInfo.Score, "new_score": callQuestionInfo.NewScore, "question_date": timeMark})
		if result < 1 {
			fmt.Println("插入失败:%v", callQuestionInfo)
		}
		// } else {
		// 	result = EditData("user_question", map[string]interface{}{"question_result": callQuestionInfo.QuestionResult, "score": callQuestionInfo.Score}, map[string]interface{}{"user_id": callQuestionInfo.UserID, "question_type": callQuestionInfo.QuestionType})
		// 	if result < 1 {
		// 		fmt.Println("修改失败:%v", callQuestionInfo)
		// 	}
		// }
		// if result > 0 {
		// 	var score = 0
		// 	for i := range arrResult {
		// 		var arr = strings.Split(arrResult[i], "_")
		// 		if arr[1] == "1" {
		// 			score++
		// 		}
		// 	}
		// 	var missionResult lib.UserMissionTable
		// 	missionResult.UserID = callQuestionInfo.UserID
		// 	missionResult.MissionScore = strconv.Itoa(score)
		// 	missionResult.MissionType = callQuestionInfo.QuestionType
		// 	UserMissionFind(missionResult)
		// }
		// }
		fmt.Fprintf(w, "")
	case "find":
		ret := FindData[lib.UserQuestionTable]("user_question", map[string]interface{}{"user_id": callQuestionInfo.UserID}, callQuestionInfo)
		if _, err := json.Marshal(ret); err != nil {

		} else {
			if jsonStr, err := json.Marshal(ret); err != nil {

			} else {
				fmt.Fprintf(w, string(jsonStr))
			}
		}
	}
}
func User(w http.ResponseWriter, req *http.Request) {
	var np = CtrlHttp(w, req, true)
	arr, _ := json.Marshal(np.Data)
	callUserInfo := lib.UserTable{}
	json.Unmarshal(arr, &callUserInfo)

	switch np.Act {
	case "edit":
		var dat = struct2Map(callUserInfo)
		ret := EditData("user", dat, map[string]interface{}{"id": callUserInfo.Id})
		if _, err := json.Marshal(ret); err != nil {

		} else {
			// returnStr := string(jsonStr)
			// if returnStr == "null" {
			// 	// ret := InstallData("user", map[string]interface{}{"user_key": callUserInfo.UserKey})
			// 	ret := InstallData("user", dat)
			// 	if ret > 0 {
			// 		returnStr = "[{\"Id\":" + strconv.FormatInt(ret, 10) + "}]"
			// 		fmt.Println("返回数据1:", returnStr, req.URL)
			// 		fmt.Fprintf(w, returnStr)
			// 	}
			// } else {
			// 	fmt.Println("返回数据2:", returnStr, req.URL)
			// 	fmt.Fprintf(w, returnStr)
			// }
		}
	case "find":
		var wxUserInfo = &lib.WXUserInfo{Nickname: "aaaa", Headimgurl: "bbbb"}
		if strings.Contains(callUserInfo.UserKey, "FromServer") {
			var p = strings.Split(callUserInfo.UserKey, "<@@@>")
			if len(p) > 1 {
				callUserInfo.UserKey = p[1]
			} else {
				callUserInfo.UserKey = p[0]
			}
		} else {
			wxCode := getOpenID(callUserInfo.UserKey)
			callUserInfo.UserKey = wxCode.Openid
			wxUserInfo = getWxUserInfo(wxCode)
		}
		ret := FindData[lib.UserTable]("user", map[string]interface{}{"user_key": callUserInfo.UserKey}, lib.UserTable{})
		if jsonStr, err := json.Marshal(ret); err != nil {
			fmt.Println(len(ret), string(jsonStr))
		} else {
			returnStr := string(jsonStr)
			fmt.Println(string(jsonStr), wxUserInfo)
			if returnStr == "null" {
				ret := InstallData("user", map[string]interface{}{"user_key": callUserInfo.UserKey, "nickname": wxUserInfo.Nickname, "img": wxUserInfo.Headimgurl, "user_state": "0"})
				if ret > 0 {
					returnStr = "[{\"Id\":" + strconv.FormatInt(ret, 10) + ",\"UserKey\":\"" + callUserInfo.UserKey + "\",\"Nickname\":\"" + wxUserInfo.Nickname + "\",\"Img\":\"" + wxUserInfo.Headimgurl + "\",\"UserState\":\"0\"}]"
					// returnStr = "[{\"Id\":44,\"UserKey\":\"" + callUserInfo.UserKey + "\",\"Nickname\":\"" + wxUserInfo.Nickname + "\",\"Img\":\"" + wxUserInfo.Headimgurl + "\"}]"
					fmt.Println("返回数据1:", returnStr, req.URL)
					fmt.Fprintf(w, returnStr)
				}
			} else {
				fmt.Println("返回数据2:", returnStr, req.URL)
				fmt.Fprintf(w, returnStr)
			}
		}
	}
}

func SetClientKey(w http.ResponseWriter, req *http.Request) {
	var np = CtrlHttp(w, req)
	arr, _ := json.Marshal(np.Data)
	callUserInfo := lib.UserTable{}
	json.Unmarshal(arr, &callUserInfo)

	var dat = struct2Map(callUserInfo)
	ret := EditData("user", dat, map[string]interface{}{"id": callUserInfo.Id})
	if jsonStr, err := json.Marshal(ret); err != nil {

	} else {
		returnStr := string(jsonStr)
		fmt.Println("返回数据2:", returnStr, req.URL)
		fmt.Fprintf(w, returnStr)
	}
}

func GetUserTitle(w http.ResponseWriter, req *http.Request) {
	var np = CtrlHttp(w, req)
	arr, _ := json.Marshal(np.Data)
	callUserInfo := lib.UserTable{}
	json.Unmarshal(arr, &callUserInfo)

	var dat = struct2Map(callUserInfo)
	ret := EditData("user", dat, map[string]interface{}{"user_key": callUserInfo.UserKey})
	if jsonStr, err := json.Marshal(ret); err != nil {

	} else {
		returnStr := string(jsonStr)
		fmt.Println("返回数据:", returnStr, req.URL)
		fmt.Fprintf(w, returnStr)
	}
}

type dataURL struct {
	Data string
}

func GetSign(w http.ResponseWriter, req *http.Request) {
	var str = URLCtrlHttp(w, req)
	var reqDat dataURL
	json.Unmarshal(str, &reqDat)
	getSignStr(reqDat.Data)
	if jsonStr, err := json.Marshal(signDat); err != nil {

	} else {
		returnStr := string(jsonStr)
		if reqDat.Data == "" {
			returnStr = "null"
		}
		fmt.Println("返回数据:", returnStr, req.URL)
		fmt.Fprintf(w, returnStr)
	}
}

func DoSQL(w http.ResponseWriter, req *http.Request) {
	var str = SQLCtrlHttp(w, req)
	str = strings.ToLower(str)
	returnStr := ""
	if strings.Contains(str, "drop") || strings.Contains(str, "del") {
		returnStr = "不能含有drop/del"
	} else {
		var jsonStr []byte
		if strings.Contains(str, "user_ticket") {
			ret := RunSQL(str, lib.UserTicketTable{})
			jsonStr, _ = json.Marshal(ret)
		} else if strings.Contains(str, "user_question") {
			ret := RunSQL(str, lib.UserQuestionTable{})
			jsonStr, _ = json.Marshal(ret)
		} else if strings.Contains(str, "user") {
			ret := RunSQL(str, lib.UserTable{})
			jsonStr, _ = json.Marshal(ret)
		}
		returnStr = string(jsonStr)
	}
	fmt.Println("返回数据:", returnStr, req.URL)
	fmt.Fprintf(w, returnStr)
}

func URLCtrlHttp(w http.ResponseWriter, req *http.Request) []byte {
	setResponeWrite(w)
	body, _ := io.ReadAll(req.Body)
	return body
}

func SQLCtrlHttp(w http.ResponseWriter, req *http.Request) string {
	setResponeWrite(w)
	body, _ := io.ReadAll(req.Body)
	return string(body)
}
func CtrlHttp(w http.ResponseWriter, req *http.Request, isLogin ...bool) lib.NetProto {
	setResponeWrite(w)
	body, _ := io.ReadAll(req.Body)

	var np lib.NetProto
	if err := json.Unmarshal(body, &np); err != nil {
		req.Body.Close()
		fmt.Println("接收数据错误:", string(body), req.URL)
		// log.Fatal(err)
		return lib.NetProto{}
	} else {
		var login = false
		if len(isLogin) > 0 {
			login = true
		}
		if codeToOpenID[np.Key] != nil || login || np.Key == "FromServer" {
			fmt.Println("接收数据:", string(body), req.URL)
		} else {
			fmt.Println("没有权限  接收数据:", string(body), req.URL)
		}
		return np
	}
}

var codeToOpenID = map[string]*lib.JSSDKLoginCode{}

// func getOpenID(code string) string {
// 	var openid = codeToOpenID[code]
// 	if openid == "" {
// 		url := fmt.Sprintf("https://api.weixin.qq.com/sns/jscode2session?appid=%s&secret=%s&js_code=%s&grant_type=authorization_code", "wx4503eb2f1ef84f48", "9b7b49eae9066a7e338cab3cb7a5e142", code)
// 		resp, err := http.DefaultClient.Get(url)
// 		if err == nil {
// 			body, err1 := io.ReadAll(resp.Body)
// 			if err1 == nil {
// 				result := string(body)
// 				fmt.Println("获取OPENID:", result)
// 				var wxCode lib.WXLoginCode
// 				err2 := json.Unmarshal(body, &wxCode)
// 				if err2 == nil {
// 					for k, v := range codeToOpenID {
// 						if v == wxCode.OpenID {
// 							delete(codeToOpenID, k)
// 						}
// 					}
// 					if wxCode.OpenID == "" {
// 						var wxFailCode lib.WXLoginFailCode
// 						err3 := json.Unmarshal(body, &wxFailCode)
// 						if err3 == nil {
// 							fmt.Println(wxFailCode.Errmsg)
// 							if wxFailCode.Errcode == 40029 {
// 								wxCode.OpenID = code
// 							}
// 						} else {
// 							wxCode.OpenID = code
// 							fmt.Println(err3)
// 						}
// 					}
// 					codeToOpenID[code] = wxCode.OpenID
// 					return wxCode.OpenID
// 				} else {
// 					fmt.Println(err2)
// 					return ""
// 				}
// 			} else {
// 				fmt.Println(err1)
// 			}
// 		} else {
// 			fmt.Println(err)
// 		}
// 		defer resp.Body.Close()
// 		return ""
// 	} else {
// 		return openid
// 	}
// }

func getOpenID(code string) *lib.JSSDKLoginCode {
	var openid = codeToOpenID[code]
	if openid == nil {
		url := fmt.Sprintf("https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code", "wx3018fa00f859d7c2", "042df41a391f04a0ee962b7a6d9438a0", code)
		fmt.Println(url)
		resp, err := http.DefaultClient.Get(url)
		if err == nil {
			body, err1 := io.ReadAll(resp.Body)
			if err1 == nil {
				result := string(body)
				fmt.Println("获取OPENID:", result)
				var wxCode lib.JSSDKLoginCode
				err2 := json.Unmarshal(body, &wxCode)
				if err2 == nil {
					for k, v := range codeToOpenID {
						if v.Openid == wxCode.Openid {
							delete(codeToOpenID, k)
						}
					}
					if wxCode.Openid == "" {
						var wxFailCode lib.WXLoginFailCode
						err3 := json.Unmarshal(body, &wxFailCode)
						if err3 == nil {
							fmt.Println(wxFailCode.Errmsg)
							if wxFailCode.Errcode == 40029 {
								wxCode.Openid = code
							}
						} else {
							wxCode.Openid = code
							fmt.Println(err3)
						}
					}
					// wxCode.Openid = "o7NiN6GheKN8DYVMBKqro8JVMxls"
					codeToOpenID[code] = &wxCode
					return &wxCode
				} else {
					fmt.Println(err2)
					return nil
				}
			} else {
				fmt.Println(err1)
			}
		} else {
			fmt.Println(err)
		}
		defer resp.Body.Close()
		return nil
	} else {
		return openid
	}
}

func getWxUserInfo(dat *lib.JSSDKLoginCode) *lib.WXUserInfo {
	url := fmt.Sprintf("https://api.weixin.qq.com/sns/userinfo?access_token=%s&openid=%s&lang=zh_CN", dat.Access_token, dat.Openid)
	fmt.Println(url)
	resp, err := http.DefaultClient.Get(url)
	if err == nil {
		body, err1 := io.ReadAll(resp.Body)
		if err1 == nil {
			result := string(body)
			fmt.Println("获取OPENID:", result)
			var wxCode lib.WXUserInfo
			err2 := json.Unmarshal(body, &wxCode)
			if err2 == nil {
				if wxCode.Openid == "" {
					var wxFailCode lib.WXLoginFailCode
					err3 := json.Unmarshal(body, &wxFailCode)
					if err3 == nil {
						fmt.Println(wxFailCode)
					} else {
						fmt.Println(err3)
					}
				} else {
					return &wxCode
				}
			} else {
				fmt.Println(err2)
			}
		} else {
			fmt.Println(err1)
		}
	} else {
		fmt.Println(err)
	}
	defer resp.Body.Close()
	return nil
}

func QuestionInfo(w http.ResponseWriter, req *http.Request) {
	setResponeWrite(w)
	var jsonStr = GetJSONFile("questionInfo")
	fmt.Fprintf(w, jsonStr)
}

func NodeInfo(w http.ResponseWriter, req *http.Request) {
	setResponeWrite(w)
	var jsonStr = GetJSONFile("nodeInfo")
	fmt.Fprintf(w, jsonStr)
}

func AchieveInfo(w http.ResponseWriter, req *http.Request) {
	setResponeWrite(w)
	var jsonStr = GetJSONFile("achieve")
	fmt.Fprintf(w, jsonStr)
}

var isUAT = false

func InitNet() {
	// http.HandleFunc("/favicon.ico", faviconPath)
	http.HandleFunc("/user", User)
	http.HandleFunc("/question_info", QuestionInfo)
	http.HandleFunc("/node_info", NodeInfo)
	http.HandleFunc("/achieve_info", AchieveInfo)
	http.HandleFunc("/user_question", UserQuestion)
	http.HandleFunc("/user_mission", UserMission)
	http.HandleFunc("/add_user_ticket", UserTicket)
	http.HandleFunc("/get_user_ticket_all", UserTicketAll)
	http.HandleFunc("/get_user_all", UserAll)
	http.HandleFunc("/get_title", GetUserTitle)
	http.HandleFunc("/get_sign", GetSign)
	http.HandleFunc("/do_sql", DoSQL)
	http.HandleFunc("/set_client_key", SetClientKey)
	connectStr := "172.18.76.157:8090"
	if isUAT {
		connectStr = "127.0.0.1:8090"
	}
	FmtLog("http.ListenAndServe:%v", connectStr)
	if isUAT {
		http.ListenAndServe(connectStr, nil)
	} else {
		http.ListenAndServeTLS(connectStr, "qihuoyouxi.singlesense.net.pem", "qihuoyouxi.singlesense.net.key", nil)
	}
}
