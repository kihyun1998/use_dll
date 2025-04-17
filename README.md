# use_dll
 

## dll build

```bash
go build -o mylib.dll -buildmode=c-shared mylib.go
```

## windows dll build

```bash
# 명령 프롬프트(cmd)에서:
GOOS=windows GOARCH=amd64 go build -o mylib.dll -buildmode=c-shared mylib.go

# PowerShell에서:
$env:GOOS="windows"; $env:GOARCH="amd64"; go build -o mylib.dll -buildmode=c-shared mylib.go
```

## macos dll build

### intel mac

```bash
# 명령 프롬프트(cmd)에서:
GOOS=darwin GOARCH=amd64 go build -o mylib.dylib -buildmode=c-shared mylib.go

# PowerShell에서:
$env:GOOS="darwin"; $env:GOARCH="amd64"; go build -o mylib.dylib -buildmode=c-shared mylib.go
```

### apple mac

```bash
# 명령 프롬프트(cmd)에서:
GOOS=darwin GOARCH=arm64 go build -o mylib.dylib -buildmode=c-shared mylib.go

# PowerShell에서:
$env:GOOS="darwin"; $env:GOARCH="arm64"; go build -o mylib.dylib -buildmode=c-shared mylib.go
```