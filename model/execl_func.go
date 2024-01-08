package model

import (
	"fmt"
	"os"
	"reflect"

	"github.com/xuri/excelize/v2"
)

var ef *excelize.File
var holder interface{}

func InitExecl(file_name string) {
	ef, _ = excelize.OpenFile(file_name)
	// holder = make([]*lib.PeopleInfo, 0, 10)
}
func ReadFirstRow(idx int) error {
	rows, err := ef.GetRows("Sheet1") // 所有行
	if err != nil {
		return err
	}
	row := rows[1]

	tp := reflect.TypeOf(holder).Elem().Elem().Elem() // 结构体的类型
	val := reflect.New(tp)                            // 创建一个新的结构体对象

	field := val.Elem().Field(idx) // 第idx个字段的反射Value
	cellValue := row[idx]          // 第idx个字段对应的Excel数据
	field.SetString(cellValue)     // 将Excel数据保存到结构体对象的对应字段中

	listV := reflect.ValueOf(holder)
	listV.Elem().Set(reflect.Append(listV.Elem(), val)) // 将结构体对象添加到holder中

	return nil
}

var fileMap = map[string]string{}

func GetJSONFile(fileName string) string {
	var result = fileMap[fileName]
	if result == "" {
		filePtr, err := os.ReadFile("./" + fileName + ".json")
		if err != nil {
			fmt.Println("文件打开失败 [Err:%s]", err.Error())
		} else {
			result = string(filePtr)
			fileMap[fileName] = result
		}
	}
	return result
}
