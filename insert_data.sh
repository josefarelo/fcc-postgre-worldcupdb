#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  WINNERS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ $WINNER != "winner" ]]
    then
      if [[ -z $WINNERS ]]
        then
          INSERT_WINNERS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          if [[ $INSERT_WINNERS == "INSERT 0 1" ]]
            then
              echo Inserted into teams, $WINNER
          fi
      fi  
  fi 

  OPPONENTS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
    then
      if [[ -z $OPPONENTS ]]
        then
          INSERT_OPPONENTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          if [[ $INSERT_OPPONENTS == "INSERT 0 1" ]]
            then
              echo Inserted into teams, $OPPONENT
          fi
      fi
  fi 

  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -n $TEAM_ID_WINNER || -n $TEAM_ID_OPPONENT ]]
    then
      if [[ $YEAR != "year" ]]
        then
          INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")
          if [[ $INSERT_GAMES == "INSERT 0 1" ]]
            then
              echo Inserted into games, $YEAR  
          fi
      fi        
  fi

done
