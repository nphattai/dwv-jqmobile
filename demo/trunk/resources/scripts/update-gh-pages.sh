#!/bin/bash
#Script to push build results on the repository gh-pages branch.

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  #we should be in /home/travis/build/ivmartel/dwv-jqmobile
  echo -e "Starting to update gh-pages\n"
  #clean up node_modules
  rm -Rf node_modules
  yarn install --prod
  #go to home and setup git
  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"
  #using token clone gh-pages branch
  git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/ivmartel/dwv-jqmobile.git gh-pages > /dev/null
  #go into directory and copy data we're interested in to that directory
  cd gh-pages
  #copy new build
  cp -Rf $HOME/build/ivmartel/dwv-jqmobile/* demo/trunk
  # remove gitignore
  rm -f demo/trunk/.gitignore
  #add, commit and push files
  git add -Af .
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
  git push -fq origin gh-pages > /dev/null
  echo -e "Done updating.\n"
fi