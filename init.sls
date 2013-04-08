#!pydsl

packages = ['znc', 'znc-extra', 'znc-python']

znc_backport = '/etc/apt/preferences.d/znc-backport.pref'
state(znc_backport)\
  .file.managed(source='salt://znc/files{}'.format(znc_backport),
                template='jinja',
                packages=packages)

state('znc')\
  .pkg.latest(pkgs=packages)\
  .require(file=znc_backport)

irc_home_dir='/home/irc'
state('irc')\
  .user.present(gid_from_name=True,
                password='!',
                system=True,
                shell='/bin/bash',
                home=irc_home_dir)

state(irc_home_dir)\
  .file.directory(user='irc',
                  group='irc')\
  .require(file='irc')
