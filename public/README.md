Deploy on Day One Project

Goal: To add yourself to the student section of the FlatironSchool.com and create your profile page.

Steps:
- Clone the students website to your code directory.
- git@github.com:flatiron-school/002.students.flatironschool.com.git
- git clone git@github.com:flatiron-school/002.students.flatironschool.com.git
- Create a feature branch for your profile add-profile-aviflombaum, feature-studentgithub
- git co -b add-profile-aviflombaum
- Create your profile page within the students directory aviflombaum.htm
  - touch students/aviflombaum.html
- Add it, commit, push
    - git add .
    - git commit -am "Add profile for Avi Flombaum"
    - git push
Create a pull request to merge your feature branch, add-profile-aviflombaum to the flatiron-school origin repository
https://github.com/flatiron-school/002.students.flatironschool.com/pull/new/add-profile-aviflombaum

- Squashing commits?

Ping Avi or Tag him in a comment (@aviflombaum) to let him know that your pull request needs to be reviewed
- Admin Merges Pull Request
- Deploy master of main repository
- Our Git Flow
- Anything in master branch is deployable.
- Create feature branches off master.
- Commit locally and regularly push your work to the same named branch on the server.
- When you need help or you think your branch is ready to merge, open a pull request on github.com
- After someone reviews and +1, you can merge that pull request into the master.
- Once a pull request is merged to master, deploy.

Never, ever, do anything in a master branch. It must remain stable.
- Do not merge the upstream develop with your feature branch, rebase your branch on top of the upstream/master to synch your feature branch with the latest master.
- Issue branches should be prefixed with the issue # and description.

We used these steps:

♕ git add .

♕ git commit -m 'messed with profile'

♕ git push upstream add-profile-adamjonas

♕ git fetch upstream

♕ git co master

♕ git pull upstream master

♕ git co add-profile-adamjonas

♕ git rebase master


http://scottchacon.com/2011/08/31/github-flow.html

https://github.com/diaspora/diaspora/wiki/Git-Workflow

http://mettadore.com/analysis/a-simple-git-rebase-workflow-explained/

http://zachholman.com/talk/how-github-uses-github-to-build-github

https://openshift.redhat.com/community/wiki/github-workflow-for-submitting-pull-requests
