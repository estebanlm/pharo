| mcPackages |
mcPackages := #(
 'Zinc-Resource-Meta-Core'
 'STON-Core'
 'MonticelloFileTree-Core'
 'Metacello-Base'
 'Metacello-Core'
 'Metacello-CommandLine'
 ).

MonticelloBootstrap new loadPackagesNamed: mcPackages!

"The next deprecations were added in the development of Pharo14. They can be removed in the future."
MetacelloBaselineOfProjectSpec deprecatedAliases: #( #MetacelloMCBaselineOfProjectSpec ).
MetacelloNamelessProjectSpec deprecatedAliases: #( #MetacelloMCNamelessProjectSpec ).
MetacelloBaselineProject deprecatedAliases: #( #MetacelloMCBaselineProject ).
