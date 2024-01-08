package model

import (
	"fmt"
	"log"
	"os"
)

func InitLog() {
	f, err := os.OpenFile("log.log", os.O_CREATE|os.O_APPEND|os.O_RDWR, os.ModePerm)
	if err != nil {
		return
	}
	// defer func() {
	// 	f.Close()
	// }()
	log.SetOutput(f)
	// multiWriter := io.MultiWriter(os.Stdout, f)
	// log.SetOutput(multiWriter)
	log.SetFlags(log.Ldate | log.Ltime)
}
func FileLog(str string, args ...any) {
	logStr := str
	if len(args) > 0 {
		logStr = fmt.Sprintf(str+"\n", args...)
	}
	log.Println(logStr)
	FmtLog(str, args...)
}
func FmtLog(str string, args ...any) {
	if len(args) > 0 {
		str = fmt.Sprintf(str, args...)
	}
	fmt.Println(str)
}
