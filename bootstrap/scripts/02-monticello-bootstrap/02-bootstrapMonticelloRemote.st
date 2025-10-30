| mcPackages |
mcPackages := BaselineOfMonticello remoteRepositoriesPackageNames.

(MonticelloBootstrap inDirectory: (CommandLineArguments new optionAt: 'BOOTSTRAP_PACKAGE_CACHE_DIR' ifAbsent: [ MCCacheRepository uniqueInstance directory ]) asFileReference)
  loadPackagesNamed: mcPackages!

ZnConstants initialize.
