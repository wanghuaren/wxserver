package model

import (
	"database/sql"
	"projmxd/lib"
	"reflect"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB

func InstallData(tableName string, dat map[string]interface{}) (result int64) {
	if db == nil {
		InitDB()
		return 0
	}

	var fields = ""
	// var values = ""
	var valuesMark = ""
	var args []any
	for k, v := range dat {
		fields += k + ","
		// values += v + ","
		valuesMark += "?,"
		args = append(args, v)
	}
	fields = fields[0 : len(fields)-1]
	// values = values[0 : len(values)-1]
	valuesMark = valuesMark[0 : len(valuesMark)-1]

	sqlStr := "insert into " + tableName + "(" + fields + ") values (" + valuesMark + ")"
	FmtLog("SQL:%v%v", sqlStr, args)
	ret, err1 := db.Exec(sqlStr, args...)
	if err1 != nil {
		FileLog("SQL:"+sqlStr, args)
		FileLog("插入失败1:" + err1.Error())
		return 0
	}
	lastID, err2 := ret.LastInsertId()
	if err2 != nil {
		FileLog("SQL:"+sqlStr, args)
		FileLog("插入失败2:" + err1.Error())
		return 0
	}
	return lastID
}
func DelData(tableName string, requir map[string]interface{}, requirement ...string) (result int64) {
	if db == nil {
		InitDB()
		return 0
	}
	requirStr := ""
	var requirArgs []any
	mark := "and"
	if len(requirement) > 0 {
		mark = requirement[0]
	}
	if len(requir) > 0 {
		requirStr = " where "
		for k, v := range requir {
			requirStr += k + "=? " + mark + " "
			requirArgs = append(requirArgs, v)
		}
		requirStr = requirStr[0 : len(requirStr)-len(mark)-2]
	}
	sqlStr := "delete from " + tableName + requirStr
	FmtLog("SQL:%v", sqlStr)
	ret, err1 := db.Exec(sqlStr, requirArgs)
	if err1 != nil {
		return 0
	}
	lastID, err2 := ret.RowsAffected()
	if err2 != nil {
		return 0
	}
	return lastID
}
func EditData(tableName string, dat map[string]interface{}, requir map[string]interface{}, requirement ...string) (result int64) {
	if db == nil {
		InitDB()
		return 0
	}
	// sqlStr := "update user_tab set id=? where id = ?"

	var fields = ""
	var args []any
	for k, v := range dat {
		fields += k + "=?,"
		args = append(args, v)
	}
	fields = fields[0 : len(fields)-1]

	requirStr := ""
	var requirArgs []any
	mark := "and"
	if len(requirement) > 0 {
		mark = requirement[0]
	}
	if len(requir) > 0 {
		requirStr = " where "
		for k, v := range requir {
			requirStr += k + "=? " + mark + " "
			requirArgs = append(requirArgs, v)
		}
		requirStr = requirStr[0 : len(requirStr)-len(mark)-2]
	}

	sqlStr := "update " + tableName + " set " + fields + requirStr
	args = append(args, requirArgs...)
	FmtLog("SQL:%v%v", sqlStr, args)
	_, err1 := db.Exec(sqlStr, args...)
	if err1 != nil {
		FileLog("SQL:%v%v", sqlStr, args)
		FileLog("编辑失败1:" + err1.Error())
		return 0
	}
	return 1
}

func FindData[T lib.Conf | lib.UserTable | lib.UserQuestionTable | lib.UserMissionTable | lib.UserTicketTable](tableName string, requir map[string]interface{}, resultType T, requirement ...string) (result []T) {
	if db == nil {
		InitDB()
		return nil
	}

	var rows *sql.Rows
	var err1 error

	if requir != nil {
		requirStr := ""
		var requirArgs []any
		mark := "and"
		if len(requirement) > 0 {
			mark = requirement[0]
		}
		if len(requir) > 0 {
			requirStr = " where "
			for k, v := range requir {
				requirStr += k + "=? " + mark + " "
				requirArgs = append(requirArgs, v)
			}
			requirStr = requirStr[0 : len(requirStr)-len(mark)-2]
		}

		sqlStr := "select * from " + tableName + requirStr

		FmtLog("SQL:%v:%v", sqlStr, requirArgs)
		rows, err1 = db.Query(sqlStr, requirArgs...)
		if err1 != nil {
			FileLog("SQL:"+sqlStr, requirArgs)
			FileLog("查询错误1:" + err1.Error())
			return nil
		}
	} else {
		rows, err1 = db.Query(tableName)
		if err1 != nil {
			FileLog("SQL:" + tableName)
			FileLog("查询错误1:" + err1.Error())
			return nil
		}
	}

	defer rows.Close()

	for rows.Next() {
		// u := lib.UserTable{Id: 7, UserKey: "", MissionType: "", MissionTitle: "", MissionResult: ""}
		u := resultType

		// sVal := reflect.ValueOf(u)
		sVal := reflect.ValueOf(&u).Elem()
		sType := reflect.TypeOf(&u).Elem()
		num := sVal.NumField()

		var args []any
		var tempMap = map[string]any{}
		for i := 0; i < num; i++ {
			f := sType.Field(i)
			// val := sVal.Field(i).Interface()
			var val any
			tempMap[f.Name] = &val
			// args = append(args, tempMap[f.Name])
			args = append(args, &val)
		}
		err := rows.Scan(args...)
		if err != nil {
			FileLog(err.Error())
			return nil
		}
		for i := 0; i < num; i++ {
			f := sType.Field(i)
			// a := f.Type.Kind()
			// fmt.Println(a.String())
			val := sVal.Field(i)
			v := tempMap[f.Name]
			c := *v.(*interface{})
			if c != nil {
				var r reflect.Value
				switch f.Type.Kind().String() {
				case "int64":
					if _, ok := c.([]uint8); ok {
						m_v, _ := strconv.ParseInt(string(c.([]uint8)), 10, 64)
						r = reflect.ValueOf(m_v)
					} else {
						r = reflect.ValueOf(c)
					}

				case "string":
					cover := c.([]uint8)
					r = reflect.ValueOf(string(cover))
				case "bool":
					r = reflect.ValueOf(c.(bool))
				}
				val.Set(r)
			}
		}
		result = append(result, u)
	}
	FmtLog("查询返回数据:%v", result)
	return result

}

func RunSQL[T lib.Conf | lib.UserTable | lib.UserQuestionTable | lib.UserMissionTable | lib.UserTicketTable](sqlStr string, resultType T) (result []T) {
	return FindData(sqlStr, nil, resultType)
}

func InitDB() (err error) {
	go getToken()
	dsn := "root:root2023@tcp(127.0.0.1:3306)/expo"

	if isUAT {
		dsn = "root:root2023@tcp(127.0.0.1:3306)/expo"
	}

	FmtLog("MySQL DSN:%v", dsn)
	db, err = sql.Open("mysql", dsn)
	if err == nil {
		err = db.Ping()
	}
	if err != nil {
		FileLog("打开DB错误:%v", err.Error())
		db.Close()
		db = nil
	}
	return err
}
