PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# echo $1 > elementfile
# read ELEMENT < elementfile

ELEMENT=$(echo $1)

# request element
REQUESTELEMENT() {
  if [[ -z $ELEMENT ]]
  then
    echo "Please provide an element as an argument."
    exit
  fi
}

# if element does not exist print message
PRINTDESCRIPTION() {
 # echo $ELEMENT > element.txt
  if grep -q '[0-9]' <<<$ELEMENT
  then
    RUNTEST=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties INNER JOIN types USING (type_id) INNER JOIN elements USING (atomic_number) WHERE atomic_number = $ELEMENT::INTEGER OR symbol = '$ELEMENT' OR name = '$ELEMENT';") 
  else
    RUNTEST=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties INNER JOIN types USING (type_id) INNER JOIN elements USING (atomic_number) WHERE symbol = '$ELEMENT' OR name = '$ELEMENT';") 
  fi
  if [[ -z $RUNTEST ]]
  then
    echo "I could not find that element in the database."
    exit
  else
   echo -e $RUNTEST > elementfile
   cat elementfile | sed 's/| //g' > testfile
   read -r a b c d e f g h < $(echo testfile)
   echo "The element with atomic number $a is $c ($b). It's a $d, with a mass of $e amu. $c has a melting point of $f celsius and a boiling point of $g celsius."  
  fi
  rm elementfile
  rm testfile
}

# get and return element description
REQUESTELEMENT
PRINTDESCRIPTION
