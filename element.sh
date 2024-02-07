#!/bin/bash

# Grants you access to the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN_FUNCTION () {

  # Checking for input
  if [[ -z $1 ]]
  then
    # Outputs if not input is supplied
    echo "Please provide an element as an argument."
  
  # Continue if input found
  else
    # New variable that is assigned the input
    INPUT=$1
    # Check for the pattern matches of the input
    if [[ $INPUT =~ ^[A-Z][A-Za-z]?$ ]]
    then
      # Matches the symbol pattern
      INPUT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT'")

    elif [[ $INPUT =~ ^[A-Za-z][A-Za-z]+ ]]
    then
      # Matches the name pattern
      INPUT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT'")
      
    fi
    # Confirms if input still has value going forward
    if [[ -n $INPUT && $INPUT =~ ^[0-9]+$ ]]
    then
      # Getting the details of the element from DB
      DB_REQUEST_RESULT=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $INPUT")
      
      # Piping to loop to facilitate output
      echo "$DB_REQUEST_RESULT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
      do
        # The ultimate output
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    else
      # If the input does not have value
      echo "I could not find that element in the database."
    fi
  fi
}

# Function call
MAIN_FUNCTION $1
