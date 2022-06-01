#!/bin/bash

# while loop to ensure that the user can do another search after finishing a search
while true; do

    echo -e "Enter your choice:\n1) New search\n2) Exit the program" # prompts the user to select an option
    read search_or_exit # reads the user's choice from the terminal and stores the value in the variable 'search_or_exit'

    # while loop to conduct user input validation
    while ! ([[ $search_or_exit =~ ^[0-9]+$ ]] && ([[ $search_or_exit -eq 1 ]] || [[ $search_or_exit -eq 2 ]])); do # tests whether the input is an integer and is either equal to 1 or 2
        echo "You have not entered a valid input. Please try again." # tells the user the value he has entered and the value is invalid. Prompts the user to try again
        echo -e "Enter your choice:\n1) New search\n2) Exit the program " # prompts the user to select an option
        read search_or_exit # reads the user's choice from the terminal and stores the value in the variable 'search_or_exit'
    done 
    
    if [[ $search_or_exit -eq 2 ]]; then # tests whether the user's choice is 2
        break # exits the while loop
    fi 

    clear # clear the terminal for the rest of the program

    read -p "Enter the pattern you want to search for: " pat # reads the required pattern from the terminal and stores the value in the variable 'pat'
    read -p "Enter 1 for a whole word match or 2 for any match on the line: " match_type # reads user's choice from the terminal and stores the value in the variable 'match_type'
    
    # while loop to conduct user input validation
    while ! ([[ $match_type =~ ^[0-9]+$ ]] && ([[ $match_type -eq 1 ]] || [[ $match_type -eq 2 ]])); do # tests whether the input is an integer and is either equal to 1 or 2
        echo "You have not entered a valid input. Please try again." # tells the user the value he has entered and the value is invalid. Prompts the user to try again
        read -p "Enter 1 for a whole word match or 2 for any match on the line: " match_type # prompts the user to select an option
    done

    read -p "Do you want an inverted match? (Y/N): " invt # reads user's choice from the terminal and stores the value in the variable 'invt'
    
    # while loop to conduct user input validation
    while ! ([[ $invt =~ [a-zA-Z]{1} ]] && ([[ $invt == Y ]] || [[ $invt == y ]] || [[ $invt == N ]] || [[ $invt == n ]])); do # tests whether the input is a single alphabet and is either equal to 'y' or 'n' or 'Y' or 'N'
        echo "You have not entered a valid input. Please try again." # tells the user the value he has entered and the value is invalid. Prompts the user to try again
        read -p "Do you want an inverted match? (Y/N): " invt # prompts the user to select an option
    done

    count=0 # variable to count the number of matches to the pattern. Variable is initialised to 0.

    if [[ $match_type -eq 1 ]] && ([[ $invt == N ]] || [[ $invt == n ]]); then # tests for user's choice of a whole word and a non-inverted match
        
        count=$(grep -iwc $pat access_log.txt) # counts the number of lines that matches the value stored in the variable 'pat', with the following properties: case insensitive and a whole word match
        
        if [[ $count -eq 0 ]]; then # tests whether the number of lines that satisfies the above properties to be zero
            echo "No matches found." # prints to terminal that no matches are found
        else
            echo "$count matches found." # prints to terminal the number of matches found
            grep -iwn $pat access_log.txt # prints to terminal the lines that satisfies the above properties together with their line numbers in the source file
        fi
    
    elif [[ $match_type -eq 1 ]] && ([[ $invt == Y ]] || [[ $invt == y ]]); then # tests for user's choice of a whole word and an inverted match
        
        count=$(grep -iwvc $pat access_log.txt) # counts the number of lines that does not match the value stored in the variable 'pat', with the following properties: case insensitive and a whole word match
        
        if [[ $count -eq 0 ]]; then # tests whether the number of lines that satisfies the above properties to be zero
            echo "No matches found." # prints to terminal that no matches are found
        else
            echo "$count matches found." # prints to terminal the number of matches found
            grep -iwvn $pat access_log.txt # prints to terminal the lines that satisfies the above properties together with their line numbers in the source file
        fi
    
    elif [[ $match_type -eq 2 ]] && ([[ $invt == N ]] || [[ $invt == n ]]); then # tests for user's choice of any match on the line and a non-inverted match
        
        count=$(grep -ic $pat access_log.txt) # counts the number of lines that matches the value stored in the variable 'pat', with the following properties: case insensitive and any match on the line
        
        if [[ $count -eq 0 ]]; then # tests whether the number of lines that satisfies the above properties to be zero
            echo "No matches found." # prints to terminal that no matches are found
        else
            echo "$count matches found." # prints to terminal the number of matches found
            grep -in $pat access_log.txt # prints to terminal the lines that satisfies the above properties together with their line numbers in the source file
        fi

    else # last combination of user's choice of any match on the line and an inverted match comes here
        
        count=$(grep -ivc $pat access_log.txt) # counts the number of lines that does not match the value stored in the variable 'pat', with the following properties: case insensitive and any match on the line
        
        if [[ $count -eq 0 ]]; then # tests whether the number of lines that satisfies the above properties to be zero
            echo "No matches found." # prints to terminal that no matches are found
        else
            echo "$count matches found." # prints to terminal the number of matches found
            grep -ivn $pat access_log.txt # prints to terminal the lines that satisfies the above properties together with their line numbers in the source file
        fi
    fi
done

echo "You have exited the program." # Informing the user that he has exited the program.
exit 0
