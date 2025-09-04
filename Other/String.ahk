; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=53

No functions rely on eachother. You may simply copy/paste the ones you want or need.
.-==================================================================-.
|Function                                                            |
|====================================================================|
| st_count(string [, searchFor])                                     |
| st_insert(insert, into [, pos])                                    |
| st_delete(string [, start, length])                                |
| st_overwrite(overwrite, into [, pos])                              |
| st_format(string, param1, param2, param3, ...)                     |
| st_word(string [, wordNu, Delim, temp])                            |
| st_subString(string, searchFor [, direction, instance, searchFor2])|
| st_jumble(Text[, Weight, Delim , Omit])                            |
|                                                                    |
| st_lineWrap(string [, column, indent])                             |
| st_wordWrap(string [, column, indent])                             |
| st_readLine(string, line [, delim, exclude])                       |
| st_deleteLine(string, line [, delim, exclude])                     |
| st_insertLine(insert, into, line [, delim, exclude])               |
|                                                                    |
| st_flip(string)                                                    |
| st_setCase(string [, case])                                        |
| st_contains(mixed [, lookFor*])                                    |
| st_removeDuplicates(string [, delim])                              |
| st_pad(string [, left, right, LCount, RCount])                     |
|                                                                    |
| st_group(string, size, separator [, perLine, startFromFront])      |
| st_columnize(data [, delim, justify, pad, colsep])                 |
| st_center(text [, fill, symFIll, delim, exclude])                  |
| st_right(text [, fill, delim, exclude])                            |
|----------------------------------------------------------------    |
|array stuff:                                                        |
|   st_split(string [, delim, exclude])                              |
|   st_glue(array [, delim])                                         |
|   st_printArr(array [, depth])                                     |
|   st_countArr(array [, depth])                                     |
|   st_randomArr(array [, min, max, timeout])                        |
'-==================================================================-'
