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