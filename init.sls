{% set packages = ('znc', 'znc-extra', 'znc-python') %}

{% set znc_backport = '/etc/apt/preferences.d/znc-backport.pref' %}
{{ znc_backport }}:
  file.managed:
    - source: salt://znc/files{{ znc_backport }}
    - template: jinja
    - packages: {{ packages }}

znc:
  pkg.latest:
    - pkgs:
      {% for package in packages %}
      - {{ package }}
      {% endfor %}
    - require:
      - file: {{ znc_backport }}
