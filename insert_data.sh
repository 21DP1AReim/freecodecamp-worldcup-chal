#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR == 'year' ]] 
  then
    continue
  fi

  TEAM_SELECT_RESULT=$($PSQL "SELECT * from teams where name='$WINNER'")

  if [[ -z $TEAM_SELECT_RESULT ]]
  then
    TEAM_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) values('$WINNER')")
  fi

  WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$WINNER'")

  TEAM_SELECT_RESULT=$($PSQL "SELECT * from teams where name='$OPPONENT'")
  if [[ -z $TEAM_SELECT_RESULT ]]
  then
    TEAM_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
  fi

  OPPONENT_TEAM_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'")

  
  INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_TEAM_ID, $OPPONENT_TEAM_ID )")

done




