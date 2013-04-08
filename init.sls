#!pydsl

znc_user = 'irc'
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
