"For now, it happens that the bootstrap does not caches the pragmas. This should be fixed later by reloading the packages after Metacello and Monticello are reloaded but we need them for reseting the system announcer for example."
CompiledMethod allInstancesDo: [ :m | m cachePragmas ].

SystemAnnouncer restoreAllNotifications.

ZnMimeType initialize.

"The next deprecations were added in the development of Pharo14. They can be removed in the future."
MetacelloBaselineOfProjectSpec deprecatedAliases: #( #MetacelloMCBaselineOfProjectSpec ).
MetacelloNamelessProjectSpec deprecatedAliases: #( #MetacelloMCNamelessProjectSpec ).
MetacelloBaselineProject deprecatedAliases: #( #MetacelloMCBaselineProject ).
