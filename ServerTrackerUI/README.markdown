
# ServerTracker

ServerTracker is an application to help managing the execution of long running tasks on a set of servers.
The users can see the available servers, with their current load and information of the current tasks. Users
can queue up for time slots, they are notified where there are free resources.

First the tasks will need to be run manually, but it will be also possible to schedule predefined tasks for
execution. 

## Dependencies to install for development:

sudo gem install rails -v 2.3.8
sudo gem install rspec -v 1.3.0
sudo gem install rspec-rails -v 1.3.2
sudo gem install autotest-rails -v 4.1.0
sudo gem install factory_girl -v 1.2.3
sudo gem install webrat -v 0.7.0
sudo gem install launchy -v 0.3.5

### Optional gems:

sudo gem install heroku
sudo gem install taps

OS X:
sudo gem install sqlite3-ruby -v 1.2.5 #already installed on Mac(?)
sudo gem install autotest-fsevent -v 0.1.1
sudo gem install autotest-growl -v 0.2.0

Linux:
sudo apt-get install sqlite3
sudo apt-get install libsqlite3-dev
sudo gem install sqlite3-ruby


## Start:

script/server

## Links:

http://www.railstutorial.org