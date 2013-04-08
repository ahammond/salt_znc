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
