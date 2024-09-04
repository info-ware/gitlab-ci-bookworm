#!/usr/bin/env bash
PROJECT_DIR=.
NO_CHANGES_MESSAGE="Apparently nothing was changed. Probably just redeploy."
DATE_FILE="latest_released_commit_date.txt"
RELEASE_NOTES_FILE="release_notes.txt"
NOTE_FORMAT=format:"%an: %s"

get_latest_saved_date() {
  # echo "get_latest_saved_date"
  head -n1 $DATE_FILE
}

get_latest_commit_date() {
  # echo "get_latest_saved_date"
  git -C $PROJECT_DIR log --pretty=format:"%at" --date=raw -1
}

is_latest_date_saved() {
  if [ ! -f "$DATE_FILE" ]; then
    # echo "File not found!"
    return 0
  else
   #  echo "File exist"
    return 1
  fi
}

is_nothing_added() {
  # echo "is_nothing_added"
  date_saved=$(get_latest_saved_date)
  latest_date=$(get_latest_commit_date)
  # echo $date_saved
  # echo $latest_date
  if [ "$date_saved" = "$latest_date" ]; then
    return 1
  else
    return 0
  fi
}

is_latest_date_saved
date_saved=$?

if [ $date_saved == 1 ]; then

  # echo "date_saved == 1"

  is_nothing_added
  nothing_added=$?
  if [ $nothing_added == 0 ]; then
    # echo "nothing_added == 0"
	latest_released_commit_date_tmp=$(get_latest_saved_date)
    latest_released_commit_date=$(($latest_released_commit_date_tmp + 1))
    git -C "$PROJECT_DIR" log --pretty="$NOTE_FORMAT" --date=raw --since="$latest_released_commit_date" --max-count=10 > "$RELEASE_NOTES_FILE"
  else
    # echo "nothing_added != 0"
    echo "$NO_CHANGES_MESSAGE" > "$RELEASE_NOTES_FILE"
  fi

else
  # echo "date_saved != 1"
  git -C "$PROJECT_DIR" log --pretty="$NOTE_FORMAT" --date=local -10 > "$RELEASE_NOTES_FILE"
fi

git -C "$PROJECT_DIR" log --pretty=format:"%at" --date=raw -1 > "$DATE_FILE"

echo "Latest commit on: $(get_latest_commit_date)"
