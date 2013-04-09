#!pydsl

znc_user = 'znc'
znc_port = '7000'
packages = ['znc', 'znc-extra', 'znc-python']

znc_backport = '/etc/apt/preferences.d/znc-backport.pref'
state(znc_backport)\
  .file.managed(source='salt://znc/files{}'.format(znc_backport),
                template='jinja',
                packages=packages)

state('znc')\
  .pkg.latest(pkgs=packages)\
  .require(file=znc_backport)

home_dir = '/home/{}'.format(znc_user)
state(znc_user)\
  .user.present(gid_from_name=True,
                password='!',
                system=True,
                shell='/bin/bash',
                home=home_dir)

state(home_dir)\
  .file.directory(user=znc_user,
                  group=znc_user)\
  .require(user=znc_user)

dot_znc = '{}/.znc'.format(home_dir)
state(dot_znc)\
  .file.directory(user=znc_user,
                  group=znc_user)\
  .require(file=home_dir)

pem_file = '{}/znc.pem'.format(dot_znc)
state(pem_file)\
  .file.managed(source='salt://znc/files{}'.format(pem_file),
                user=znc_user,
                group=znc_user,
                mode='0400')\
  .require(file=dot_znc)

freenode_servers = [
    'asimov.freenode.net',
    'card.freenode.net',
    'hubbard.freenode.net',
    'moorcock.freenode.net',
    'morgan.freenode.net',
    'niven.freenode.net',
    'verne.freenode.net',
    'wright.freenode.net',
    'zelazny.freenode.net',
]
interesting_channels = [
    '##sr',
]
conf_file = '{}/znc.conf'.format(dot_znc)
state(conf_file)\
  .file.managed(source='salt://znc/files{}'.format(pem_file),
                user=znc_user,
                group=znc_user,
                mode='0400',
                users=__pillar__['users'],
                freenode_servers=freenode_servers
            )\
  .require(file=dot_znc)
