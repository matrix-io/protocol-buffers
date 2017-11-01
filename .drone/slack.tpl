{{#success build.status}}
  {{build.author}} just built `{{repo.name}}:{{build.branch}}` from <%%DRONE_COMMIT_LINK%%|#{{truncate build.commit 8}}>
  :new: {{build.message}}
  :debian: `libmatrixio-protos_%%DISTRIBUTION%%-%%CODENAME%%-%%PKG_VER%%_armhf.deb` 
  :debian: `libmatrixio-protos-dev_%%DISTRIBUTION%%-%%CODENAME%%-%%PKG_VER%%_armhf.deb` 
  were published to `apt.matrix.one/%%DISTRIBUTION%% %%CODENAME%% %%COMPONENT%%`
{{else}}
  {{build.author}} just broke the build of `{{repo.name}}:{{build.branch}}` with <%%DRONE_COMMIT_LINK%%|#{{truncate build.commit 8}}>
  :new: :zombie: {{build.message}}
  :debian: `libmatrixio-protos_%%DISTRIBUTION%%-%%CODENAME%%-%%PKG_VER%%_armhf.deb` 
  :debian: `libmatrixio-protos-dev_%%DISTRIBUTION%%-%%CODENAME%%-%%PKG_VER%%_armhf.deb` 
  failed to build
{{/success}}
:stopwatch: {{ since build.started}}
:gear: {{build.link}}
