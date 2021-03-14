# Rsync usage doc by Mani Kumar

This usage doc is tested with `rsync  version 3.1.3` on Ubuntu Focal Fossa.

## Basic usage

rsync \[OPTIONS\] \$SRC \$DST

* Provides more functions than simple `scp/cp` commands.
* Can be used for local directory syncing.

## Advanced usage

Rsync used to sync large source codes.

### Include/Exclude patterns on command line

```bash
rsync -zamvh \
--include "*/" \
--include="*.cpp" \
--include="*.c" \
--include="*.h" \
--include="*.am" \
--include="*.cfg" \
--exclude="build/*" \
--exclude=".git/*" \
$SRC $DST
```

#### More info about rsync options used

-z, --compress, compress file data during the transfer\
-a, --archive, archive mode; equals -rlptgoD (no -H,-A,-X)\
-m, --prune-empty-dirs, prune empty directory chains from file-list\
-v, --verbose, increase verbosity\
-h, --human-readable, output numbers in a human-readable format\
-l, --links, copy symlinks as symlinks\
-L, --copy-links, transform symlink into referent file/dir

### Include/Exclude patterns from text file

```bash
rsync -zauvh \
--include-from=rsync_include_patterns.txt \
--exclude-from=rsync_exclude_patterns.txt \
$SRC $DST
```

## Sample rsync include/exclude patterns

```bash
$ cat rsync_include_patterns.txt
*/
*.h
*.hh
*.hxx
*.c
*.cc
*.cpp
*.cxx
*.am
*.sh
*.py
configure.ac
CMakeLists.txt
CMakeLists.txt.in
```

```bash
$ cat rsync_exclude_patterns.txt
.git
CVS
*
```

## Sample working rsync aliases

```bash
export RSYNC_HOME=$HOME/.rsync_data

alias rsync-m="rsync -zamvh --no-l \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-n="rsync -n -zamvh --no-l \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-lm="rsync -zamvh --no-l -L \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-ln="rsync -n -zamvh --no-l -L \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-lmw="rsync -zamvh --no-l -L \
--exclude=$EXCLUDE_PATTERN \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"

alias rsync-lnw="rsync -n -zamvh --no-l -L \
--exclude=$EXCLUDE_PATTERN \
--include-from=$RSYNC_HOME/rsync_include_patterns.txt \
--exclude-from=$RSYNC_HOME/rsync_exclude_patterns.txt"
```

## Working examples

```bash
# pwd: ~/my_ws
rsync-lm my_remote:~/remote-repos/repo_1/ repo_1/
rsync-lm my_remote:~/remote-repos/repo_2/ repo_2/

rsync-lm my_remote:/home/aUser/aRepo1/aFolder2/ aFolder2/
```

## Tips

1. Always use rsync from a wrapper script to avoid misplacing $SRC and $DST
   directories. It leads to serious serious loss of data.
2. Create and use aliases to rsync options for faster command line usage.
