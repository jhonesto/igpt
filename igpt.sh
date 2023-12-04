#!/usr/bin/env bash
#
# Copyright (c) 2023 jhonesto
# Licensed under the MIT License (2023). See LICENSE for details or
# See <https://opensource.org/licenses/MIT> for details.
#

# DEFAULT VALUES
TOKEN=${TOKEN:-""}
MODEL=${MODEL:-"text-davinci-003"}
MAX_TOKENS=${MAX_TOKENS:-"500"}
TEMPERATURE=${TEMPERATURE:-"1.0"}

#COLORS 
RED="\033[31m"
YELLOW="\033[33m"
GREEN="\033[36m"
COLOR_OFF="\033[0m"

INPUT_COLOR=${INPUT_COLOR:-$GREEN}
OUTPUT_COLOR=${OUTPUT_COLOR:-$YELLOW}
INFO_COLOR=${INFO_COLOR:-$YELLOW}
ERROR_COLOR=${ERROR_COLOR:-$RED}
FORECOLOR=${FORECOLOR:-$COLOR_OFF}

#MESSAGES
OPT_INTERACT="Interact to ChatGPT"
OPT_INSERT_TOKEN="Insert Token"
OPT_CHANGE_MODEL="Change Model"
OPT_CHANGE_TEMPERATURE="Change Temperature"
OPT_CHANGE_MAX_TOKENS="Change Max Tokens"
OPT_QUIT="Quit"

MAIN_MENU_QUESTION="What would you like to do?"
MODEL_MENU_QUESTION="Which model do you prefer to use?"
ENTER_YOUR_API_TOKEN="Please enter your api token: "
YOUR_API_TOKEN_IS="Your api token is "

YOUR_MODEL_IS="Your new model is"
INSERT_TEMPERATURE="Please enter a temperature: "
YOUR_TEMPERATURE_IS="Your new temperature is:"
TEMPERATURE_MUST_BE_BETWEEN_X_AND_Y="Temperature must be between 0 and 2."
INSERT_MAX_TOKENS="Please enter your max tokens:"
YOUR_MAXIMUM_TOKENS="Your max. tokens:"
MAX_TOKENS_INVALID="Max token must be an integer!"
MAX_TOKENS_ZERO="Max token must be greater than zero!"
MAXIMUM_TOKENS_FOR_THIS_MODEL="Max tokens for"
MAXIMUM_TOKENS_FOR_THIS_MODEL_INVALID="Invalid number. Max tokens for"

YOUR_TOKEN_IS_EMPTY_OR_NULL="Your Token is empty or null."
ROLLING_BACK="Rolling back"
YOUR_MAX_TOKENS_IS_EMPTY_OR_NULL="Your Max Tokens is empty or null."
YOUR_TEMPERATURE_IS_EMPTY_OR_NULL="Your Temperature is empty or null."
EXITING_APPLICATION="Exiting the application."
INVALID_OPTION="Invalid option. Please try again."
MODEL_HEADER="Model"
MAX_TOKENS_HEADER="Max Tokens"

MENU_INFO="[type exit to quit, ? to menu]"
INSERT_YOUR_PROMPT="Insert your prompt:"

COMMAND_EXIT="exit"
COMMAND_MENU="?"

LABEL_ERROR="ERROR"
ERROR_000="Verify your Internet connection."

declare -i TRUE=0
declare -i FALSE=1
declare -i EXIT_SUCESS=0
declare -i EXIT_ERROR=1
declare -i ZERO=0
EMPTY=""

OPT1=$OPT_INTERACT
OPT2=$OPT_INSERT_TOKEN
OPT3=$OPT_CHANGE_MODEL
OPT4=$OPT_CHANGE_TEMPERATURE
OPT5=$OPT_CHANGE_MAX_TOKENS
OPT6=$OPT_QUIT

options=("$OPT1" "$OPT2" "$OPT3" "$OPT4" "$OPT5" "$OPT6" )

