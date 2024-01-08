package model

import (
	"crypto/md5"
	"crypto/sha1"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"reflect"
	"strconv"
	"time"

	"github.com/heyhip/frog"
)

func struct2Map(structObj any) map[string]interface{} {
	var result = map[string]interface{}{}
	vs := reflect.ValueOf(structObj)
	ks := reflect.TypeOf(structObj)
	count := vs.NumField()
	for i := 0; i < count; i++ {
		k := ks.Field(i)
		v := vs.Field(i)
		val := v.Kind()
		switch val {
		case reflect.String:
			result[frog.Camel2Case(k.Name)] = v.String()
		case reflect.Int:
			result[frog.Camel2Case(k.Name)] = v.Int()
		case reflect.Int64:
			result[frog.Camel2Case(k.Name)] = v.Int()
		}
	}
	return result
}

type TokenInfo struct {
	Access_token string
	Expires_in   int
}

var tokenDat = &TokenInfo{}

func getToken() {
	if isUAT {
		return
	}
	req, err := http.NewRequest("GET", "https://api.weixin.qq.com/cgi-bin/token", nil)
	if err == nil {
		q := req.URL.Query()
		q.Add("grant_type", "client_credential")
		q.Add("appid", signDat.AppId)
		q.Add("secret", "042df41a391f04a0ee962b7a6d9438a0")
		req.URL.RawQuery = q.Encode()

		httpClient := http.Client{}
		response, err := httpClient.Do(req)
		if err == nil {
			respBytes, err := io.ReadAll(response.Body)
			fmt.Println(string(respBytes))
			if err == nil {
				err = json.Unmarshal(respBytes, tokenDat)
				if err != nil {
					fmt.Println(err)
					time.Sleep(time.Second)
					getToken()
					return
				}
			} else {
				fmt.Println(err)
				time.Sleep(time.Second)
				getToken()
				return
			}
		} else {
			fmt.Println(err)
			time.Sleep(time.Second)
			getToken()
			return
		}
	} else {
		fmt.Println(err)
		time.Sleep(time.Second)
		getToken()
		return
	}
	if tokenDat.Access_token == "" {
		fmt.Println(tokenDat)
		time.Sleep(time.Second)
		getToken()
		return
	}
	getTicket()
	time.Sleep(time.Minute * 60)
	getToken()
}

type TicketInfo struct {
	Errcode    int
	Errmsg     string
	Ticket     string
	Expires_in int
}

type SignInfo struct {
	AppId     string
	Timestamp string
	NonceStr  string
	Signature string
}

var ticketDat = &TicketInfo{}

var signDat = &SignInfo{AppId: "wx3018fa00f859d7c2"}

func getTicket() {
	req, err := http.NewRequest("GET", "https://api.weixin.qq.com/cgi-bin/ticket/getticket", nil)
	if err == nil {
		q := req.URL.Query()
		q.Add("access_token", tokenDat.Access_token)
		q.Add("type", "jsapi")
		req.URL.RawQuery = q.Encode()

		httpClient := http.Client{}
		response, err := httpClient.Do(req)
		if err == nil {
			respBytes, err := io.ReadAll(response.Body)
			fmt.Println(string(respBytes))
			if err == nil {
				err = json.Unmarshal(respBytes, ticketDat)
				if err != nil {
					fmt.Println(err)
					time.Sleep(time.Second)
					getTicket()
					return
				}
			} else {
				fmt.Println(err)
				time.Sleep(time.Second)
				getTicket()
				return
			}
		} else {
			fmt.Println(err)
			time.Sleep(time.Second)
			getTicket()
			return
		}
	} else {
		fmt.Println(err)
		time.Sleep(time.Second)
		getTicket()
		return
	}
}

func getSignStr(url string) {
	FmtLog("getSignStr:%v", url)
	signDat.Timestamp = strconv.FormatInt(time.Now().Unix(), 10)

	has := md5.Sum([]byte(signDat.Timestamp[2:]))
	signDat.NonceStr = fmt.Sprintf("%x", has)

	// signStr := "jsapi_ticket=" + ticketDat.Ticket + "&noncestr=" + signDat.NonceStr + "&timestamp=" + signDat.Timestamp + "&url=http://qihuoyouxi.singlesense.net/"
	signStr := "jsapi_ticket=" + ticketDat.Ticket + "&noncestr=" + signDat.NonceStr + "&timestamp=" + signDat.Timestamp + "&url=" + url

	o := sha1.New()
	o.Write([]byte(signStr))
	signDat.Signature = hex.EncodeToString(o.Sum(nil))

	fmt.Println(signDat)
}
