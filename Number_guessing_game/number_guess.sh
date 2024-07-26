#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USERNAME_NAME=$($PSQL "SELECT username FROM player WHERE username = '$USERNAME'")

if [[ -z $USERNAME_NAME ]] 
then
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  INSER_USERNAME=$($PSQL "INSERT INTO player(username) VALUES('$USERNAME')")
else
  games_played=$($PSQL "SELECT COUNT(games) FROM games LEFT JOIN player USING(user_id) WHERE username='$USERNAME'")
  best_game=$($PSQL "SELECT MIN(guesses) FROM games LEFT JOIN player USING(user_id) WHERE username='$USERNAME'")
  echo -e "Welcome back, $USERNAME! You have played $games_played games, and your best game took $best_game guesses."

fi

echo -e "Guess the secret number between 1 and 1000:"
read GUESS
random_number=$((1 + RANDOM % 1000))

guesses=0

until [[ $GUESS == $random_number ]]
do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    read GUESS
    ((guesses++))
  else
    if [[ $GUESS > $random_number ]]
    then 
      echo "It's lower than that, guess again:"
      read GUESS
      ((guesses++))
    else
      echo "It's higher than that, guess again:"
      read GUESS
      ((guesses++))
    fi
  fi
done

((guesses++))
GET_USER_ID=$($PSQL "SELECT user_id FROM player WHERE username='$USERNAME'")
INSERT_GAME=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($GET_USER_ID, $guesses)")
echo -e "You guessed it in $guesses tries. The secret number was $random_number. Nice job!"




