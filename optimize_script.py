file_path = "Other/Citra_mods/Citra_Mod_Manager.ahk"

with open(file_path, "r") as f:
    lines = f.readlines()

new_lines = []
skip_next = False
for i in range(len(lines)):
    if skip_next:
        skip_next = False
        continue

    line = lines[i]

    # Check for the specific Loop line
    if "Loop, Files, %Checkdir%\*, DF" in line:
        # We found the loop line. We keep it, then insert the block.
        new_lines.append(line)
        # We need to construct the block.
        # Original indentation of the Loop line is 8 spaces.
        # So brace should be 8 spaces? Or standard is open brace on same line or next line at same indent?
        # AHK style varies. Let's use:
        # Loop...
        # {
        #   vCount++
        #   Break
        # }
        new_lines.append("        {\n")
        new_lines.append("          vCount++                          ;Increment vCount for each item\n")
        new_lines.append("          Break                             ;Optimization: Break after finding the first item\n")
        new_lines.append("        }\n")

        # The original code had the single statement on the next line.
        # We need to skip it if it is indeed the vCount++ line.
        if i + 1 < len(lines) and "vCount++" in lines[i+1]:
            skip_next = True
    elif 'MsgBox % "Dir has " vCount " item(s). Can\'t copy"' in line:
        new_lines.append('          MsgBox % "Dir is not empty. Can\'t copy"\n')
    else:
        new_lines.append(line)

with open(file_path, "w") as f:
    f.writelines(new_lines)
