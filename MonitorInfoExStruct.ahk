#Requires AutoHotkey v2.0.0+
;==============================================================
; MONITORINFOEX — Wrapper for WINUSER.H MONITORINFOEX
;
; GitHub: https://github.com/SevenKeyboard/monitor-info-ex-struct
; Author: SevenKeyboard Ltd. (2025)
; License: The Unlicense
;
; Documentation / References:
;   EnumDisplayMonitors function (winuser.h)
;     https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enumdisplaymonitors
;   MONITORENUMPROC callback function (winuser.h)
;     https://learn.microsoft.com/en-us/windows/win32/api/winuser/nc-winuser-monitorenumproc
;   GetMonitorInfoW function (winuser.h)
;     https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getmonitorinfow
;   MONITORINFOEXW structure (winuser.h)
;     https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-monitorinfoexw
;
; Version:
;   MONITORINFOEX_VERSION = 1.0.0
;==============================================================
class MONITORINFOEX_VersionManager
{
    static _ := this.init()
    static init()    {
        global
        MONITORINFOEX_VERSION := "1.0.0"
    }
}
MONITORINFOEX(header)    {
    return MONITORINFOEXW(header)
}
MONITORINFOEXW(header)    {
    switch (header)
    {
        case "winuser.h":   return MONITORINFOEXW_winuser()
    }
}
class MONITORINFOEXW_winuser
{
    Ptr    {
        get => this._ptr
        set => this.rcWork._ptr:= this.rcMonitor._ptr:= this._ptr:= value
    }
    setCbSize()    {
        numPut("UInt",104, this._ptr, 0) ;  sizeof(MONITORINFOEX)
    }
    getObj(hMonitor?)    {
        if (!this._ptr)
            return {}
        obj:={}
        ,obj.cbSize:=this.cbSize
        ,obj.rcMonitor:={}
        ,obj.rcMonitor.left:=this.rcMonitor.left
        ,obj.rcMonitor.top:=this.rcMonitor.top
        ,obj.rcMonitor.right:=this.rcMonitor.right
        ,obj.rcMonitor.bottom:=this.rcMonitor.bottom
        ,obj.rcWork:={}
        ,obj.rcWork.left:=this.rcWork.left
        ,obj.rcWork.top:=this.rcWork.top
        ,obj.rcWork.right:=this.rcWork.right
        ,obj.rcWork.bottom:=this.rcWork.bottom
        ,obj.dwFlags:=this.dwFlags
        ,obj.szDevice:=this.szDevice
        if (isSet(hMonitor))
            obj.hMonitor:=hMonitor
        return obj
    }
    _ptr:=0
    __new()    {
        this.struct:=buffer(104,0), this._ptr:=this.struct.ptr
        this.rcMonitor:=MONITORINFOEXW_winuser._rcMonitor()
        this.rcMonitor._ptr:=this._ptr
        this.rcWork:=MONITORINFOEXW_winuser._rcWork()
        this.rcWork._ptr:=this._ptr        
        return this
    }
    __get(name, params)    {
        switch (name)
        {
            case "cbSize":      return numGet(this._ptr, 0, "UInt")
            case "dwFlags":     return numGet(this._ptr, 36, "UInt")
            case "szDevice":    return strGet(this._ptr+40, 32, "UTF-16")
        }
    }
    __set(name, param, value)     {
        switch (name)
        {
            case "cbSize":      numPut("UInt",value, this._ptr, 0)
            case "dwFlags":     numPut("UInt",value, this._ptr, 36)
            case "szDevice":
                aLength:=strLen(value)+1
                if (32<aLength)
                    value:=subStr(value,1,(aLength:=32)-1)
                strPut(value, this._ptr+40, aLength, "UTF-16")
        }
        this.defineProp(name, {value:value})
    }
    class _rcMonitor
    {
        _ptr:=0
        __get(name, params)    {
            switch (name)
            {
                case "left":        return numGet(this._ptr, 4, "Int")
                case "top":         return numGet(this._ptr, 8, "Int")
                case "right":       return numGet(this._ptr, 12, "Int")
                case "bottom":      return numGet(this._ptr, 16, "Int")
            }
        }
        __set(name, param, value)     {
            switch (name)
            {
                case "left":        numPut("Int",value, this._ptr, 4)
                case "top":         numPut("Int",value, this._ptr, 8,)
                case "right":       numPut("Int",value, this._ptr, 12)
                case "bottom":      numPut("Int",value, this._ptr, 16)
            }
            this.defineProp(name, {value:value})
        }
    }
    class _rcWork
    {
        _ptr:=0
        __get(name, params)    {
            switch (name)
            {
                case "left":        return numGet(this._ptr, 20, "Int")
                case "top":         return numGet(this._ptr, 24, "Int")
                case "right":       return numGet(this._ptr, 28, "Int")
                case "bottom":      return numGet(this._ptr, 32, "Int")
            }
        }
        __set(name, param, value)     {
            switch (name)
            {
                case "left":        numPut("Int",value, this._ptr, 20)
                case "top":         numPut("Int",value, this._ptr, 24)
                case "right":       numPut("Int",value, this._ptr, 28)
                case "bottom":      numPut("Int",value, this._ptr, 32)
            }
            this.defineProp(name, {value:value})
        }
    }
}