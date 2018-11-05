# Build
npm install
npm run build

# Delete all except build folder
find -maxdepth 1 ! -name dist ! -name . -exec rm -rf {} \;

# Extract the contents of dist and remove the folder
mv dist/* .
rm -rfv ./dist

# Push to gh-pages branch
git init
git checkout -b gh-pages
git add .
git commit -m "Deploy to Github Pages"
git push -u --force "https://${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git" gh-pages
