package lib

type Conf struct {
	Id   int64  `ex:"索引ID"`
	Host string `ex:"服务器地址"`
	Port string `ex:"服务器端口"`
}

type UserTable struct {
	Id        int64  `ex:"索引ID"`
	UserKey   string `ex:"用户从微信返回的KEY"`
	Score1    string `ex:"用户积分1"`
	Score2    string `ex:"用户积分2"`
	Score3    string `ex:"用户积分3"`
	Visited   string
	Title     int64
	Done      string
	DoneDate  string
	ClientKey string
	Nickname  string
	Img       string
	NewScore  string
	UserState string
}
type UserQuestionTable struct {
	Id             int64  `ex:"索引ID"`
	UserID         string `ex:"用户ID"`
	QuestionType   string `ex:"登岛任务名称"`
	QuestionResult string `ex:"任务积分"`
	Score          int64
	QuestionDate   int64
	NewScore       int64
}
type UserMissionTable struct {
	Id           int64  `ex:"索引ID"`
	UserID       string `ex:"用户ID"`
	MissionType  string `ex:"登岛任务名称"`
	MissionScore string `ex:"任务积分"`
	MissionDate  string `ex:"登岛日期"`
}
type UserTitleTable struct {
	Id         int64  `ex:"索引ID"`
	UserID     string `ex:"用户ID"`
	TitleName  string `ex:"称号名称"`
	TitleScore string `ex:"称号积分"`
	TitleDate  string `ex:"称号日期"`
	IsGet      bool   `ex:"是否领取"`
}
type UserRecordTable struct {
	Id       int64  `ex:"索引ID"`
	UserID   string `ex:"用户ID"`
	Desc     string `ex:"记录详情"`
	DescDate string `ex:"记录日期"`
}

type UserTicketTable struct {
	Id         int64  `ex:"索引ID"`
	UserKey    string `ex:"用户UUID"`
	TicketType string `ex:"奖券类型"`
	Used       int64  `ex:"奖券是否使用"`
}

type WXLoginCode struct {
	SessionKey string
	OpenID     string
}

type JSSDKLoginCode struct {
	Access_token    string
	Expires_in      int32
	Refresh_token   string
	Openid          string
	Scope           string
	Is_snapshotuser int32
	Unionid         string
}

type WXUserInfo struct {
	Openid     string
	Nickname   string
	Sex        int32
	Province   string
	City       string
	Country    string
	Headimgurl string
	Privilege  []string
	Unionid    string
}

type WXLoginFailCode struct {
	Errcode int64
	Errmsg  string
}
type NetProto struct {
	Act  string
	Key  string
	Data interface{}
}
