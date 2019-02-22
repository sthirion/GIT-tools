#!/bin/bash

cd ".." && pwd

for git_project in *; do

    if [ -d "$git_project"/.git ]; then
        echo "FOLDER: $git_project:"
        (cd $git_project && git branch --list)
        echo
    fi
done