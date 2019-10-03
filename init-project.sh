# Example usage e.g. in the ~/projects/diplomatiq directory:
# bash ./project-config/init-project.sh projectname "GitHub description"
# This will create a directory for the project in ~/project/diplomatiq and perform the necessary configuration there.

projectUserName="Soma Lucz"
projectUserEmail="soma.lucz@diplomatiq.org"

if [[ $# -ne 2 ]]; then
    echo "Usage: bash init-project.sh projectname \"GitHub description\""
    exit 1
fi

if ! [[ $1 =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Error: URL-safe project name required"
    exit 1
fi

directoryOfThisScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

projectName=$1
description=$2

mkdir $projectName
pushd $projectName

git init
printf "# $projectName\n\n$description\n\n---\n\nCopyright (c) 2018 Diplomatiq\n" > README.md

cp -r $directoryOfThisScript/.dependabot .
cp -r $directoryOfThisScript/.github .
cp $directoryOfThisScript/.commitlintrc.json .
cp $directoryOfThisScript/.editorconfig .
cp $directoryOfThisScript/CODE_OF_CONDUCT.md .
cp $directoryOfThisScript/CONTRIBUTING.md .
cp $directoryOfThisScript/LICENSE .
cp $directoryOfThisScript/SECURITY.md .

sed -i "" -e "s/PROJECTNAME/$projectName/g" ./.github/PULL_REQUEST_TEMPLATE.md
sed -i "" -e "s/PROJECTNAME/$projectName/g" ./CONTRIBUTING.md

git config --local user.name "$projectUserName"
git config --local user.email $projectUserEmail

git remote add origin git@github.com:Diplomatiq/$projectName.git
git add .
git commit -m "chore: Initial commit"

popd
