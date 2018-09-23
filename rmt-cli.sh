#!/bin/bash

# Completion script for SUSE RMT: rmt-cli
#
# Notes:
# COMP_WORDS are all words in the current cli feed
# COMP_CWORD is the index of the most recent word in COMP_WORDS
#

# main completion routine
_rmt-cli()
{
	COMPREPLY=()

	local current_word subcommand options

	current_word=${COMP_WORDS[COMP_CWORD]}
	subcommand=${COMP_WORDS[1]}

	options="sync products repos mirror import export version help"

	# no subcommands yet:
	if [[ ${COMP_CWORD} == 1 ]] ; then
		COMPREPLY=( $(compgen -W "${options}" -- ${current_word}) )
		return 0
	fi

	# subcommands:
	if [[ ${subcommand} =~ ^(sync|mirror|version)$ ]] ; then
		# no further completion
		return 0
	fi

	if [[ ${subcommand} == help ]] ; then
		# show options without 'help'
		if [[ ${COMP_CWORD} < 3 ]] ; then
			COMPREPLY=( $(compgen -W "${options/help/}" -- ${current_word}) )
		fi
		return 0
	fi

	if [[ ${subcommand} =~ ^(products|repos|import|export)$ ]] ; then
		_rmt-cli_$subcommand
		return 0
	fi

	# Can't be reached
	return 0
}

# subcommand completion routines
_rmt-cli_products()
{
	local current_word options flags

	current_word=${COMP_WORDS[COMP_CWORD]}

	options="list enable disable"
	flags="--all --csv"

	if [[ ${COMP_CWORD} == 2 ]] ; then
		COMPREPLY=( $(compgen -W "${options}" -- ${current_word}) )
	elif [[ ${current_word} == -* && ${COMP_WORDS[*]} =~ list ]] ; then
		COMPREPLY=( $(compgen -W "${flags}" -- ${current_word}) )
	fi
}

_rmt-cli_repos()
{
	local current_word options custom_options flags

	current_word=${COMP_WORDS[COMP_CWORD]}

	options="list enable disable custom"
	custom_options="list add enable disable remove products attach detach"
	flags="--all --csv"

	if [[ ${COMP_CWORD} == 2 ]] ; then
		COMPREPLY=( $(compgen -W "${options}" -- ${current_word}) )
	elif [[ ${current_word} == -* && ${COMP_WORDS[*]} =~ list ]] ; then
		if [[ ${COMP_WORDS[*]} =~ custom ]] ; then
		   flags="--csv"
		fi
		COMPREPLY=( $(compgen -W "${flags}" -- ${current_word}) )
	elif [[ ${COMP_WORDS[COMP_CWORD-1]} == custom && ${COMP_CWORD} == 3 ]] ; then
		COMPREPLY=( $(compgen -W "${custom_options}" -- ${current_word}) )
	fi
}

_rmt-cli_import()
{
	local current_word options

	current_word=${COMP_WORDS[COMP_CWORD]}
	options="data repos"

	if [[ ${COMP_CWORD} == 2 ]] ; then
		COMPREPLY=( $(compgen -W "${options}" -- ${current_word}) )
	elif [[ ${COMP_CWORD} == 3 ]] ; then
		COMPREPLY=( $(compgen -f $current_word) )
	fi
}

_rmt-cli_export()
{
	local current_word options

	current_word=${COMP_WORDS[COMP_CWORD]}
	options="data settings repos"

	if [[ ${COMP_CWORD} == 2 ]] ; then
		COMPREPLY=( $(compgen -W "${options}" -- ${current_word}) )
	elif [[ ${COMP_CWORD} == 3 ]] ; then
		COMPREPLY=( $(compgen -f ${current_word}) )
	fi
}

complete -F _rmt-cli rmt-cli
