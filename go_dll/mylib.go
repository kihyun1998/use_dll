package main

/*
#include <stdlib.h>
*/
import "C"
import "unsafe"

//export CallBasic2
func CallBasic2(key, msg *C.char) (resultMsg *C.char, isOk bool) {
	// key와 msg를 Go 문자열로 변환
	goKey := C.GoString(key)
	goMsg := C.GoString(msg)

	// 실제 비즈니스 로직 구현
	if goKey == "valid_key" {
		isOk = true
		resultMsg = C.CString("Success: " + goMsg)
	} else {
		isOk = false
		resultMsg = C.CString("Failed: unvalid key.")
	}

	return
}

//export FreeString
func FreeString(ptr *C.char) {
	C.free(unsafe.Pointer(ptr))
}

func main() {}