PS3="
$MAIN_MENU_QUESTION [1-${#options[@]}] "


MOD1="babbage-002"
MOD2="davinci-002"
MOD3="gpt-3.5-turbo-instruct"
MOD4="text-davinci-003"


models=( "$MOD1" "$MOD2" "$MOD3" "$MOD4")
declare -A arr_models=(
	["$MOD1"]=16384
	["$MOD2"]=16384
	["$MOD3"]=4096
	["$MOD4"]=4096
 )

#FUNCTIONS

print_input () {
	printf  "$INPUT_COLOR\n$1$FORECOLOR"
}

print_output () {
	echo -e "$OUTPUT_COLOR\n$1$FORECOLOR"
}

print_error () {
    echo -e "$ERROR_COLOR\n$1\n$FORECOLOR"
}

print_info () {
	printf  "$INFO_COLOR\n$1\n$FORECOLOR"
}

print_model () {
	printf "$INFO_COLOR%-25s  %s\n$FORECOLOR" "$1" "$2"
}

is_empty_or_null () {
	if [  -z "$1" ] || [ -z "${1// }" ]; then
		return $TRUE
	fi
	
	return $FALSE
}

is_not_empty_or_null () {
	if ! is_empty_or_null $1; then
		return $TRUE
	fi
	return $FALSE
}

is_valid_number () {
	if [[ $1 =~ ^[0-9]+$ ]]; then
		 return $TRUE
	fi
	return $FALSE
}

exit_app (){
	print_info "$EXITING_APPLICATION\n"
	exit $1
}

insert_token () {

	local OLD_TOKEN=${TOKEN:-$EMPTY}
	
	print_input "$ENTER_YOUR_API_TOKEN" 
	read  TOKEN
	
	if is_not_empty_or_null $TOKEN; then
		print_info "$YOUR_API_TOKEN_IS $TOKEN"
	elif is_empty_or_null $TOKEN && is_not_empty_or_null $OLD_TOKEN; then
		print_info "$YOUR_TOKEN_IS_EMPTY_OR_NULL"
		print_info "$ROLLING_BACK to $OLD_TOKEN"
		TOKEN=$OLD_TOKEN
	fi
	
}

change_model () {

	MODEL="$1"

	print_info "$YOUR_MODEL_IS $MODEL"

	if [[ ${arr_models[$MODEL]} -lt $MAX_TOKENS ]]; then
		MAX_TOKENS=${arr_models[$key]}
		print_info "$YOUR_MAXIMUM_TOKENS $MAX_TOKENS"	

	fi
	
}

change_temperature () {

	local NEW_TEMP

	print_input "$INSERT_TEMPERATURE"
	
	read NEW_TEMP

	if [[ $NEW_TEMP =~ ^([0-2]|[0-1]\.[0-9])$ ]]; then
		TEMPERATURE=$( printf "%.1f" $NEW_TEMP)
		print_info "$YOUR_TEMPERATURE_IS $TEMPERATURE"
		
	else
		print_info "$TEMPERATURE_MUST_BE_BETWEEN_X_AND_Y"
		
	fi
}

insert_max_tokens () {

	print_info "$MAXIMUM_TOKENS_FOR_THIS_MODEL $MODEL: ${arr_models[$MODEL]}"
	print_info "$YOUR_MAXIMUM_TOKENS $MAX_TOKENS"

    local NEW_MAX_TOKENS

    print_input "$INSERT_MAX_TOKENS "

	read NEW_MAX_TOKENS

	if is_valid_number $NEW_MAX_TOKENS; then
		if [[ $(echo "$NEW_MAX_TOKENS" | sed s/^0*// ) -gt $ZERO ]]; then
			if [[ ${arr_models[$MODEL]} -ge $NEW_MAX_TOKENS ]]; then
				MAX_TOKENS=$(echo "$NEW_MAX_TOKENS" | sed s/^0*// )
				print_info "$YOUR_MAXIMUM_TOKENS $MAX_TOKENS"
			else
				print_info "$MAXIMUM_TOKENS_FOR_THIS_MODEL_INVALID $MODEL: ${arr_models[$MODEL]}"
			fi
		else
			print_info "$MAX_TOKENS_ZERO"
		fi
	else
		print_info "$MAX_TOKENS_INVALID"
	fi
	
}

check_api_token () {
	while is_empty_or_null $TOKEN ; do
		print_info "$YOUR_TOKEN_IS_EMPTY_OR_NULL"
		insert_token
    done	
}

check_max_tokens () {
	while is_empty_or_null $MAX_TOKENS; do
		print_info "$YOUR_MAX_TOKENS_IS_EMPTY_OR_NULL"
		insert_max_tokens
	done
}

check_temperature () {
	while is_empty_or_null $TEMPERATURE; do
		print_info "$YOUR_TEMPERATURE_IS_EMPTY_OR_NULL"
		change_temperature
	done
}

check_parameters () {
	check_api_token
	check_max_tokens
	check_temperature
}

show_models_menu () {

PS3="
$MODEL_MENU_QUESTION [1-${#arr_models[@]}] "

select opt in "${models[@]}"
do
	case $opt in
    "$MOD1")
    	change_model "$MOD1"
    	break
    	;;
    "$MOD2")
    	change_model "$MOD2"
    	break
    	;;
    "$MOD3")
    	change_model "$MOD3"
    	break
    	;;
    "$MOD4")
    	change_model "$MOD4"
    	break
    	;;
    *)
    	print_info "$INVALID_OPTION"
    	;;
    esac
done

PS3="
$MAIN_MENU_QUESTION [1-${#options[@]}] "
	
}

show_models () {

print_model "$MODEL_HEADER" "$MAX_TOKENS_HEADER"

for key in "${!arr_models[@]}"; do
	print_model "$key" "${arr_models[$key]}"
done

print_info

show_models_menu

}

show_menu () {

select opt in "${options[@]}"
do
	case $opt in
	    "$OPT1")
	    	break
	    	;;
	    "$OPT2")
	    	insert_token
	    	;;
	    "$OPT3")
	    	show_models
	    	;;
	    "$OPT4")
	    	change_temperature
	    	;;
	    "$OPT5")
	    	insert_max_tokens
	    	;;
	    "$OPT6")
	    	exit_app  $EXIT_SUCESS
	    	;;
	    *)
	    	print_info "$INVALID_OPTION"
	    	;;
    esac
