#!/bin/bash

DB_CMD="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Exit with a message if no argument is provided
if [[ -z $1 ]]; then
    echo "Please provide an element as an argument."
    exit 1
fi

# Determine if the argument is numeric or alphabetic
if [[ $1 =~ ^[0-9]+$ ]]; then
    ELEMENT_ID=$($DB_CMD "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
else
    # Search by symbol
    ELEMENT_ID=$($DB_CMD "SELECT atomic_number FROM elements WHERE symbol = '$1';")
    # If not found by symbol, search by name
    if [[ -z $ELEMENT_ID ]]; then
        ELEMENT_ID=$($DB_CMD "SELECT atomic_number FROM elements WHERE name = '$1';")
    fi
fi

# Exit if the element was not found
if [[ -z $ELEMENT_ID ]]; then
    echo "I could not find that element in the database."
    exit 1
fi

# Retrieve element details
NAME=$($DB_CMD "SELECT name FROM elements WHERE atomic_number = $ELEMENT_ID;")
SYMBOL=$($DB_CMD "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_ID;")
TYPE_ID=$($DB_CMD "SELECT type_id FROM properties WHERE atomic_number = $ELEMENT_ID;")
TYPE=$($DB_CMD "SELECT type FROM types WHERE type_id = $TYPE_ID;")
MASS=$($DB_CMD "SELECT atomic_mass FROM properties WHERE atomic_number = $ELEMENT_ID;")
MELTING_POINT=$($DB_CMD "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT_ID;")
BOILING_POINT=$($DB_CMD "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT_ID;")

# Output element details
echo -e "The element with atomic number $ELEMENT_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT°C and a boiling point of $BOILING_POINT°C."
