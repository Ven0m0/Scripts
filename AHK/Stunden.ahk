#SingleInstance Force
#Persistent
#Warn
SetBatchLines -1

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode, 3
SetTitleMatchMode, Fast

*NumpadDot::
*NumpadDel::
Time = %A_WDay%:%A_Hour%:%A_Min%
; Montag
If Time between 2:07:30 and 2:09:00 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Deutsch
    Ran := 1
}
If Time between 2:09:15 and 2:10:45 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\W-Inf
    Ran := 1
}
If Time between 2:11:00 and 2:12:30 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Englisch
    Ran := 1
}
If Time between 2:13:00 and 2:14:30 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\BWL-RW
    Ran := 1
}
; Dienstag
If Time between 3:07:30 and 3:08:15 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\E-BWL
    Ran := 1
}
If Time between 3:08:15 and 3:09:00 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Englisch
    Ran := 1
}
If Time between 3:09:15 and 3:10:45 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\GL
    Ran := 1
}
If Time between 3:11:00 and 3:12:30 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\BWL-RW
    Ran := 1
}
; Mittwoch
If Time between 4:08:15 and 4:09:00 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\BWL-RW
    Ran := 1
}
If Time between 4:09:15 and 4:10:45 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\EN-KO
    Ran := 1
}
If Time between 4:11:00 and 4:12:30 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Mathe
    Ran := 1
}
If Time between 4:12:45 and 4:14:15 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Biologie
    Ran := 1
}
; Donnerstag
If Time between 5:07:30 and 5:09:00 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Spanisch
    Ran := 1
}
If Time between 5:11:00 and 5:11:45 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Mathe
    Ran := 1
}
If Time between 5:11:45 and 5:12:30 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Deutsch
    Ran := 1
}
; Freitag
If Time between 6:07:30 and 6:09:00 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Spanisch
    Ran := 1
}
If Time between 6:09:15 and 6:10:45 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\W-Inf
    Ran := 1
}
If Time between 6:11:00 and 6:12:30 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\VWL
    Ran := 1
}
If Time between 6:13:00 and 6:14:00 && !(Ran)
{
    Run, C:\Users\janni\OneDrive\Schule\Philosophie
    Ran := 1
}
