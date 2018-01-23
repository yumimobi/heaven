from fabric.api import env
from fabric.context_managers import cd
from fabric.operations import run, local, put

env.user = 'adxopt'
env.port = '6008'
env.roledefs.update({
    'production': ['localhost']
})

# Heaven will execute
# fab -R production deploy:branch_name=master
# or
# fab -H ip deploy:branch_name=master,payload='{"key":"val"}'
def deploy(branch_name, payload=''):
    print("Executing on %s as %s" % (env.host, env.user))

    codedir = '/data/adx/heaven'
    run('rm -rf %s' % codedir)
    run('mkdir -p %s' % codedir)

    local('git archive --format=tar --output=/tmp/archive.tar %s' % branch_name)
    put('/tmp/archive.tar')
    local('rm /tmp/archive.tar')

    run('tar xf archive.tar -C %s' % codedir)
    run('rm archive.tar')

    with cd(codedir):
        run('bundle install')
        run('RAILS_ENV=production rake db:migrate')

    run('supervisorctl restart heaven:')

def rollback(branch_name, payload={}):
    print("rollback to ref %s" % branch_name)
    print(payload)
