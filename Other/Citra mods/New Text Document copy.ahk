#NoEnv
EnvGet OneDrive, ONEDRIVE
root := OneDrive "\Backup\Optimal\Scripts\Other\Playnite\Citra mods\Mods 2"
subFolder := "3d Land"
attributes := FileExist(root "\" subFolder)
if (!attributes)
	MsgBox 0x10,, % "System cannot find " subFolder
else if (InStr(attributes, "D"))
	MsgBox 0x40,, Subfolder exist
else
	MsgBox 0x30,, A file with the subfolder name exist