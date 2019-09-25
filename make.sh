#!/bin/bash
set -f
set -e
IFS=$'\n'

index="`cat index.txt`"
body="" 
for v in $index; 
do
    if [ "$v" != "" ];
    then
        body="$body <p><a href='./$v/index.html'>$v</a></p>"
    fi
done

# Rebuild the webpage by merging header body and footer
if [ -f "header.html" ]; then cat "header.html" > index.html ; else echo "" > index.html ; fi
echo "$body" >> index.html
if [ -f "footer.html" ]; then cat "footer.html" >> index.html ; fi

# Customize the javadoc by injecting css (eg apply a dark theme)
for v in $index; 
do
    # Skip the old javadoc
    if [ "$v" = "v3.0" ];then continue; fi

    if [ -f "inject.css" -a -f "$v/stylesheet.css" ];
    then
        # marking comment: This marks the start of the custom css
        s="/*** !!CUSTOM!! ***/"

        # Rebuild the stylesheet line by line but stop if
        # the marking comment is reached before the end
        # Defacto removes any custom css that was injected before
        stylesheet="`cat $v/stylesheet.css`"
        echo "" > "$v/stylesheet.css"
        for l in $stylesheet;
        do
            if [ "$l" = "$s" ];then  break;  fi
            echo "$l" >> "$v/stylesheet.css"
        done


        echo "Inject CSS"
        # Marking comment
        echo -e "\n$s\n" >> "$v/stylesheet.css"
        # Custom css
        cat "inject.css" >> "$v/stylesheet.css"       

    fi
done

