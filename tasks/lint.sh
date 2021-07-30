#!/bin/bash
set -uo pipefail
set +e

FAILURE=false

# echo "safety (failure is tolerated)"
# FILE=requirements/prod.txt
# if [ -f "$FILE" ]; then
#     # We're in the main repo
#     safety check -r requirements/prod.txt -r requirements/dev.txt
# else
#     # We're in the labs repo
#     safety check -r ../requirements/prod.txt -r ../requirements/dev.txt
# fi

echo "pylint"
pylint training || FAILURE=true

echo "pycodestyle"
pycodestyle training || FAILURE=true

echo "pydocstyle"
pydocstyle training || FAILURE=true

echo "mypy"
mypy training || FAILURE=true

echo "bandit"
bandit -ll -r training || FAILURE=true

# echo "shellcheck"
# find . -name "*.sh" -print0 | xargs -0 shellcheck || FAILURE=true

if [ "$FAILURE" = true ]; then
  echo "Linting failed"
  exit 1
fi
echo "Linting passed"
exit 0
