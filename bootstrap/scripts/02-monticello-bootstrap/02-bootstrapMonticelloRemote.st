| mcPackages |
mcPackages := #(
 'Network-Kernel'
 'Network-MIME'
 'Network-Protocols'

 'MonticelloRemoteRepositories'

 'Zinc-HTTP'
 'Zodiac-Core'
 ).

(MonticelloBootstrap inDirectory: (CommandLineArguments new optionAt: 'BOOTSTRAP_PACKAGE_CACHE_DIR' ifAbsent: [ MCCacheRepository uniqueInstance directory ]) asFileReference)
  loadPackagesNamed: mcPackages!

ZnConstants initialize.
