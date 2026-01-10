#Requires AutoHotkey v1.1.35+
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
    static _ := MONITORINFOEX_VersionManager.init()
    init()    {
        global
        MONITORINFOEX_VERSION := "1.0.0"
    }
}
MONITORINFOEX(header)    {
    return A_IsUnicode
        ?MONITORINFOEXW(header)
        :MONITORINFOEXA(header)
}
MONITORINFOEXA(header)    {
    switch (header)
    {
        case "winuser.h":   return new MONITORINFOEXA_winuser()
    }
}
MONITORINFOEXW(header)    {
    switch (header)
    {
        case "winuser.h":   return new MONITORINFOEXW_winuser()
    }
}
class MONITORINFOEXA_winuser
{
    Ptr    {
        get  {
            return (this._ptr)
        }
        set  {
            this.rcWork._ptr:= this.rcMonitor._ptr:= this._ptr:= value
        }
    }
    setCbSize()    {
        numPut(72, this._ptr, 0,"UInt") ;  sizeof(MONITORINFOEX)
    }
    getObj(hMonitor:="")    {
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
        if (hMonitor!=="")
            obj.hMonitor:=hMonitor
        return obj
    }
    _ptr:=0
    __new()    {
        this.setCapacity("struct",72), dllCall("Ntdll.dll\RtlFillMemory", "Ptr",this._ptr:=this.getAddress("struct"), "UPtr",72, "Int",0)
        this.rcMonitor:=new MONITORINFOEXA_winuser._rcMonitor()
        this.rcMonitor._ptr:=this._ptr
        this.rcWork:=new MONITORINFOEXA_winuser._rcWork()
        this.rcWork._ptr:=this._ptr        
        return this
    }
    __get(aName)    {
        switch (aName)
        {
            case "cbSize":      return numGet(this._ptr, 0, "UInt")
            case "dwFlags":     return numGet(this._ptr, 36, "UInt")
            case "szDevice":    return strGet(this._ptr+40, 32, "CP0")
        }
    }
    __set(aName, aValue)    {
        switch (aName)
        {
            case "cbSize":      return format("{2}", numPut(aValue, this._ptr, 0, "UInt"), aValue)
            case "dwFlags":     return format("{2}", numPut(aValue, this._ptr, 36, "UInt"), aValue)
            case "szDevice":
                aLength:=strLen(aValue)+1
                if (32<aLength)
                    aValue:=subStr(aValue,1,(aLength:=32)-1)
                strPut(aValue, this._ptr+40, aLength, "CP0")
                return aValue
        }
    }
    class _rcMonitor
    {
        _ptr:=0
        __get(aName)    {
            switch (aName)
            {
                case "left":        return numGet(this._ptr, 4, "Int")
                case "top":         return numGet(this._ptr, 8, "Int")
                case "right":       return numGet(this._ptr, 12, "Int")
                case "bottom":      return numGet(this._ptr, 16, "Int")
            }
        }
        __set(aName, aValue)    {
            switch (aName)
            {
                case "left":        return format("{2}", numPut(aValue, this._ptr, 4, "Int"), aValue)
                case "top":         return format("{2}", numPut(aValue, this._ptr, 8, "Int"), aValue)
                case "right":       return format("{2}", numPut(aValue, this._ptr, 12, "Int"), aValue)
                case "bottom":      return format("{2}", numPut(aValue, this._ptr, 16, "Int"), aValue)
            }
        }
    }
    class _rcWork
    {
        _ptr:=0
        __get(aName)    {
            switch (aName)
            {
                case "left":        return numGet(this._ptr, 20, "Int")
                case "top":         return numGet(this._ptr, 24, "Int")
                case "right":       return numGet(this._ptr, 28, "Int")
                case "bottom":      return numGet(this._ptr, 32, "Int")
            }
        }
        __set(aName, aValue)    {
            switch (aName)
            {
                case "left":        return format("{2}", numPut(aValue, this._ptr, 20, "Int"), aValue)
                case "top":         return format("{2}", numPut(aValue, this._ptr, 24, "Int"), aValue)
                case "right":       return format("{2}", numPut(aValue, this._ptr, 28, "Int"), aValue)
                case "bottom":      return format("{2}", numPut(aValue, this._ptr, 32, "Int"), aValue)
            }
        }
    }
}
class MONITORINFOEXW_winuser
{
    Ptr    {
        get  {
            return (this._ptr)
        }
    }
    setCbSize()    {
        numPut(104, this._ptr, 0,"UInt") ;  sizeof(MONITORINFOEX)
    }
    getObj(hMonitor:="")    {
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
        if (hMonitor!=="")
            obj.hMonitor:=hMonitor
        return obj
    }
    _ptr:=0
    __new()    {
        this.setCapacity("struct",104), dllCall("Ntdll.dll\RtlFillMemory", "Ptr",this._ptr:=this.getAddress("struct"), "UPtr",104, "Int",0)
        this.rcMonitor:=new MONITORINFOEXW_winuser._rcMonitor()
        this.rcMonitor._ptr:=this._ptr
        this.rcWork:=new MONITORINFOEXW_winuser._rcWork()
        this.rcWork._ptr:=this._ptr        
        return this
    }
    __get(aName)    {
        switch (aName)
        {
            case "cbSize":      return numGet(this._ptr, 0, "UInt")
            case "dwFlags":     return numGet(this._ptr, 36, "UInt")
            case "szDevice":    return strGet(this._ptr+40, 32, "UTF-16")
        }
    }
    __set(aName, aValue)    {
        switch (aName)
        {
            case "cbSize":      return format("{2}", numPut(aValue, this._ptr, 0, "UInt"), aValue)
            case "dwFlags":     return format("{2}", numPut(aValue, this._ptr, 36, "UInt"), aValue)
            case "szDevice":
                aLength:=strLen(aValue)+1
                if (32<aLength)
                    aValue:=subStr(aValue,1,(aLength:=32)-1)
                strPut(aValue, this._ptr+40, aLength, "UTF-16")
                return aValue
        }
    }
    class _rcMonitor
    {
        _ptr:=0
        __get(aName)    {
            switch (aName)
            {
                case "left":        return numGet(this._ptr, 4, "Int")
                case "top":         return numGet(this._ptr, 8, "Int")
                case "right":       return numGet(this._ptr, 12, "Int")
                case "bottom":      return numGet(this._ptr, 16, "Int")
            }
        }
        __set(aName, aValue)    {
            switch (aName)
            {
                case "left":        return format("{2}", numPut(aValue, this._ptr, 4, "Int"), aValue)
                case "top":         return format("{2}", numPut(aValue, this._ptr, 8, "Int"), aValue)
                case "right":       return format("{2}", numPut(aValue, this._ptr, 12, "Int"), aValue)
                case "bottom":      return format("{2}", numPut(aValue, this._ptr, 16, "Int"), aValue)
            }
        }
    }
    class _rcWork
    {
        _ptr:=0
        __get(aName)    {
            switch (aName)
            {
                case "left":        return numGet(this._ptr, 20, "Int")
                case "top":         return numGet(this._ptr, 24, "Int")
                case "right":       return numGet(this._ptr, 28, "Int")
                case "bottom":      return numGet(this._ptr, 32, "Int")
            }
        }
        __set(aName, aValue)    {
            switch (aName)
            {
                case "left":        return format("{2}", numPut(aValue, this._ptr, 20, "Int"), aValue)
                case "top":         return format("{2}", numPut(aValue, this._ptr, 24, "Int"), aValue)
                case "right":       return format("{2}", numPut(aValue, this._ptr, 28, "Int"), aValue)
                case "bottom":      return format("{2}", numPut(aValue, this._ptr, 32, "Int"), aValue)
            }
        }
    }
}