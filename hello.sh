#!/bin/bash -ex

# $1 is gh token
# $2 is ssh path

#Secure keys
chmod 600 $1
chmod 600 $2

countFile="count"
# Get count from file
runCount=`cat $countFile`
# debug
echo "Hello! You are running this $runCount. time!"
# Save updated count to file
runCount=$((runCount+1))
echo "$runCount" > "$countFile"

# Get gh(github) client
wget https://github.com/cli/cli/releases/download/v1.3.1/gh_1.3.1_linux_arm64.tar.gz
tar xf gh*
PATH="$PATH:$PWD/gh_1.3.1_linux_arm64/bin"

# Masquerade as Mateusz
git config --local user.name MateuszMalisz
git config --local user.email mamalisz@microsoft.com

# Make sure it exists
mkdir -p ~/.ssh/
touch ~/.ssh/config
# Add Mateusz's credentials
cat >> ~/.ssh/config <<EOF
Host github.com
	IdentityFile $2
EOF

git remote add origin-ssh git@github.com:MateuszMalisz/playground.git

# Create PR branch from first
branchName="trainBranch$runCount"
git checkout -b $branchName
git add count
git commit -m "Updating count to $runCount"
git push origin-ssh $branchName

# Create PR
gh config set prompt disabled
gh auth login --with-token < $1
gh pr create --title "[I LIKE TRAINS] ${runCount}. train! " --base master --head $branchName --reviewer MateuszMalisz --body "(sounds of trains...)"
