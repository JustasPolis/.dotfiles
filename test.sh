#!/usr/bin/env bash
#
branch=$(git branch --list --format='%(refname:short)' | grep -v 'all' | fzf +m)

if [ -n "$branch" ]; then
	git checkout "$branch"
fi
