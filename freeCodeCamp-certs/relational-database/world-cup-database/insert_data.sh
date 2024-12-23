#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Loop through the CSV file
while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
  # Skip the header row
  if [[ $YEAR == "year" ]]; then
    continue
  fi

  # Insert winner team into the team table if not already exists
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  if [[ -z $WINNER_ID ]]; then
    $PSQL "INSERT INTO teams (name) VALUES ('$WINNER');"
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  fi

  # Insert opponent team into the team table if not already exists
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  if [[ -z $OPPONENT_ID ]]; then
    $PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT');"
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  fi

  # Insert game data into the games table
  $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
         VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);"
done < games.csv

echo "Data inserted successfully!"