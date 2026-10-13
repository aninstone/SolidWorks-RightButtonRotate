#Requires AutoHotkey v2.0
#SingleInstance Force

; ===== 日志（用于诊断热键是否触发） =====
logfile := "D:\workbuddy\2026-08-02-13-11-01\powerbank_sw\ahk_log.txt"
Log(msg) {
    global logfile
    FileAppend(A_Hour ":" A_Min ":" A_Sec "." A_MSec "  " msg "`n", logfile)
}

Log("===== 脚本启动 =====")
Log("SLDWORKS 进程存在: " . ProcessExist("SLDWORKS.exe"))

; ===== 仅对 SolidWorks 主窗口生效 =====
#HotIf WinActive("ahk_exe SLDWORKS.exe")

; ---- 右键：拖拽=旋转视图（映射中键），轻点=上下文菜单 ----
RButton::
{
    Log("RButton 按下")
    MouseGetPos(&x0, &y0)
    dragged := false
    while GetKeyState("RButton", "P")
    {
        MouseGetPos(&x1, &y1)
        if (Abs(x1 - x0) > 4 || Abs(y1 - y0) > 4)
        {
            dragged := true
            break
        }
        Sleep(10)
    }
    Log("RButton dragged=" . dragged)
    if (dragged)
    {
        SendInput("{MButton down}")
        while GetKeyState("RButton", "P")
            Sleep(10)
        SendInput("{MButton up}")
        Log("RButton -> 已发送中键旋转")
    }
    else
    {
        SendInput("{RButton}")
        Log("RButton -> 补发右键菜单")
    }
}

; ---- 中键：拖拽=平移视图（映射 Ctrl+中键），轻点=默认中键 ----
MButton::
{
    Log("MButton 按下")
    MouseGetPos(&x0, &y0)
    dragged := false
    while GetKeyState("MButton", "P")
    {
        MouseGetPos(&x1, &y1)
        if (Abs(x1 - x0) > 4 || Abs(y1 - y0) > 4)
        {
            dragged := true
            break
        }
        Sleep(10)
    }
    Log("MButton dragged=" . dragged)
    if (dragged)
    {
        SendInput("{Ctrl down}{MButton down}")
        while GetKeyState("MButton", "P")
            Sleep(10)
        SendInput("{MButton up}{Ctrl up}")
        Log("MButton -> 已发送 Ctrl+中键平移")
    }
    else
    {
        SendInput("{MButton}")
        Log("MButton -> 补发中键单击")
    }
}

; ---- 应急暂停/恢复 ----
^#r::
{
    Suspend(-1)
    Log("Suspend 切换")
}

#HotIf
