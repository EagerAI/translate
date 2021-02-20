#!/bin/sh -l


Rscript main.R --issue_comment_body "$1" --issue_number "$2" --issue_user "$3"
python3 hello.py


