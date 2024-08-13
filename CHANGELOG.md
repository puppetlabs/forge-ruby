# Changelog

## [5.0.4](https://github.com/puppetlabs/forge-ruby/tree/5.0.4) (2024-08-13)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v5.0.3...5.0.4)

**Fixed bugs:**

- Pin minitar version to \< 1.0.0 to keep project working [\#119](https://github.com/puppetlabs/forge-ruby/pull/119) ([der-eismann](https://github.com/der-eismann))

## [v5.0.3](https://github.com/puppetlabs/forge-ruby/tree/v5.0.3) (2023-10-13)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v5.0.1...v5.0.3)

**Merged pull requests:**

- Release prep v5.0.3 [\#118](https://github.com/puppetlabs/forge-ruby/pull/118) ([github-actions[bot]](https://github.com/apps/github-actions))
- archiving older changelog [\#117](https://github.com/puppetlabs/forge-ruby/pull/117) ([malikparvez](https://github.com/malikparvez))
- Update README.md for gem release process [\#116](https://github.com/puppetlabs/forge-ruby/pull/116) ([malikparvez](https://github.com/malikparvez))
- Adding vendor in gitignore [\#114](https://github.com/puppetlabs/forge-ruby/pull/114) ([malikparvez](https://github.com/malikparvez))
- Adding release automations and labeller [\#112](https://github.com/puppetlabs/forge-ruby/pull/112) ([malikparvez](https://github.com/malikparvez))
- Releasing v5.0.2 with thread safety fix [\#111](https://github.com/puppetlabs/forge-ruby/pull/111) ([binford2k](https://github.com/binford2k))
- Adding spec for thread safety [\#110](https://github.com/puppetlabs/forge-ruby/pull/110) ([malikparvez](https://github.com/malikparvez))
- Make Digest subclass lookup thread-safe in lru\_cache [\#109](https://github.com/puppetlabs/forge-ruby/pull/109) ([cmd-ntrf](https://github.com/cmd-ntrf))

## [v5.0.1](https://github.com/puppetlabs/forge-ruby/tree/v5.0.1) (2023-07-10)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v5.0.0...v5.0.1)

**Merged pull requests:**

- \(PF-2540\) Updating changelog to push new version [\#108](https://github.com/puppetlabs/forge-ruby/pull/108) ([owenbeckles](https://github.com/owenbeckles))
- \(PF-2540\) Updating README [\#107](https://github.com/puppetlabs/forge-ruby/pull/107) ([owenbeckles](https://github.com/owenbeckles))

## [v5.0.0](https://github.com/puppetlabs/forge-ruby/tree/v5.0.0) (2023-06-07)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v4.1.0...v5.0.0)

**Implemented enhancements:**

- Add LRU cache for HTTP response caching [\#105](https://github.com/puppetlabs/forge-ruby/pull/105) ([hsnodgrass](https://github.com/hsnodgrass))

**Merged pull requests:**

- Update CODEOWNERS [\#106](https://github.com/puppetlabs/forge-ruby/pull/106) ([binford2k](https://github.com/binford2k))
- Raise ModuleNotFound if a module is not found [\#104](https://github.com/puppetlabs/forge-ruby/pull/104) ([ekohl](https://github.com/ekohl))
- Ruby 3.2 support [\#103](https://github.com/puppetlabs/forge-ruby/pull/103) ([ekohl](https://github.com/ekohl))

## [v4.1.0](https://github.com/puppetlabs/forge-ruby/tree/v4.1.0) (2023-02-21)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- \(CONT-643\) Add upload method functionality [\#102](https://github.com/puppetlabs/forge-ruby/pull/102) ([chelnak](https://github.com/chelnak))

**Merged pull requests:**

- Allows the user to search by an array of endorsements [\#100](https://github.com/puppetlabs/forge-ruby/pull/100) ([binford2k](https://github.com/binford2k))

## [v4.0.0](https://github.com/puppetlabs/forge-ruby/tree/v4.0.0) (2022-12-01)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v3.2.0...v4.0.0)

**Implemented enhancements:**

- add snyk action [\#95](https://github.com/puppetlabs/forge-ruby/pull/95) ([LivingInSyn](https://github.com/LivingInSyn))

**Merged pull requests:**

- \(maint\) Release prep for 4.0.0 [\#101](https://github.com/puppetlabs/forge-ruby/pull/101) ([barriserloth](https://github.com/barriserloth))
- Move to Faraday 2.x, which requires Ruby 2.6+ [\#99](https://github.com/puppetlabs/forge-ruby/pull/99) ([ekohl](https://github.com/ekohl))

## [v3.2.0](https://github.com/puppetlabs/forge-ruby/tree/v3.2.0) (2021-11-09)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v3.1.0...v3.2.0)

**Merged pull requests:**

- \(MAINT\) Release prep for 3.2.0 [\#94](https://github.com/puppetlabs/forge-ruby/pull/94) ([caseywilliams](https://github.com/caseywilliams))
- \(FORGE-514\) Follow redirects from the forge API [\#92](https://github.com/puppetlabs/forge-ruby/pull/92) ([binford2k](https://github.com/binford2k))
- Remove unused gettext-setup dependency [\#91](https://github.com/puppetlabs/forge-ruby/pull/91) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.0](https://github.com/puppetlabs/forge-ruby/tree/v3.1.0) (2021-08-20)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v3.0.0...v3.1.0)

**Merged pull requests:**

- \(MAINT\) Update changelog and version for 3.1.0 [\#90](https://github.com/puppetlabs/forge-ruby/pull/90) ([caseywilliams](https://github.com/caseywilliams))
- \(PF-2437\) Prepend 'Bearer' string to authorization [\#89](https://github.com/puppetlabs/forge-ruby/pull/89) ([caseywilliams](https://github.com/caseywilliams))
- Purge trailing whitespace from gemspec file [\#88](https://github.com/puppetlabs/forge-ruby/pull/88) ([bastelfreak](https://github.com/bastelfreak))
- \(PF-2137\) Remove harmful terminology [\#87](https://github.com/puppetlabs/forge-ruby/pull/87) ([nkanderson](https://github.com/nkanderson))

## [v3.0.0](https://github.com/puppetlabs/forge-ruby/tree/v3.0.0) (2021-01-28)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.3.4...v3.0.0)

**Merged pull requests:**

- \(FORGE-575\) Updates for Faraday 1.x [\#86](https://github.com/puppetlabs/forge-ruby/pull/86) ([scotje](https://github.com/scotje))
- \(PF-2133\) Update action workflow to point to new default branch [\#85](https://github.com/puppetlabs/forge-ruby/pull/85) ([nkanderson](https://github.com/nkanderson))
- \(maint\) Updated specs to go along with \#82 [\#84](https://github.com/puppetlabs/forge-ruby/pull/84) ([binford2k](https://github.com/binford2k))

## [v2.3.4](https://github.com/puppetlabs/forge-ruby/tree/v2.3.4) (2020-03-31)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.3.3...v2.3.4)

**Merged pull requests:**

- \(MAINT\) Release prep for v2.3.4 [\#83](https://github.com/puppetlabs/forge-ruby/pull/83) ([caseywilliams](https://github.com/caseywilliams))
- \(maint\) update the Forge api hostname [\#82](https://github.com/puppetlabs/forge-ruby/pull/82) ([binford2k](https://github.com/binford2k))
- fix ruby 2.7 warning about "deprecated Object\#=~" [\#81](https://github.com/puppetlabs/forge-ruby/pull/81) ([aerickson](https://github.com/aerickson))
- \(MAINT\) Allow newer versions of faraday\_middleware [\#80](https://github.com/puppetlabs/forge-ruby/pull/80) ([aerickson](https://github.com/aerickson))

## [v2.3.3](https://github.com/puppetlabs/forge-ruby/tree/v2.3.3) (2020-02-20)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.3.2...v2.3.3)

**Merged pull requests:**

- \(MAINT\) Release prep for 2.3.3 [\#79](https://github.com/puppetlabs/forge-ruby/pull/79) ([caseywilliams](https://github.com/caseywilliams))
- \(MAINT\) Allow newer versions of faraday [\#78](https://github.com/puppetlabs/forge-ruby/pull/78) ([caseywilliams](https://github.com/caseywilliams))

## [v2.3.2](https://github.com/puppetlabs/forge-ruby/tree/v2.3.2) (2020-02-05)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.3.1...v2.3.2)

**Merged pull requests:**

- \(MAINT\) Release prep for 2.3.2 [\#76](https://github.com/puppetlabs/forge-ruby/pull/76) ([caseywilliams](https://github.com/caseywilliams))
- \(RK-358\) Handle TimeoutErrors from Faraday [\#75](https://github.com/puppetlabs/forge-ruby/pull/75) ([Magisus](https://github.com/Magisus))
- Add Ruby 2.7 to GitHub Actions testmatrix [\#74](https://github.com/puppetlabs/forge-ruby/pull/74) ([bastelfreak](https://github.com/bastelfreak))
- \(MAINT\) Remove ruby 2.3 github checks [\#72](https://github.com/puppetlabs/forge-ruby/pull/72) ([caseywilliams](https://github.com/caseywilliams))
- allow faraday\_middleware 0.13.X [\#71](https://github.com/puppetlabs/forge-ruby/pull/71) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.1](https://github.com/puppetlabs/forge-ruby/tree/v2.3.1) (2019-11-15)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.3.0...v2.3.1)

**Merged pull requests:**

- \(MAINT\) Release prep for 2.3.1 [\#70](https://github.com/puppetlabs/forge-ruby/pull/70) ([scotje](https://github.com/scotje))
- \(PE-27712\) Allow faraday to go to version 0.14.0 [\#69](https://github.com/puppetlabs/forge-ruby/pull/69) ([Magisus](https://github.com/Magisus))
- \(MAINT\) Switch to Github Actions based CI config [\#68](https://github.com/puppetlabs/forge-ruby/pull/68) ([scotje](https://github.com/scotje))
- \(MAINT\) Add CODEOWNERS and remove MAINTAINERS [\#64](https://github.com/puppetlabs/forge-ruby/pull/64) ([nkanderson](https://github.com/nkanderson))
- \(MAINT\) Add Slack notifications to \#prod-forge channel [\#63](https://github.com/puppetlabs/forge-ruby/pull/63) ([scotje](https://github.com/scotje))

## [v2.3.0](https://github.com/puppetlabs/forge-ruby/tree/v2.3.0) (2019-07-10)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.3.0.rc1...v2.3.0)

**Merged pull requests:**

- \(MAINT\) Move deploy to distinct build stage and update api\_key [\#62](https://github.com/puppetlabs/forge-ruby/pull/62) ([scotje](https://github.com/scotje))
- \(MAINT\) Release prep for 2.3.0 [\#61](https://github.com/puppetlabs/forge-ruby/pull/61) ([scotje](https://github.com/scotje))
- \(FORGE-360\) Add `allow_md5` param to Release\#verify method [\#60](https://github.com/puppetlabs/forge-ruby/pull/60) ([scotje](https://github.com/scotje))
- \(MAINT\) Add deploy step to travis config [\#59](https://github.com/puppetlabs/forge-ruby/pull/59) ([scotje](https://github.com/scotje))
- \(MAINT\) Add .travis.yml config [\#58](https://github.com/puppetlabs/forge-ruby/pull/58) ([scotje](https://github.com/scotje))
- \(FORGE-360\) Verify downloads using file\_sha256 if available [\#57](https://github.com/puppetlabs/forge-ruby/pull/57) ([scotje](https://github.com/scotje))

## [v2.3.0.rc1](https://github.com/puppetlabs/forge-ruby/tree/v2.3.0.rc1) (2019-07-10)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.9...v2.3.0.rc1)

## [v2.2.9](https://github.com/puppetlabs/forge-ruby/tree/v2.2.9) (2017-12-01)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.8...v2.2.9)

**Merged pull requests:**

- \(MAINT\) Release prep for 2.2.9 [\#56](https://github.com/puppetlabs/forge-ruby/pull/56) ([scotje](https://github.com/scotje))
- \(MAINT\) Make spec tests backwards compatible with old faraday versions [\#55](https://github.com/puppetlabs/forge-ruby/pull/55) ([scotje](https://github.com/scotje))
- \(MAINT\) Fix up usage of deprecated Faraday method in spec tests [\#54](https://github.com/puppetlabs/forge-ruby/pull/54) ([scotje](https://github.com/scotje))
- Allow for higher versions of faraday [\#53](https://github.com/puppetlabs/forge-ruby/pull/53) ([charlesdunbar](https://github.com/charlesdunbar))

## [v2.2.8](https://github.com/puppetlabs/forge-ruby/tree/v2.2.8) (2017-11-09)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.7...v2.2.8)

**Implemented enhancements:**

- \(RK-306\) Add helper method in puppet\_forge for valid semantic version. [\#51](https://github.com/puppetlabs/forge-ruby/pull/51) ([andersonmills](https://github.com/andersonmills))

**Merged pull requests:**

- \(MAINT\) Prepare for 2.2.8. [\#52](https://github.com/puppetlabs/forge-ruby/pull/52) ([andersonmills](https://github.com/andersonmills))

## [v2.2.7](https://github.com/puppetlabs/forge-ruby/tree/v2.2.7) (2017-06-30)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.6...v2.2.7)

**Merged pull requests:**

- \(MAINT\) Release prep for 2.2.7. [\#49](https://github.com/puppetlabs/forge-ruby/pull/49) ([scotje](https://github.com/scotje))
- Use SemanticPuppet v1.0 [\#48](https://github.com/puppetlabs/forge-ruby/pull/48) ([austb](https://github.com/austb))

## [v2.2.6](https://github.com/puppetlabs/forge-ruby/tree/v2.2.6) (2017-06-27)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.5...v2.2.6)

**Merged pull requests:**

- Coerce PuppetForge.host to String [\#47](https://github.com/puppetlabs/forge-ruby/pull/47) ([scotje](https://github.com/scotje))

## [v2.2.5](https://github.com/puppetlabs/forge-ruby/tree/v2.2.5) (2017-06-26)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.4...v2.2.5)

**Merged pull requests:**

- \(FORGE-383\) Fix release download\_url calculation for hosts with a path prefix [\#45](https://github.com/puppetlabs/forge-ruby/pull/45) ([scotje](https://github.com/scotje))

## [v2.2.4](https://github.com/puppetlabs/forge-ruby/tree/v2.2.4) (2017-04-17)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.3...v2.2.4)

**Implemented enhancements:**

- \(MAINT\) Add ability to set Accept-Language header for API requests. [\#43](https://github.com/puppetlabs/forge-ruby/pull/43) ([scotje](https://github.com/scotje))

## [v2.2.3](https://github.com/puppetlabs/forge-ruby/tree/v2.2.3) (2017-01-17)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v1.0.6...v2.2.3)

**Implemented enhancements:**

- Prefix support [\#41](https://github.com/puppetlabs/forge-ruby/pull/41) ([scotje](https://github.com/scotje))

**Merged pull requests:**

- \(MAINT\) Bump gettext-setup to latest. [\#42](https://github.com/puppetlabs/forge-ruby/pull/42) ([scotje](https://github.com/scotje))
- Fix connection test for some random orders [\#39](https://github.com/puppetlabs/forge-ruby/pull/39) ([austb](https://github.com/austb))

## [v1.0.6](https://github.com/puppetlabs/forge-ruby/tree/v1.0.6) (2016-07-25)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.2...v1.0.6)

## [v2.2.2](https://github.com/puppetlabs/forge-ruby/tree/v2.2.2) (2016-07-06)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.1...v2.2.2)

**Merged pull requests:**

- \(CODEMGMT-725\) Externalize strings for i18n [\#35](https://github.com/puppetlabs/forge-ruby/pull/35) ([austb](https://github.com/austb))
- \(CODEMGMT-731\) Add maintainers to README [\#34](https://github.com/puppetlabs/forge-ruby/pull/34) ([austb](https://github.com/austb))

## [v2.2.1](https://github.com/puppetlabs/forge-ruby/tree/v2.2.1) (2016-05-24)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.2.0...v2.2.1)

**Merged pull requests:**

- \(MAINT\) Release prep for 2.2.1. [\#33](https://github.com/puppetlabs/forge-ruby/pull/33) ([scotje](https://github.com/scotje))
- \(RK-245\) Treat proxy value of empty string as nil. [\#32](https://github.com/puppetlabs/forge-ruby/pull/32) ([scotje](https://github.com/scotje))
- \(CODEMGMT-718\) Safely handle Faraday::ClientError with a nil response. [\#31](https://github.com/puppetlabs/forge-ruby/pull/31) ([scotje](https://github.com/scotje))

## [v2.2.0](https://github.com/puppetlabs/forge-ruby/tree/v2.2.0) (2016-05-10)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.1.5...v2.2.0)

**Merged pull requests:**

- \(MAINT\) Release prep for 2.2.0. [\#30](https://github.com/puppetlabs/forge-ruby/pull/30) ([scotje](https://github.com/scotje))

## [v2.1.5](https://github.com/puppetlabs/forge-ruby/tree/v2.1.5) (2016-04-13)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.1.4...v2.1.5)

**Merged pull requests:**

- Improve proxy configuration method [\#29](https://github.com/puppetlabs/forge-ruby/pull/29) ([scotje](https://github.com/scotje))

## [v2.1.4](https://github.com/puppetlabs/forge-ruby/tree/v2.1.4) (2016-04-01)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.1.3...v2.1.4)

**Merged pull requests:**

- \(maint\) Version update [\#28](https://github.com/puppetlabs/forge-ruby/pull/28) ([andersonmills](https://github.com/andersonmills))
- \(CODEMGMT-659\) Change to use minitar entry's full\_name [\#27](https://github.com/puppetlabs/forge-ruby/pull/27) ([andersonmills](https://github.com/andersonmills))
- \(RK-218\) stateless connection opts [\#26](https://github.com/puppetlabs/forge-ruby/pull/26) ([andersonmills](https://github.com/andersonmills))

## [v2.1.3](https://github.com/puppetlabs/forge-ruby/tree/v2.1.3) (2016-01-26)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.1.2...v2.1.3)

**Merged pull requests:**

- Use release.file\_uri to download releases instead of hard-coded path. [\#25](https://github.com/puppetlabs/forge-ruby/pull/25) ([scotje](https://github.com/scotje))

## [v2.1.2](https://github.com/puppetlabs/forge-ruby/tree/v2.1.2) (2015-12-17)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.1.1...v2.1.2)

**Merged pull requests:**

- \(FORGE-297\) Update gemspec dependency for faraday\_middleware 0.10.x. [\#23](https://github.com/puppetlabs/forge-ruby/pull/23) ([scotje](https://github.com/scotje))

## [v2.1.1](https://github.com/puppetlabs/forge-ruby/tree/v2.1.1) (2015-10-06)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.1.0...v2.1.1)

**Merged pull requests:**

- \(maint\) Publishing v2.1.1 [\#22](https://github.com/puppetlabs/forge-ruby/pull/22) ([andersonmills](https://github.com/andersonmills))
- \(RK-170\) Bad error on missing release. [\#21](https://github.com/puppetlabs/forge-ruby/pull/21) ([andersonmills](https://github.com/andersonmills))

## [v2.1.0](https://github.com/puppetlabs/forge-ruby/tree/v2.1.0) (2015-08-27)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v2.0.0...v2.1.0)

**Merged pull requests:**

- \(CODEMGMT-307\) Update puppet\_forge gem for use with r10k [\#20](https://github.com/puppetlabs/forge-ruby/pull/20) ([andersonmills](https://github.com/andersonmills))
- \(maint\) Merge 2.0.x branch onto master [\#18](https://github.com/puppetlabs/forge-ruby/pull/18) ([andersonmills](https://github.com/andersonmills))

## [v2.0.0](https://github.com/puppetlabs/forge-ruby/tree/v2.0.0) (2015-08-14)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v1.0.5...v2.0.0)

**Implemented enhancements:**

- \(CODEMGMT-308\) Add hash keys to symbols middleware [\#14](https://github.com/puppetlabs/forge-ruby/pull/14) ([austb](https://github.com/austb))
- \(CODEMGMT-296\) Add PaginatedCollection ORM for where request [\#11](https://github.com/puppetlabs/forge-ruby/pull/11) ([austb](https://github.com/austb))
- Add ORM for individual item \(User/Module/Release\) [\#10](https://github.com/puppetlabs/forge-ruby/pull/10) ([austb](https://github.com/austb))

**Merged pull requests:**

- Add Changelog and update the README [\#17](https://github.com/puppetlabs/forge-ruby/pull/17) ([austb](https://github.com/austb))
- Fix functionality for puppet-forge-web [\#16](https://github.com/puppetlabs/forge-ruby/pull/16) ([austb](https://github.com/austb))
- \(CODEMGMT-309\) Add MAINTAINERS file to the project. [\#15](https://github.com/puppetlabs/forge-ruby/pull/15) ([austb](https://github.com/austb))
- Lazy access for missing information [\#13](https://github.com/puppetlabs/forge-ruby/pull/13) ([austb](https://github.com/austb))
- \(CODEMGMT-297\) Integrate ModuleRelease from r10k [\#12](https://github.com/puppetlabs/forge-ruby/pull/12) ([austb](https://github.com/austb))
- Remove Her and issue simple find/where requests [\#9](https://github.com/puppetlabs/forge-ruby/pull/9) ([austb](https://github.com/austb))

## [v1.0.5](https://github.com/puppetlabs/forge-ruby/tree/v1.0.5) (2015-07-23)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v1.0.4...v1.0.5)

**Merged pull requests:**

- \(CODEMGMT-279\) Specify versions for Her and Rspec. [\#7](https://github.com/puppetlabs/forge-ruby/pull/7) ([austb](https://github.com/austb))
- Use SPDX License format [\#5](https://github.com/puppetlabs/forge-ruby/pull/5) ([tampakrap](https://github.com/tampakrap))

## [v1.0.4](https://github.com/puppetlabs/forge-ruby/tree/v1.0.4) (2014-12-17)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v1.0.3...v1.0.4)

**Merged pull requests:**

- Remove "require 'bundler/setup'" [\#4](https://github.com/puppetlabs/forge-ruby/pull/4) ([voidus](https://github.com/voidus))

## [v1.0.3](https://github.com/puppetlabs/forge-ruby/tree/v1.0.3) (2014-06-23)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v1.0.2...v1.0.3)

**Merged pull requests:**

- Make fixture filenames Windows compatible. [\#3](https://github.com/puppetlabs/forge-ruby/pull/3) ([scotje](https://github.com/scotje))

## [v1.0.2](https://github.com/puppetlabs/forge-ruby/tree/v1.0.2) (2014-06-13)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v1.0.1...v1.0.2)

**Merged pull requests:**

- Only require bundler/setup if Bundler is installed. [\#2](https://github.com/puppetlabs/forge-ruby/pull/2) ([scotje](https://github.com/scotje))

## [v1.0.1](https://github.com/puppetlabs/forge-ruby/tree/v1.0.1) (2014-06-02)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/v1.0.0...v1.0.1)

**Merged pull requests:**

- Improve handling of error responses from Forge API [\#1](https://github.com/puppetlabs/forge-ruby/pull/1) ([scotje](https://github.com/scotje))

## [v1.0.0](https://github.com/puppetlabs/forge-ruby/tree/v1.0.0) (2014-05-16)

[Full Changelog](https://github.com/puppetlabs/forge-ruby/compare/2f052f220f0b3f4e135d930491edecf222fc059f...v1.0.0)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
