#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
EXE_OUT=$($PSQL "truncate table games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do 
echo -e "\n $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS "
if [[ $WINNER != winner ]] 
then 
  TEAM1=$($PSQL "select name from teams where name='$WINNER';")
  TEAM2=$($PSQL "select name from teams where name='$OPPONENT';")

  if [[ -z $TEAM1 ]] 
  then 
    INSERT_VAR1=$($PSQL "insert into teams (name)  values ('$WINNER');")
    echo $INSERT_VAR1
  fi
  if [[ -z $TEAM2 ]]
  then 
    INSERT_VAR2=$($PSQL "insert into teams (name) values ('$OPPONENT');")
    echo $INSERT_VAR2
  fi
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")

  echo $OPPONENT_ID
  INSERT_GAMES=$($PSQL "insert into games (year,round, winner_id, opponent_id, winner_goals, opponent_goals ) values ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
fi
done