done

}


show_figlet (){
echo "                                
+-+-+-+-+-+-+-+-+-+-+-+
  _   __    ___  _____ 
 | | / /\`_ | |_)  | |  
 |_| \_\_/ |_|    |_|  

+-+-+ +-+-+-+ +-+-+-+-+
|b y| |j h o n e s t o|
+-+-+ +-+-+-+ +-+-+-+-+
"
}

# STARTING THE APPLICATION

show_figlet

check_parameters

print_info "$MENU_INFO"

while true
do
	print_input "$INSERT_YOUR_PROMPT\n\n"
	
	read -re message
	
	if [ "$message" == "$COMMAND_EXIT" ]; then
		
		exit_app $EXIT_SUCESS
		
	elif [ "$message" == "$COMMAND_MENU" ]; then
		print_info
		show_menu
		
	elif is_not_empty_or_null $message; then
	
		check_parameters
		
		prompt=$(echo "$message" | sed 's/\"/\\u0022/g; s/\\/\\\\/g')
		
		OUTPUT=$(curl -sw "%{http_code}" https://api.openai.com/v1/completions \
			-H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" \
			-d "{\"model\": \"$MODEL\", \"prompt\": \"${prompt}\", \"temperature\": $TEMPERATURE, \"max_tokens\": $MAX_TOKENS}" \
		)
		
		HTTP_STATUS=${OUTPUT: -3}
		
		OUTPUT=${OUTPUT::-3}

		TEXT=""
		ERROR=""
		
		if [ "$HTTP_STATUS" = "200" ]; then
		
			TEXT=$( echo $OUTPUT | python -c "import sys, json; print(json.load(sys.stdin)['choices'][0]['text'].strip())" 2>/dev/null)
			print_output "$TEXT"
			
		elif [ "$HTTP_STATUS" = "000" ]; then
		
			OUTPUT="$ERROR_000"
			print_error "$LABEL_ERROR: $HTTP_STATUS - $OUTPUT"
			
		else
		
			ERROR=$( echo $OUTPUT | python -c "import sys, json; print(json.load(sys.stdin)['error']['message'])" 2>/dev/null )

			if is_not_empty_or_null $ERROR; then
				print_info "$ERROR"
				
			else
				print_error "$LABEL_ERROR: $HTTP_STATUS - $OUTPUT"
				exit_app $EXIT_ERROR
			fi

		fi

		
	else
		print_info "\n$MENU_INFO"
	fi
	
done

