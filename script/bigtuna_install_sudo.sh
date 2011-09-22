# Some prereqs that we'll need
yum -y install git
yum -y install svn
yum -y install ruby-rdoc ruby-devel
yum -y install sqlite-devel
yum -y install screen
yum -y install make gcc gcc-c++ kernel-devel

# create a new user for bigtuna to run under
useradd tuna
cd /home/tuna