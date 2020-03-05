package main

import (
	"io/ioutil"
	"net/http"
	"reflect"
	"strconv"
	"strings"
	"time"
)

// GoogleSheet :
type GoogleSheet struct {
	URL             string
	HeaderMode      bool
	UpdateInternval time.Duration
	Client          *http.Client
}

// NewGS :
func NewGS(URL string) *GoogleSheet {
	return &GoogleSheet{
		URL:        URL,
		HeaderMode: true,
		Client:     http.DefaultClient,
	}
}

func (gs *GoogleSheet) getURL() string {
	if strings.HasSuffix(gs.URL, "/") {
		return gs.URL + "export?format=csv"
	}
	return gs.URL + "/export?format=csv"
}

// Get :
func (gs *GoogleSheet) Get(ptr interface{}) error {

	request, err := http.NewRequest("GET", gs.getURL(), nil)
	if err != nil {
		return err
	}

	response, err := gs.Client.Do(request)
	if err != nil {
		return err
	}

	responseBytes, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return err
	}

	lines := strings.Split(string(responseBytes), "\r\n")
	return gs.apply(ptr, lines)
}

func (gs *GoogleSheet) apply(ptr interface{}, lines []string) error {
	slice := reflect.ValueOf(ptr).Elem()
	sliceType := reflect.TypeOf(ptr).Elem().Elem()
	hasPointer := false
	if sliceType.Kind() == reflect.Ptr {
		sliceType = sliceType.Elem()
		hasPointer = true
	}

	if gs.HeaderMode {
		lines = lines[:1]
	}

	for _, line := range lines {
		row := strings.Split(line, ",")
		instance := reflect.New(sliceType).Elem()
		for num := 0; num < sliceType.NumField(); num++ {
			key := sliceType.Field(num).Tag.Get("gs")
			if key != "" {
				column, _ := strconv.ParseInt(key, 10, 64)
				instance.Field(num).Set(reflect.ValueOf(row[column]))
			}
		}

		if hasPointer {
			instance = instance.Addr()
		}
		slice.Set(reflect.Append(slice, instance))
	}

	return nil
}
